# Clean Architecture สำหรับ Backend - คู่มือฉบับสมบูรณ์

> เอกสารอธิบาย Clean Architecture Principles และการนำมาประยุกต์ใช้กับ NestJS Backend

## 📑 สารบัญ

1. [Clean Architecture คืออะไร](#clean-architecture-คืออะไร)
2. [หลักการพื้นฐาน](#หลักการพื้นฐาน)
3. [Layers และ Components](#layers-และ-components)
4. [Dependency Rule](#dependency-rule)
5. [การนำไปใช้กับ NestJS](#การนำไปใช้กับ-nestjs)
6. [โครงสร้างโปรเจคแบบ Clean Architecture](#โครงสร้างโปรเจคแบบ-clean-architecture)
7. [ตัวอย่างการ Refactor](#ตัวอย่างการ-refactor)
8. [Best Practices](#best-practices)
9. [ข้อดีและข้อเสีย](#ข้อดีและข้อเสีย)

---

## Clean Architecture คืออะไร

### ความหมาย

**Clean Architecture** เป็นแนวทางการออกแบบซอฟต์แวร์ที่เสนอโดย Robert C. Martin (Uncle Bob) เพื่อสร้างระบบที่:

- **แยกส่วนชัดเจน** (Separation of Concerns)
- **ไม่ขึ้นกับ Framework** (Framework Independence)
- **ทดสอบง่าย** (Testable)
- **ไม่ขึ้นกับ UI** (UI Independence)
- **ไม่ขึ้นกับ Database** (Database Independence)
- **ไม่ขึ้นกับ External Services** (External Agency Independence)

### จุดประสงค์

Clean Architecture มีเป้าหมายหลัก:

1. **ลด Coupling**: แต่ละส่วนไม่ผูกติดกันมาก
2. **เพิ่ม Cohesion**: ส่วนที่เกี่ยวข้องอยู่ด้วยกัน
3. **ง่ายต่อการทดสอบ**: แยก Business Logic จาก Infrastructure
4. **ยืดหยุ่น**: เปลี่ยนเทคโนโลยีได้ง่าย
5. **บำรุงรักษาง่าย**: โค้ดอ่านง่าย เข้าใจง่าย

---

## หลักการพื้นฐาน

### 1. Dependency Inversion Principle (DIP)

**หลักการ:** High-level modules ไม่ควรขึ้นกับ low-level modules โดยตรง ทั้งสองควรขึ้นกับ Abstractions

**ก่อนใช้ DIP:**
```typescript
// UsersService ขึ้นกับ MongoDB โดยตรง
class UsersService {
  constructor(@InjectModel(User) private userModel: Model<User>) {}
  
  async findUser(id: string) {
    return this.userModel.findById(id); // ผูกติดกับ MongoDB
  }
}
```

**หลังใช้ DIP:**
```typescript
// สร้าง Interface (Abstraction)
interface IUserRepository {
  findById(id: string): Promise<User>;
  save(user: User): Promise<User>;
}

// Service ขึ้นกับ Interface
class UsersService {
  constructor(private userRepository: IUserRepository) {}
  
  async findUser(id: string) {
    return this.userRepository.findById(id); // ไม่ผูกติดกับ Database
  }
}

// MongoDB Implementation
class MongoUserRepository implements IUserRepository {
  constructor(@InjectModel(User) private userModel: Model<User>) {}
  
  async findById(id: string) {
    return this.userModel.findById(id).exec();
  }
}
```

**ประโยชน์:**
- สามารถเปลี่ยนจาก MongoDB เป็น PostgreSQL ได้โดยไม่แก้ Service
- Test ง่าย (Mock Repository)
- Business Logic แยกจาก Database

### 2. Single Responsibility Principle (SRP)

**หลักการ:** แต่ละ class ควรมีหน้าที่เดียวและเหตุผลเดียวในการเปลี่ยนแปลง

**ผิดหลัก SRP:**
```typescript
class UserService {
  // ทำหลายอย่างในคลาสเดียว
  async createUser(data: any) {
    // 1. Validate
    if (!data.email) throw new Error('Email required');
    
    // 2. Hash password
    const hashed = await bcrypt.hash(data.password, 10);
    
    // 3. Save to database
    const user = await this.db.save(data);
    
    // 4. Send email
    await this.emailService.sendWelcome(user.email);
    
    // 5. Log activity
    await this.logger.log('User created');
    
    return user;
  }
}
```

**ถูกต้อง (แยกหน้าที่):**
```typescript
// 1. Validation - DTO ทำหน้าที่ validate
class CreateUserDto {
  @IsEmail()
  email: string;
  
  @MinLength(6)
  password: string;
}

// 2. User Service - Business logic อย่างเดียว
class UserService {
  constructor(
    private userRepository: IUserRepository,
    private passwordService: IPasswordService,
    private eventBus: IEventBus,
  ) {}
  
  async createUser(dto: CreateUserDto) {
    // Hash password
    const hashedPassword = await this.passwordService.hash(dto.password);
    
    // Create user entity
    const user = new User({ ...dto, password: hashedPassword });
    
    // Save
    const savedUser = await this.userRepository.save(user);
    
    // Publish event
    this.eventBus.publish(new UserCreatedEvent(savedUser));
    
    return savedUser;
  }
}

// 3. Event Handler - จัดการ side effects
class UserCreatedEventHandler {
  constructor(
    private emailService: IEmailService,
    private logger: ILogger,
  ) {}
  
  async handle(event: UserCreatedEvent) {
    await this.emailService.sendWelcome(event.user.email);
    await this.logger.log('User created', event.user.id);
  }
}
```

### 3. Open/Closed Principle (OCP)

**หลักการ:** Open for extension, Closed for modification

**ตัวอย่าง:**
```typescript
// ❌ ต้องแก้ไข class เมื่อเพิ่ม payment method ใหม่
class PaymentService {
  async processPayment(method: string, amount: number) {
    if (method === 'credit_card') {
      // Process credit card
    } else if (method === 'paypal') {
      // Process PayPal
    } else if (method === 'bank_transfer') {
      // Process bank transfer
    }
  }
}

// ✅ ขยายได้โดยไม่แก้ไข
interface PaymentProcessor {
  process(amount: number): Promise<void>;
}

class CreditCardProcessor implements PaymentProcessor {
  async process(amount: number) {
    // Credit card logic
  }
}

class PayPalProcessor implements PaymentProcessor {
  async process(amount: number) {
    // PayPal logic
  }
}

class PaymentService {
  private processors: Map<string, PaymentProcessor> = new Map();
  
  register(method: string, processor: PaymentProcessor) {
    this.processors.set(method, processor);
  }
  
  async processPayment(method: string, amount: number) {
    const processor = this.processors.get(method);
    if (!processor) throw new Error('Unknown payment method');
    return processor.process(amount);
  }
}
```

---

## Layers และ Components

Clean Architecture แบ่งระบบออกเป็น 4 ชั้นหลัก:

```
┌─────────────────────────────────────────────────────────┐
│                 4. Frameworks & Drivers                  │
│          (Web, Database, External Services)             │
└─────────────────────┬───────────────────────────────────┘
                      │ implements
                      ↓
┌─────────────────────────────────────────────────────────┐
│          3. Interface Adapters (Controllers)            │
│         (Controllers, Presenters, Gateways)             │
└─────────────────────┬───────────────────────────────────┘
                      │ uses
                      ↓
┌─────────────────────────────────────────────────────────┐
│           2. Application Business Rules                  │
│               (Use Cases, Services)                      │
└─────────────────────┬───────────────────────────────────┘
                      │ depends on
                      ↓
┌─────────────────────────────────────────────────────────┐
│          1. Enterprise Business Rules                    │
│                   (Entities, DTOs)                       │
└─────────────────────────────────────────────────────────┘
```

### Layer 1: Entities (Domain Layer)

**หน้าที่:** เก็บ Business Objects และ Domain Rules

**ตัวอย่าง:**
```typescript
// domain/entities/user.entity.ts
export class User {
  constructor(
    public readonly id: string,
    public email: string,
    public name: string,
    private password: string,
    public isActive: boolean = true,
    public readonly createdAt: Date = new Date(),
  ) {
    this.validate();
  }

  private validate() {
    if (!this.email.includes('@')) {
      throw new Error('Invalid email');
    }
    if (this.name.length < 2) {
      throw new Error('Name too short');
    }
  }

  // Domain methods
  deactivate() {
    this.isActive = false;
  }

  activate() {
    this.isActive = true;
  }

  updateEmail(newEmail: string) {
    if (!newEmail.includes('@')) {
      throw new Error('Invalid email');
    }
    this.email = newEmail;
  }

  // Never expose password directly
  verifyPassword(plainPassword: string, hasher: PasswordHasher): Promise<boolean> {
    return hasher.compare(plainPassword, this.password);
  }
}
```

**Domain Interfaces:**
```typescript
// domain/interfaces/repositories/user-repository.interface.ts
export interface IUserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<User>;
  delete(id: string): Promise<void>;
}

// domain/interfaces/services/password-hasher.interface.ts
export interface IPasswordHasher {
  hash(password: string): Promise<string>;
  compare(plain: string, hashed: string): Promise<boolean>;
}
```

### Layer 2: Use Cases (Application Layer)

**หน้าที่:** Application-specific Business Logic

**ตัวอย่าง:**
```typescript
// application/use-cases/create-user.usecase.ts
export class CreateUserUseCase {
  constructor(
    private userRepository: IUserRepository,
    private passwordHasher: IPasswordHasher,
    private eventPublisher: IEventPublisher,
  ) {}

  async execute(input: CreateUserInput): Promise<CreateUserOutput> {
    // 1. Check if user exists
    const existingUser = await this.userRepository.findByEmail(input.email);
    if (existingUser) {
      throw new UserAlreadyExistsError(input.email);
    }

    // 2. Hash password
    const hashedPassword = await this.passwordHasher.hash(input.password);

    // 3. Create user entity
    const user = new User(
      this.generateId(),
      input.email,
      input.name,
      hashedPassword,
    );

    // 4. Save user
    const savedUser = await this.userRepository.save(user);

    // 5. Publish event
    await this.eventPublisher.publish(new UserCreatedEvent(savedUser));

    // 6. Return output
    return {
      id: savedUser.id,
      email: savedUser.email,
      name: savedUser.name,
      createdAt: savedUser.createdAt,
    };
  }

  private generateId(): string {
    return `user_${Date.now()}_${Math.random()}`;
  }
}

// Input/Output DTOs
export interface CreateUserInput {
  email: string;
  password: string;
  name: string;
}

export interface CreateUserOutput {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
}
```

### Layer 3: Interface Adapters (Presentation Layer)

**หน้าที่:** แปลงข้อมูลระหว่าง Use Cases และ External World

**Controller:**
```typescript
// presentation/controllers/users.controller.ts
@Controller('users')
export class UsersController {
  constructor(private createUserUseCase: CreateUserUseCase) {}

  @Post()
  async createUser(@Body() dto: CreateUserDto) {
    // Convert HTTP request to Use Case input
    const input: CreateUserInput = {
      email: dto.email,
      password: dto.password,
      name: dto.name,
    };

    // Execute use case
    const output = await this.createUserUseCase.execute(input);

    // Convert Use Case output to HTTP response
    return {
      statusCode: 201,
      data: {
        id: output.id,
        email: output.email,
        name: output.name,
      },
    };
  }
}
```

**DTO (Data Transfer Object):**
```typescript
// presentation/dtos/create-user.dto.ts
export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @MinLength(6)
  @IsNotEmpty()
  password: string;

  @IsString()
  @MinLength(2)
  @MaxLength(100)
  @IsNotEmpty()
  name: string;
}
```

### Layer 4: Frameworks & Drivers (Infrastructure Layer)

**หน้าที่:** Implementation ของ Interfaces (Database, External APIs, etc.)

**Repository Implementation:**
```typescript
// infrastructure/repositories/mongo-user.repository.ts
@Injectable()
export class MongoUserRepository implements IUserRepository {
  constructor(
    @InjectModel(UserModel.name)
    private userModel: Model<UserDocument>,
  ) {}

  async findById(id: string): Promise<User | null> {
    const doc = await this.userModel.findById(id).exec();
    if (!doc) return null;
    return this.toDomain(doc);
  }

  async findByEmail(email: string): Promise<User | null> {
    const doc = await this.userModel.findOne({ email }).exec();
    if (!doc) return null;
    return this.toDomain(doc);
  }

  async save(user: User): Promise<User> {
    const doc = this.toDocument(user);
    const saved = await doc.save();
    return this.toDomain(saved);
  }

  async delete(id: string): Promise<void> {
    await this.userModel.findByIdAndDelete(id).exec();
  }

  // Mappers
  private toDomain(doc: UserDocument): User {
    return new User(
      doc._id.toString(),
      doc.email,
      doc.name,
      doc.password,
      doc.isActive,
      doc.createdAt,
    );
  }

  private toDocument(user: User): Document {
    return new this.userModel({
      _id: user.id,
      email: user.email,
      name: user.name,
      password: (user as any).password,
      isActive: user.isActive,
      createdAt: user.createdAt,
    });
  }
}
```

**Password Hasher Implementation:**
```typescript
// infrastructure/services/bcrypt-password-hasher.service.ts
@Injectable()
export class BcryptPasswordHasher implements IPasswordHasher {
  private readonly saltRounds = 10;

  async hash(password: string): Promise<string> {
    return bcrypt.hash(password, this.saltRounds);
  }

  async compare(plain: string, hashed: string): Promise<boolean> {
    return bcrypt.compare(plain, hashed);
  }
}
```

---

## Dependency Rule

### กฎที่สำคัญที่สุด

> **Dependencies ต้องชี้เข้าหาชั้นใน (Inward) เท่านั้น**

```
Outer Layers → Inner Layers
Infrastructure → Application → Domain
```

**ห้าม:**
- Domain Layer ขึ้นกับ Application Layer ❌
- Application Layer ขึ้นกับ Infrastructure Layer ❌
- Inner layers รู้จัก Outer layers ❌

**ได้:**
- Infrastructure Layer ขึ้นกับ Domain Layer ✅
- Application Layer ขึ้นกับ Domain Layer ✅
- Outer layers รู้จัก Inner layers ✅

### ตัวอย่างการฝ่าฝืนกฎ (ผิด)

```typescript
// ❌ Domain Entity ขึ้นกับ Mongoose (Infrastructure)
import { Schema, Prop } from '@nestjs/mongoose';

@Schema()
export class User {
  @Prop({ required: true })
  email: string;
}
```

### ตัวอย่างที่ถูกต้อง

```typescript
// ✅ Domain Entity เป็น Plain Class
export class User {
  constructor(
    public email: string,
    public name: string,
  ) {}
}

// ✅ Schema อยู่ใน Infrastructure Layer
@Schema()
export class UserModel {
  @Prop({ required: true })
  email: string;

  @Prop({ required: true })
  name: string;
}

// ✅ Repository แปลงระหว่าง Domain Entity และ Database Model
class MongoUserRepository {
  toDomain(model: UserModel): User {
    return new User(model.email, model.name);
  }

  toModel(entity: User): UserModel {
    const model = new UserModel();
    model.email = entity.email;
    model.name = entity.name;
    return model;
  }
}
```

---

## การนำไปใช้กับ NestJS

### Module Organization

```typescript
// users.module.ts - Dependency Injection Configuration
@Module({
  imports: [
    MongooseModule.forFeature([{ name: UserModel.name, schema: UserSchema }]),
  ],
  controllers: [
    UsersController, // Presentation Layer
  ],
  providers: [
    // Use Cases (Application Layer)
    CreateUserUseCase,
    GetUserUseCase,
    UpdateUserUseCase,

    // Infrastructure implementations
    {
      provide: 'IUserRepository',
      useClass: MongoUserRepository,
    },
    {
      provide: 'IPasswordHasher',
      useClass: BcryptPasswordHasher,
    },
    
    // Domain Services (if needed)
    UserDomainService,
  ],
  exports: [
    'IUserRepository',
    CreateUserUseCase,
    GetUserUseCase,
  ],
})
export class UsersModule {}
```

### Dependency Injection Pattern

```typescript
// Use Case รับ Interface (Abstraction)
export class CreateUserUseCase {
  constructor(
    @Inject('IUserRepository')
    private userRepository: IUserRepository,
    
    @Inject('IPasswordHasher')
    private passwordHasher: IPasswordHasher,
  ) {}
}

// Controller รับ Use Case
@Controller('users')
export class UsersController {
  constructor(
    private createUserUseCase: CreateUserUseCase,
  ) {}
}
```

---

## โครงสร้างโปรเจคแบบ Clean Architecture

### แบบที่ 1: Feature-based with Layers

```
src/
├── users/                          # Feature Module
│   ├── domain/                     # Domain Layer
│   │   ├── entities/
│   │   │   └── user.entity.ts
│   │   ├── interfaces/
│   │   │   ├── user-repository.interface.ts
│   │   │   └── password-hasher.interface.ts
│   │   └── services/
│   │       └── user-domain.service.ts
│   │
│   ├── application/                # Application Layer
│   │   ├── use-cases/
│   │   │   ├── create-user.usecase.ts
│   │   │   ├── get-user.usecase.ts
│   │   │   └── update-user.usecase.ts
│   │   └── dtos/
│   │       ├── create-user.input.ts
│   │       └── create-user.output.ts
│   │
│   ├── infrastructure/             # Infrastructure Layer
│   │   ├── repositories/
│   │   │   └── mongo-user.repository.ts
│   │   ├── schemas/
│   │   │   └── user.schema.ts
│   │   └── services/
│   │       └── bcrypt-password-hasher.ts
│   │
│   ├── presentation/               # Presentation Layer
│   │   ├── controllers/
│   │   │   └── users.controller.ts
│   │   └── dtos/
│   │       ├── create-user.dto.ts
│   │       └── update-user.dto.ts
│   │
│   └── users.module.ts
│
├── auth/                           # Another Feature
│   ├── domain/
│   ├── application/
│   ├── infrastructure/
│   ├── presentation/
│   └── auth.module.ts
│
└── shared/                         # Shared Code
    ├── domain/
    │   └── interfaces/
    ├── infrastructure/
    │   └── database/
    └── presentation/
        └── filters/
```

### แบบที่ 2: Layer-first

```
src/
├── domain/                         # Domain Layer
│   ├── entities/
│   │   ├── user.entity.ts
│   │   ├── loan.entity.ts
│   │   └── transaction.entity.ts
│   ├── interfaces/
│   │   └── repositories/
│   │       ├── user-repository.interface.ts
│   │       └── loan-repository.interface.ts
│   └── services/
│       └── domain-services.ts
│
├── application/                    # Application Layer
│   ├── use-cases/
│   │   ├── users/
│   │   │   ├── create-user.usecase.ts
│   │   │   └── get-user.usecase.ts
│   │   └── loans/
│   │       ├── create-loan.usecase.ts
│   │       └── calculate-loan.usecase.ts
│   └── dtos/
│       ├── users/
│       └── loans/
│
├── infrastructure/                 # Infrastructure Layer
│   ├── database/
│   │   ├── mongodb/
│   │   │   ├── schemas/
│   │   │   └── repositories/
│   │   └── database.module.ts
│   ├── services/
│   │   ├── bcrypt.service.ts
│   │   └── jwt.service.ts
│   └── config/
│       └── configuration.ts
│
└── presentation/                   # Presentation Layer
    ├── controllers/
    │   ├── users.controller.ts
    │   └── loans.controller.ts
    ├── dtos/
    │   ├── users/
    │   └── loans/
    └── filters/
        └── http-exception.filter.ts
```

---

## ตัวอย่างการ Refactor

### Before: Standard NestJS

```typescript
// users.service.ts
@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    private jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    // Check duplicate
    const existing = await this.userModel.findOne({ email: dto.email });
    if (existing) throw new ConflictException('User exists');

    // Hash password
    const hashed = await bcrypt.hash(dto.password, 10);

    // Save user
    const user = new this.userModel({
      email: dto.email,
      password: hashed,
      name: dto.name,
    });
    await user.save();

    // Generate token
    const token = this.jwtService.sign({
      sub: user._id,
      email: user.email,
    });

    return { user, token };
  }
}
```

**ปัญหา:**
- Service ผูกติดกับ MongoDB (Mongoose Model)
- Business Logic ปนกับ Infrastructure Code
- ทดสอบยาก (ต้อง Mock Mongoose Model)
- เปลี่ยน Database ยาก

### After: Clean Architecture

#### 1. Domain Layer

```typescript
// domain/entities/user.entity.ts
export class User {
  constructor(
    public readonly id: string,
    public email: string,
    public name: string,
    private password: string,
    public readonly createdAt: Date = new Date(),
  ) {}

  static create(email: string, password: string, name: string): User {
    // Domain validation
    if (!email.includes('@')) throw new DomainError('Invalid email');
    if (name.length < 2) throw new DomainError('Name too short');
    
    return new User(
      this.generateId(),
      email,
      name,
      password,
    );
  }

  private static generateId(): string {
    return `user_${Date.now()}`;
  }
}

// domain/interfaces/user-repository.interface.ts
export interface IUserRepository {
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<User>;
}

// domain/interfaces/password-hasher.interface.ts
export interface IPasswordHasher {
  hash(password: string): Promise<string>;
}

// domain/interfaces/token-generator.interface.ts
export interface ITokenGenerator {
  generate(payload: any): string;
}
```

#### 2. Application Layer

```typescript
// application/use-cases/register-user.usecase.ts
export class RegisterUserUseCase {
  constructor(
    @Inject('IUserRepository')
    private userRepository: IUserRepository,
    
    @Inject('IPasswordHasher')
    private passwordHasher: IPasswordHasher,
    
    @Inject('ITokenGenerator')
    private tokenGenerator: ITokenGenerator,
  ) {}

  async execute(input: RegisterUserInput): Promise<RegisterUserOutput> {
    // 1. Check if user exists
    const existingUser = await this.userRepository.findByEmail(input.email);
    if (existingUser) {
      throw new UserAlreadyExistsError(input.email);
    }

    // 2. Hash password
    const hashedPassword = await this.passwordHasher.hash(input.password);

    // 3. Create user entity
    const user = User.create(input.email, hashedPassword, input.name);

    // 4. Save user
    const savedUser = await this.userRepository.save(user);

    // 5. Generate token
    const token = this.tokenGenerator.generate({
      sub: savedUser.id,
      email: savedUser.email,
    });

    // 6. Return output
    return {
      user: {
        id: savedUser.id,
        email: savedUser.email,
        name: savedUser.name,
      },
      token,
    };
  }
}
```

#### 3. Infrastructure Layer

```typescript
// infrastructure/repositories/mongo-user.repository.ts
@Injectable()
export class MongoUserRepository implements IUserRepository {
  constructor(
    @InjectModel(UserModel.name)
    private userModel: Model<UserDocument>,
  ) {}

  async findByEmail(email: string): Promise<User | null> {
    const doc = await this.userModel.findOne({ email }).exec();
    return doc ? this.toDomain(doc) : null;
  }

  async save(user: User): Promise<User> {
    const doc = new this.userModel({
      _id: user.id,
      email: user.email,
      name: user.name,
      password: (user as any).password,
      createdAt: user.createdAt,
    });
    const saved = await doc.save();
    return this.toDomain(saved);
  }

  private toDomain(doc: UserDocument): User {
    return new User(
      doc._id.toString(),
      doc.email,
      doc.name,
      doc.password,
      doc.createdAt,
    );
  }
}

// infrastructure/services/bcrypt-password-hasher.service.ts
@Injectable()
export class BcryptPasswordHasher implements IPasswordHasher {
  async hash(password: string): Promise<string> {
    return bcrypt.hash(password, 10);
  }
}

// infrastructure/services/jwt-token-generator.service.ts
@Injectable()
export class JwtTokenGenerator implements ITokenGenerator {
  constructor(private jwtService: JwtService) {}

  generate(payload: any): string {
    return this.jwtService.sign(payload);
  }
}
```

#### 4. Presentation Layer

```typescript
// presentation/controllers/auth.controller.ts
@Controller('auth')
export class AuthController {
  constructor(private registerUserUseCase: RegisterUserUseCase) {}

  @Post('register')
  async register(@Body() dto: RegisterDto) {
    const input: RegisterUserInput = {
      email: dto.email,
      password: dto.password,
      name: dto.name,
    };

    const output = await this.registerUserUseCase.execute(input);

    return {
      statusCode: 201,
      data: output,
    };
  }
}
```

#### 5. Module Configuration

```typescript
// users.module.ts
@Module({
  imports: [
    MongooseModule.forFeature([{ name: UserModel.name, schema: UserSchema }]),
    JwtModule.register({ secret: 'secret', signOptions: { expiresIn: '7d' } }),
  ],
  controllers: [AuthController],
  providers: [
    // Use Cases
    RegisterUserUseCase,

    // Infrastructure Implementations
    {
      provide: 'IUserRepository',
      useClass: MongoUserRepository,
    },
    {
      provide: 'IPasswordHasher',
      useClass: BcryptPasswordHasher,
    },
    {
      provide: 'ITokenGenerator',
      useClass: JwtTokenGenerator,
    },
  ],
})
export class UsersModule {}
```

### ประโยชน์ที่ได้

✅ **Testability**
```typescript
// Mock Infrastructure ง่าย
const mockRepository = {
  findByEmail: jest.fn(),
  save: jest.fn(),
};

const mockHasher = {
  hash: jest.fn().mockResolvedValue('hashed_password'),
};

const useCase = new RegisterUserUseCase(mockRepository, mockHasher, mockTokenGen);
```

✅ **Flexibility**
```typescript
// เปลี่ยนจาก MongoDB เป็น PostgreSQL
{
  provide: 'IUserRepository',
  useClass: PostgresUserRepository, // แค่เปลี่ยนตรงนี้
}
```

✅ **Maintainability**
- Business Logic อยู่ใน Use Cases (ชัดเจน)
- Database Logic อยู่ใน Repositories (แยกกัน)
- Validation อยู่ใน DTOs และ Entities

---

## Best Practices

### 1. Interface Naming

```typescript
// ใช้ prefix I สำหรับ Interface
interface IUserRepository { }
interface IPasswordHasher { }
interface IEmailService { }

// Implementation ไม่มี prefix I
class MongoUserRepository implements IUserRepository { }
class BcryptPasswordHasher implements IPasswordHasher { }
class SendGridEmailService implements IEmailService { }
```

### 2. Use Case Naming

```typescript
// Pattern: <Verb><Entity>UseCase
class CreateUserUseCase { }
class GetUserByIdUseCase { }
class UpdateUserProfileUseCase { }
class DeleteUserUseCase { }
class SendPasswordResetEmailUseCase { }
```

### 3. Input/Output DTOs

```typescript
// Use Case มี Input/Output ที่ชัดเจน
interface CreateUserInput {
  email: string;
  password: string;
  name: string;
}

interface CreateUserOutput {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
}

class CreateUserUseCase {
  execute(input: CreateUserInput): Promise<CreateUserOutput> {
    // ...
  }
}
```

### 4. Error Handling

```typescript
// Domain Errors
export class DomainError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'DomainError';
  }
}

export class UserAlreadyExistsError extends DomainError {
  constructor(email: string) {
    super(`User with email ${email} already exists`);
    this.name = 'UserAlreadyExistsError';
  }
}

// Application Errors
export class ApplicationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ApplicationError';
  }
}

// Infrastructure Errors
export class InfrastructureError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'InfrastructureError';
  }
}
```

### 5. Repository Pattern

```typescript
// Base Repository Interface
interface IRepository<T> {
  findById(id: string): Promise<T | null>;
  findAll(): Promise<T[]>;
  save(entity: T): Promise<T>;
  delete(id: string): Promise<void>;
}

// Specific Repository
interface IUserRepository extends IRepository<User> {
  findByEmail(email: string): Promise<User | null>;
  findActiveUsers(): Promise<User[]>;
}
```

### 6. Mapper Pattern

```typescript
// Mapper แปลงระหว่าง Layers
class UserMapper {
  // Domain → Database
  toPersistence(entity: User): UserModel {
    const model = new UserModel();
    model._id = entity.id;
    model.email = entity.email;
    model.name = entity.name;
    return model;
  }

  // Database → Domain
  toDomain(model: UserModel): User {
    return new User(
      model._id.toString(),
      model.email,
      model.name,
      model.password,
      model.createdAt,
    );
  }

  // Domain → DTO
  toDto(entity: User): UserDto {
    return {
      id: entity.id,
      email: entity.email,
      name: entity.name,
    };
  }
}
```

---

## ข้อดีและข้อเสีย

### ข้อดี

✅ **Testability**
- Mock ง่าย
- Unit Test ไม่ต้องพึ่ง Database
- Test Business Logic แยกจาก Infrastructure

✅ **Flexibility**
- เปลี่ยน Database ได้ง่าย
- เปลี่ยน Framework ได้ง่าย
- เพิ่ม Features ไม่กระทบของเดิม

✅ **Maintainability**
- โค้ดอ่านง่าย
- แต่ละส่วนมีหน้าที่ชัดเจน
- หา Bugs ง่าย

✅ **Team Collaboration**
- แบ่งงานได้ชัดเจน (ทำ Frontend/Backend แยกกัน)
- ลด Merge Conflicts
- เข้าใจโค้ดของคนอื่นง่าย

✅ **Business Logic Protection**
- Business Rules อยู่ใน Domain Layer
- ไม่ปนกับ Infrastructure Code
- เปลี่ยนเทคโนโลยีไม่กระทบ Business Logic

### ข้อเสีย

❌ **Complexity**
- โค้ดมีหลาย Layers
- ต้องสร้าง Interfaces, Implementations
- Boilerplate Code เยอะ

❌ **Learning Curve**
- ต้องเข้าใจ Clean Architecture Principles
- ต้องรู้จัก SOLID Principles
- ใช้เวลาในการเรียนรู้

❌ **Initial Development Time**
- ใช้เวลาเซ็ตอัพนานกว่า
- ต้องคิดการออกแบบก่อน
- CRUD ง่ายๆ อาจเกินความจำเป็น

❌ **Overhead สำหรับโปรเจคเล็ก**
- โปรเจคเล็กอาจไม่คุ้ม
- CRUD App อาจไม่จำเป็น
- Maintenance Overhead

### เมื่อไหร่ควรใช้

✅ **ควรใช้เมื่อ:**
- โปรเจคขนาดใหญ่ถึงกลาง
- มี Business Logic ที่ซับซ้อน
- ต้องการ Long-term Maintainability
- ทีมมีหลายคน
- ต้องการเปลี่ยน Database/Framework ในอนาคต
- ต้องการ Test Coverage สูง

❌ **ไม่ควรใช้เมื่อ:**
- โปรเจคเล็กมาก (Prototype, POC)
- CRUD App ธรรมดา
- ทีมเล็ก ไม่มีเวลา
- Deadline เร่งด่วน
- Business Logic เรียบง่าย

---

## สรุป

Clean Architecture เป็นแนวทางที่:

✅ **ช่วยให้โค้ดมีคุณภาพสูง**
- Testable
- Maintainable
- Flexible
- Scalable

✅ **เหมาะสำหรับโปรเจคขนาดใหญ่**
- Business Logic ซับซ้อน
- Long-term Maintenance
- Team Collaboration

⚠️ **ต้องชั่งน้ำหนักกับความซับซ้อน**
- โปรเจคเล็กอาจเกินความจำเป็น
- ต้องใช้เวลาเรียนรู้
- Boilerplate Code เยอะ

**คำแนะนำ:**
- เริ่มจาก Standard NestJS ก่อน
- ค่อยๆ Refactor เป็น Clean Architecture เมื่อโปรเจคโต
- ใช้เฉพาะส่วนที่จำเป็น (ไม่จำเป็นต้องใช้ทั้งหมด)
- Focus on Separation of Concerns และ Dependency Inversion

---

**เอกสารที่เกี่ยวข้อง:**
- [คู่มือ Backend ฉบับสมบูรณ์ (BACKEND_MANUAL_TH.md)](./BACKEND_MANUAL_TH.md)
- [คู่มือ Backend (BACKEND_TH.md)](./BACKEND_TH.md)
- [คู่มือ API (API_GUIDE_TH.md)](./API_GUIDE_TH.md)

**แหล่งข้อมูลเพิ่มเติม:**
- [The Clean Architecture (Blog)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Clean Architecture Book by Robert C. Martin](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)
- [Domain-Driven Hexagon](https://github.com/Sairyss/domain-driven-hexagon)

---

**เวอร์ชัน:** 1.0.0  
**อัพเดทล่าสุด:** 27 ตุลาคม 2025  
**ผู้เขียน:** Loan Advisor Development Team
