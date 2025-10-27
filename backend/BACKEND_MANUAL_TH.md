# คู่มือ Backend Loan Advisor ฉบับสมบูรณ์

> เอกสารคู่มือการพัฒนา Backend ของระบบ Loan Advisor อย่างละเอียด สำหรับนักพัฒนาทุกระดับ

## 📑 สารบัญ

1. [ภาพรวมระบบ](#ภาพรวมระบบ)
2. [สถาปัตยกรรมและโครงสร้าง](#สถาปัตยกรรมและโครงสร้าง)
3. [Clean Architecture Principles](#clean-architecture-principles)
4. [โครงสร้างโค้ดและโมดูล](#โครงสร้างโค้ดและโมดูล)
5. [การติดตั้งและการตั้งค่า](#การติดตั้งและการตั้งค่า)
6. [การพัฒนาและแนวทางปฏิบัติ](#การพัฒนาและแนวทางปฏิบัติ)
7. [ความปลอดภัย](#ความปลอดภัย)
8. [การทดสอบ](#การทดสอบ)
9. [การ Deploy](#การ-deploy)
10. [การแก้ปัญหา](#การแก้ปัญหา)
11. [ภาคผนวก](#ภาคผนวก)

---

## ภาพรวมระบบ

### จุดประสงค์ของระบบ

Backend ของ Loan Advisor เป็นระบบ REST API ที่พัฒนาขึ้นเพื่อรองรับแอปพลิเคชันคำนวณสินเชื่อ มีหน้าที่หลักดังนี้:

- **การจัดการผู้ใช้**: ลงทะเบียน เข้าสู่ระบบ และจัดการข้อมูลผู้ใช้
- **การยืนยันตัวตน**: ระบบ Authentication และ Authorization ด้วย JWT
- **การจัดเก็บข้อมูล**: บันทึกและดึงข้อมูลจากฐานข้อมูล MongoDB
- **API Gateway**: ให้บริการ API สำหรับ Flutter Application

### เทคโนโลยีหลัก

| เทคโนโลยี | เวอร์ชัน | วัตถุประสงค์ |
|-----------|---------|-------------|
| **NestJS** | 11.1.8 | Node.js Framework (Backend Core) |
| **TypeScript** | 5.x | ภาษาโปรแกรม (Type-safe JavaScript) |
| **MongoDB** | 8.x | NoSQL Database |
| **Mongoose** | 8.19.2 | ODM (Object Document Mapper) |
| **JWT** | 9.0.2 | Authentication Token |
| **Passport** | 0.7.0 | Authentication Middleware |
| **Bcrypt** | 6.0.0 | Password Hashing |
| **Class Validator** | 0.14.1 | Input Validation |
| **Class Transformer** | 0.5.1 | Data Transformation |

### คุณสมบัติหลัก

✅ **Authentication System**
- ลงทะเบียนผู้ใช้ใหม่พร้อมการตรวจสอบความถูกต้อง
- เข้าสู่ระบบด้วย Email/Password
- JWT Token Authentication (หมดอายุ 7 วัน)
- Protected Routes ด้วย Guards

✅ **User Management**
- จัดเก็บข้อมูลผู้ใช้ใน MongoDB
- ดึงข้อมูล Profile ของผู้ใช้
- เข้ารหัสรหัสผ่านด้วย bcrypt

✅ **Security**
- Password Hashing (bcrypt, 10 salt rounds)
- JWT Token Protection
- Input Validation และ Sanitization
- NoSQL Injection Protection
- CORS Configuration

✅ **Developer Experience**
- TypeScript Type Safety
- Hot Reload Development
- Comprehensive Error Handling
- Swagger API Documentation (พร้อมขยาย)

---

## สถาปัตยกรรมและโครงสร้าง

### NestJS Architecture

Backend นี้ใช้สถาปัตยกรรมของ NestJS ซึ่งเป็น **Modular Architecture** ที่แบ่งระบบออกเป็นโมดูลต่างๆ:

```
┌─────────────────────────────────────────────────────┐
│                   Application Layer                  │
│                    (Entry Point)                     │
│                      main.ts                         │
└────────────────────┬────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────┐
│                    Root Module                       │
│                   AppModule                          │
│  - ConfigModule (Environment Variables)              │
│  - MongooseModule (Database Connection)              │
│  - Feature Modules (Auth, Users)                     │
└────────────────────┬────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        ↓                         ↓
┌──────────────────┐    ┌──────────────────┐
│   Auth Module    │    │   Users Module   │
├──────────────────┤    ├──────────────────┤
│ • Controller     │    │ • Controller     │
│ • Service        │    │ • Service        │
│ • DTOs           │    │ • Schema         │
│ • Guards         │    │ • DTOs           │
│ • Strategies     │    │                  │
└──────────────────┘    └──────────────────┘
```

### โครงสร้างโปรเจค

```
backend/
├── src/                        # Source Code หลัก
│   ├── main.ts                 # Entry Point
│   ├── app.module.ts           # Root Module
│   ├── app.controller.ts       # App-level Controller (Health Check)
│   │
│   ├── auth/                   # Authentication Module
│   │   ├── auth.module.ts      # Module Configuration
│   │   ├── auth.controller.ts  # HTTP Endpoints (register, login)
│   │   ├── auth.service.ts     # Business Logic
│   │   ├── dto/                # Data Transfer Objects
│   │   │   ├── register.dto.ts
│   │   │   ├── login.dto.ts
│   │   │   └── auth-response.dto.ts
│   │   ├── guards/             # Route Guards
│   │   │   └── jwt-auth.guard.ts
│   │   └── strategies/         # Passport Strategies
│   │       └── jwt.strategy.ts
│   │
│   └── users/                  # Users Module
│       ├── users.module.ts     # Module Configuration
│       ├── users.controller.ts # HTTP Endpoints (profile)
│       ├── users.service.ts    # Business Logic
│       ├── user.schema.ts      # MongoDB Schema
│       └── dto/                # Data Transfer Objects
│           ├── create-user.dto.ts
│           └── user-response.dto.ts
│
├── test/                       # E2E Tests
├── .env                        # Environment Variables (not in git)
├── .env.example                # Environment Template
├── .gitignore                  # Git Ignore Rules
├── docker-compose.yml          # Docker Compose Configuration
├── Dockerfile                  # Docker Image Definition
├── nest-cli.json               # NestJS CLI Configuration
├── package.json                # Dependencies และ Scripts
├── tsconfig.json               # TypeScript Configuration
└── README.md                   # Project Documentation
```

### Component Layers

#### 1. Controllers (ชั้น Presentation)

Controllers รับผิดชอบการรับ HTTP Requests และส่ง Responses:

```typescript
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }
}
```

**หน้าที่:**
- รับ HTTP Request
- Validate Input (ผ่าน DTOs)
- เรียก Service Methods
- ส่ง HTTP Response

#### 2. Services (ชั้น Business Logic)

Services ประมวลผลตรรกะทางธุรกิจ:

```typescript
@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto) {
    // Business logic here
    const user = await this.usersService.create(registerDto);
    const token = this.jwtService.sign({ email: user.email, sub: user._id });
    return { accessToken: token, user };
  }
}
```

**หน้าที่:**
- ประมวลผล Business Logic
- เรียกใช้ Database Operations
- จัดการ Error Handling
- ประมวลผลข้อมูลก่อนส่งกลับ

#### 3. Repositories/Schemas (ชั้น Data Access)

Mongoose Schemas และ Models จัดการการเข้าถึงข้อมูล:

```typescript
@Schema({ timestamps: true })
export class User {
  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ required: true })
  name: string;

  @Prop({ default: true })
  isActive: boolean;
}
```

**หน้าที่:**
- กำหนดโครงสร้างข้อมูล
- จัดการ Database Operations (CRUD)
- Validation ระดับ Schema

#### 4. DTOs (Data Transfer Objects)

DTOs กำหนดรูปแบบข้อมูลและ Validation Rules:

```typescript
export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsString()
  @IsNotEmpty()
  name: string;
}
```

**หน้าที่:**
- Validate Input Data
- Transform Data
- Type Safety
- Documentation

---

## Clean Architecture Principles

### ทำไมต้อง Clean Architecture?

Clean Architecture เป็นแนวทางการออกแบบซอฟต์แวร์ที่เน้น:

1. **Separation of Concerns**: แยกส่วนต่างๆ ให้ชัดเจน
2. **Independence**: ไม่ขึ้นต่อกับ Framework, UI, Database
3. **Testability**: ง่ายต่อการเขียน Unit Tests
4. **Maintainability**: ดูแลรักษาและขยายง่าย

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│              Presentation Layer (Controllers)            │
│        HTTP Request/Response, DTOs, Validation          │
└───────────────────────┬─────────────────────────────────┘
                        │ depends on
                        ↓
┌─────────────────────────────────────────────────────────┐
│           Application Layer (Use Cases/Services)        │
│         Business Logic, Application Rules               │
└───────────────────────┬─────────────────────────────────┘
                        │ depends on
                        ↓
┌─────────────────────────────────────────────────────────┐
│              Domain Layer (Entities)                    │
│        Business Objects, Domain Rules                   │
└───────────────────────┬─────────────────────────────────┘
                        │ implemented by
                        ↓
┌─────────────────────────────────────────────────────────┐
│         Infrastructure Layer (Database, External)        │
│     MongoDB, Mongoose, External APIs, File System       │
└─────────────────────────────────────────────────────────┘
```

### การนำ Clean Architecture มาใช้กับ NestJS

ในโปรเจคนี้เราจะแมป NestJS Components กับ Clean Architecture ดังนี้:

| Clean Architecture Layer | NestJS Component | ตัวอย่าง |
|-------------------------|------------------|----------|
| **Presentation Layer** | Controllers, Guards | `auth.controller.ts`, `jwt-auth.guard.ts` |
| **Application Layer** | Services, Use Cases | `auth.service.ts`, `users.service.ts` |
| **Domain Layer** | Entities, DTOs, Interfaces | `RegisterDto`, `User` (interface) |
| **Infrastructure Layer** | Schemas, Repositories | `user.schema.ts`, Mongoose Models |

### Dependency Rule

**กฎสำคัญ:** Dependencies ต้องชี้เข้าหาชั้นใน (Inward) เท่านั้น

```
Presentation → Application → Domain ← Infrastructure
                                ↑
                                │
                         (implements)
```

- **Controllers** ขึ้นอยู่กับ **Services**
- **Services** ขึ้นอยู่กับ **Interfaces/DTOs**
- **Infrastructure** implement **Interfaces**
- **Domain** ไม่ขึ้นอยู่กับอะไรเลย

### ตัวอย่างการปรับโครงสร้างเป็น Clean Architecture

#### ก่อนปรับ (NestJS Standard)

```typescript
// users.service.ts
@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private userModel: Model<User>) {}
  
  async create(createUserDto: CreateUserDto) {
    const user = new this.userModel(createUserDto);
    return user.save();
  }
}
```

#### หลังปรับ (Clean Architecture)

```typescript
// domain/interfaces/user-repository.interface.ts
export interface IUserRepository {
  create(user: User): Promise<User>;
  findByEmail(email: string): Promise<User | null>;
}

// application/services/users.service.ts
@Injectable()
export class UsersService {
  constructor(
    @Inject('IUserRepository') 
    private userRepository: IUserRepository
  ) {}
  
  async create(createUserDto: CreateUserDto) {
    const user = new User(createUserDto);
    return this.userRepository.create(user);
  }
}

// infrastructure/repositories/user.repository.ts
@Injectable()
export class UserRepository implements IUserRepository {
  constructor(@InjectModel(User.name) private userModel: Model<UserDocument>) {}
  
  async create(user: User): Promise<User> {
    const userDoc = new this.userModel(user);
    return userDoc.save();
  }
}
```

### ประโยชน์ของ Clean Architecture

✅ **Testability**
```typescript
// ง่ายต่อการ Mock Repository
const mockUserRepository = {
  create: jest.fn(),
  findByEmail: jest.fn(),
};

const usersService = new UsersService(mockUserRepository);
```

✅ **Flexibility**
```typescript
// เปลี่ยนจาก MongoDB เป็น PostgreSQL โดยไม่แก้ Service
class PostgresUserRepository implements IUserRepository {
  async create(user: User): Promise<User> {
    // PostgreSQL implementation
  }
}
```

✅ **Maintainability**
- Business Logic แยกจาก Infrastructure
- ง่ายต่อการหา Bugs
- เพิ่มฟีเจอร์ใหม่โดยไม่กระทบของเดิม

---

## โครงสร้างโค้ดและโมดูล

### App Module (Root Module)

**ไฟล์:** `src/app.module.ts`

```typescript
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    MongooseModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        uri: configService.get<string>('MONGODB_URI'),
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    UsersModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
```

**หน้าที่:**
- นำเข้า Global Modules (Config, Database)
- รวม Feature Modules (Auth, Users)
- กำหนด Root-level Controllers

**การทำงาน:**

1. **ConfigModule**: โหลด Environment Variables จาก `.env`
2. **MongooseModule**: เชื่อมต่อ MongoDB แบบ Async (รอ Config พร้อม)
3. **Feature Modules**: Import Auth และ Users Modules

### Auth Module

**ไฟล์:** `src/auth/auth.module.ts`

```typescript
@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET'),
        signOptions: { expiresIn: '7d' },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
```

#### Components

##### 1. Auth Controller

**ไฟล์:** `src/auth/auth.controller.ts`

**Endpoints:**

```typescript
@Controller('auth')
export class AuthController {
  @Post('register')
  async register(@Body() registerDto: RegisterDto) {
    // POST /auth/register
  }

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    // POST /auth/login
  }
}
```

**หน้าที่:**
- จัดการ HTTP Requests สำหรับ Authentication
- Validate Input ผ่าน DTOs
- เรียก AuthService

##### 2. Auth Service

**ไฟล์:** `src/auth/auth.service.ts`

```typescript
@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto) {
    // 1. Check if user exists
    const existingUser = await this.usersService.findByEmail(registerDto.email);
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // 2. Create user
    const user = await this.usersService.create(registerDto);

    // 3. Generate JWT token
    const payload = { email: user.email, sub: user._id };
    const accessToken = this.jwtService.sign(payload);

    // 4. Return response
    return {
      accessToken,
      user: {
        email: user.email,
        name: user.name,
      },
    };
  }

  async login(loginDto: LoginDto) {
    // 1. Find user
    const user = await this.usersService.findByEmail(loginDto.email);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // 2. Validate password
    const isPasswordValid = await this.usersService.validatePassword(
      loginDto.password,
      user.password,
    );
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // 3. Generate JWT token
    const payload = { email: user.email, sub: user._id };
    const accessToken = this.jwtService.sign(payload);

    // 4. Return response
    return {
      accessToken,
      user: {
        email: user.email,
        name: user.name,
      },
    };
  }
}
```

**Business Logic:**
- ตรวจสอบ Email ซ้ำ (Register)
- สร้างผู้ใช้ใหม่
- ตรวจสอบรหัสผ่าน (Login)
- สร้าง JWT Token
- จัดการ Errors

##### 3. JWT Strategy

**ไฟล์:** `src/auth/strategies/jwt.strategy.ts`

```typescript
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private configService: ConfigService,
    private usersService: UsersService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'),
    });
  }

  async validate(payload: any) {
    // Payload: { email, sub (userId), iat, exp }
    const user = await this.usersService.findById(payload.sub);
    if (!user) {
      throw new UnauthorizedException();
    }
    return user; // Attached to request.user
  }
}
```

**การทำงาน:**
1. Extract JWT Token จาก Header (`Bearer <token>`)
2. Verify Token Signature
3. Decode Payload
4. Validate User (ดึงจาก Database)
5. Attach User ให้กับ `request.user`

##### 4. JWT Auth Guard

**ไฟล์:** `src/auth/guards/jwt-auth.guard.ts`

```typescript
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
```

**การใช้งาน:**
```typescript
@Controller('users')
export class UsersController {
  @Get('profile')
  @UseGuards(JwtAuthGuard) // Protected route
  getProfile(@Request() req) {
    return req.user; // User from JWT validation
  }
}
```

##### 5. DTOs

**Register DTO** (`src/auth/dto/register.dto.ts`):
```typescript
export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @MinLength(6)
  @IsNotEmpty()
  password: string;

  @IsString()
  @IsNotEmpty()
  name: string;
}
```

**Login DTO** (`src/auth/dto/login.dto.ts`):
```typescript
export class LoginDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @IsNotEmpty()
  password: string;
}
```

**Auth Response DTO** (`src/auth/dto/auth-response.dto.ts`):
```typescript
export class AuthResponseDto {
  accessToken: string;
  user: {
    email: string;
    name: string;
  };
}
```

### Users Module

**ไฟล์:** `src/users/users.module.ts`

```typescript
@Module({
  imports: [
    MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
  ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
```

#### Components

##### 1. User Schema

**ไฟล์:** `src/users/user.schema.ts`

```typescript
@Schema({ timestamps: true })
export class User {
  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ required: true })
  name: string;

  @Prop({ default: true })
  isActive: boolean;

  @Prop()
  createdAt?: Date;

  @Prop()
  updatedAt?: Date;
}

export const UserSchema = SchemaFactory.createForClass(User);

// Create index for faster queries
UserSchema.index({ email: 1 });
```

**ฟิลด์:**
- `email`: Email (unique, required)
- `password`: Hashed password (required)
- `name`: ชื่อผู้ใช้ (required)
- `isActive`: สถานะใช้งาน (default: true)
- `createdAt`, `updatedAt`: Timestamps (auto-generated)

##### 2. Users Service

**ไฟล์:** `src/users/users.service.ts`

```typescript
@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private userModel: Model<User>) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    // Hash password
    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
    
    // Create user
    const user = new this.userModel({
      ...createUserDto,
      password: hashedPassword,
    });
    
    return user.save();
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email, isActive: true }).exec();
  }

  async findById(id: string): Promise<User | null> {
    return this.userModel.findById(id).exec();
  }

  async validatePassword(
    plainPassword: string,
    hashedPassword: string,
  ): Promise<boolean> {
    return bcrypt.compare(plainPassword, hashedPassword);
  }

  async getUserProfile(userId: string) {
    const user = await this.userModel
      .findById(userId)
      .select('-password') // Exclude password
      .exec();
    
    if (!user) {
      throw new NotFoundException('User not found');
    }
    
    return user;
  }
}
```

**Methods:**
- `create()`: สร้างผู้ใช้ใหม่ (hash password)
- `findByEmail()`: ค้นหาจาก email
- `findById()`: ค้นหาจาก ID
- `validatePassword()`: เปรียบเทียบรหัสผ่าน
- `getUserProfile()`: ดึงข้อมูล Profile (ไม่มี password)

##### 3. Users Controller

**ไฟล์:** `src/users/users.controller.ts`

```typescript
@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  async getProfile(@Request() req) {
    return this.usersService.getUserProfile(req.user._id);
  }
}
```

---

## การติดตั้งและการตั้งค่า

### ข้อกำหนดเบื้องต้น

- **Node.js**: v18.x หรือสูงกว่า
- **npm** หรือ **yarn**: Package Manager
- **MongoDB**: v5.x หรือสูงกว่า
- **Git**: Version Control

### ติดตั้ง Dependencies

```bash
cd backend
npm install
```

### ตั้งค่า Environment Variables

1. **สร้างไฟล์ `.env`:**
```bash
cp .env.example .env
```

2. **แก้ไขค่าใน `.env`:**
```env
# Application
PORT=3000
NODE_ENV=development

# MongoDB
MONGODB_URI=mongodb://localhost:27017/loan-advisor

# JWT
JWT_SECRET=your-strong-secret-key-change-this
JWT_EXPIRES_IN=7d
```

**สร้าง JWT Secret ที่แข็งแรง:**
```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

### รัน MongoDB

#### แบบ Local

**macOS (Homebrew):**
```bash
brew services start mongodb-community
```

**Linux (systemd):**
```bash
sudo systemctl start mongod
sudo systemctl enable mongod
```

**Windows:**
```bash
net start MongoDB
```

#### แบบ Docker

```bash
docker run -d \
  --name mongodb \
  -p 27017:27017 \
  -v mongodb_data:/data/db \
  mongo:7
```

### รัน Development Server

```bash
# Development mode with hot reload
npm run start:dev

# Watch mode
npm run start:dev

# Production build
npm run build
npm run start:prod
```

Server จะรันที่: `http://localhost:3000`

### รันด้วย Docker Compose

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

---

## การพัฒนาและแนวทางปฏิบัติ

### Coding Standards

#### 1. TypeScript Best Practices

**ใช้ Type Annotations:**
```typescript
// ✅ ดี
async findUser(id: string): Promise<User> {
  return this.userModel.findById(id);
}

// ❌ ไม่ดี
async findUser(id) {
  return this.userModel.findById(id);
}
```

**หลีกเลี่ยง `any` Type:**
```typescript
// ✅ ดี
interface UserData {
  email: string;
  name: string;
}

async processUser(data: UserData): Promise<void> {
  // ...
}

// ❌ ไม่ดี
async processUser(data: any): Promise<void> {
  // ...
}
```

#### 2. NestJS Best Practices

**ใช้ Dependency Injection:**
```typescript
// ✅ ดี
@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}
}

// ❌ ไม่ดี
export class AuthService {
  private usersService = new UsersService();
  private jwtService = new JwtService();
}
```

**ใช้ DTOs สำหรับ Validation:**
```typescript
// ✅ ดี
@Post('register')
async register(@Body() registerDto: RegisterDto) {
  return this.authService.register(registerDto);
}

// ❌ ไม่ดี
@Post('register')
async register(@Body() body: any) {
  return this.authService.register(body);
}
```

#### 3. Error Handling

**ใช้ Built-in Exceptions:**
```typescript
// ✅ ดี
if (!user) {
  throw new NotFoundException('User not found');
}

if (existingUser) {
  throw new ConflictException('User already exists');
}

// ❌ ไม่ดี
if (!user) {
  throw new Error('User not found');
}
```

**Custom Exception Filters:**
```typescript
@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const status = exception.getStatus();
    
    response.status(status).json({
      statusCode: status,
      message: exception.message,
      timestamp: new Date().toISOString(),
    });
  }
}
```

### Project Structure Guidelines

#### การเพิ่ม Module ใหม่

1. **สร้างโฟลเดอร์:**
```bash
mkdir -p src/loans
mkdir -p src/loans/dto
```

2. **สร้างไฟล์:**
```bash
# Module
touch src/loans/loans.module.ts

# Controller
touch src/loans/loans.controller.ts

# Service
touch src/loans/loans.service.ts

# Schema
touch src/loans/loan.schema.ts

# DTOs
touch src/loans/dto/create-loan.dto.ts
touch src/loans/dto/update-loan.dto.ts
```

3. **Import ใน AppModule:**
```typescript
@Module({
  imports: [
    // ...existing imports
    LoansModule,
  ],
})
export class AppModule {}
```

#### Naming Conventions

- **Files**: `kebab-case.ts` (e.g., `user.schema.ts`, `auth.service.ts`)
- **Classes**: `PascalCase` (e.g., `UsersService`, `AuthController`)
- **Interfaces**: `IPascalCase` (e.g., `IUserRepository`)
- **Variables**: `camelCase` (e.g., `userData`, `accessToken`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `JWT_SECRET`, `MAX_ATTEMPTS`)

### Git Workflow

#### Commit Messages

ใช้ Conventional Commits:

```bash
feat: add user profile update endpoint
fix: correct password validation logic
docs: update API documentation
refactor: simplify auth service
test: add unit tests for users service
chore: update dependencies
```

#### Branch Strategy

```bash
main                 # Production-ready code
  ├── develop       # Development branch
  │   ├── feature/user-profile
  │   ├── feature/loan-calculator
  │   └── bugfix/jwt-expiration
  └── hotfix/security-patch
```

**การทำงานกับ Branches:**
```bash
# สร้าง feature branch
git checkout -b feature/user-profile

# Commit changes
git add .
git commit -m "feat: add user profile endpoint"

# Push to remote
git push origin feature/user-profile

# Merge back to develop
git checkout develop
git merge feature/user-profile
```

---

## ความปลอดภัย

### Authentication & Authorization

#### JWT Token Security

**การสร้าง Token:**
```typescript
const payload = { 
  email: user.email, 
  sub: user._id,
  // ไม่ใส่ข้อมูลอ่อนไหวใน payload
};
const token = this.jwtService.sign(payload);
```

**Token Expiration:**
- Development: 7 วัน
- Production: แนะนำ 1-24 ชั่วโมง
- Refresh Token: ใช้สำหรับ Long-lived Sessions

**การ Validate Token:**
```typescript
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  async validate(payload: any) {
    const user = await this.usersService.findById(payload.sub);
    if (!user || !user.isActive) {
      throw new UnauthorizedException();
    }
    return user;
  }
}
```

### Password Security

#### bcrypt Hashing

```typescript
// Hashing
const salt = 10; // Cost factor
const hashedPassword = await bcrypt.hash(plainPassword, salt);

// Verification
const isValid = await bcrypt.compare(plainPassword, hashedPassword);
```

**Best Practices:**
- ใช้ salt rounds อย่างน้อย 10
- ไม่เก็บ plain text passwords
- Hash ก่อนบันทึกลง Database เสมอ

### Input Validation

#### Class Validator

```typescript
export class RegisterDto {
  @IsEmail({}, { message: 'Invalid email format' })
  @IsNotEmpty({ message: 'Email is required' })
  email: string;

  @IsString()
  @MinLength(6, { message: 'Password must be at least 6 characters' })
  @Matches(/^(?=.*[A-Za-z])(?=.*\d)/, {
    message: 'Password must contain letters and numbers',
  })
  password: string;

  @IsString()
  @MinLength(2, { message: 'Name must be at least 2 characters' })
  @MaxLength(100, { message: 'Name must not exceed 100 characters' })
  name: string;
}
```

#### Validation Pipe

```typescript
// main.ts
app.useGlobalPipes(
  new ValidationPipe({
    whitelist: true, // Strip unknown properties
    forbidNonWhitelisted: true, // Throw error on unknown properties
    transform: true, // Transform to DTO instance
  }),
);
```

### NoSQL Injection Protection

#### Mongoose Sanitization

```typescript
// ❌ Vulnerable
const user = await this.userModel.findOne({ 
  email: req.body.email // Direct input
});

// ✅ Safe (with DTO validation)
@IsEmail()
email: string;

const user = await this.userModel.findOne({ 
  email: loginDto.email // Validated by DTO
});
```

#### Query Operators

```typescript
// ❌ Dangerous
const filter = JSON.parse(req.query.filter);
const users = await this.userModel.find(filter);

// ✅ Safe
const users = await this.userModel.find({ 
  email: validatedEmail,
  isActive: true 
});
```

### CORS Configuration

```typescript
// main.ts
app.enableCors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
  credentials: true,
  allowedHeaders: 'Content-Type, Authorization',
});
```

**Production Config:**
```env
ALLOWED_ORIGINS=https://yourapp.com,https://www.yourapp.com
```

### Rate Limiting

```bash
npm install @nestjs/throttler
```

```typescript
// app.module.ts
@Module({
  imports: [
    ThrottlerModule.forRoot([{
      ttl: 60000, // 1 minute
      limit: 10, // 10 requests per minute
    }]),
  ],
})

// Controller
@Controller('auth')
@UseGuards(ThrottlerGuard)
export class AuthController {
  // Protected from brute force
}
```

### Environment Variables

**ไม่ commit `.env` file:**
```gitignore
.env
.env.local
.env.*.local
```

**ใช้ Validation:**
```typescript
// config/env.validation.ts
import { plainToClass } from 'class-transformer';
import { IsString, IsNumber, validateSync } from 'class-validator';

class EnvironmentVariables {
  @IsString()
  JWT_SECRET: string;

  @IsNumber()
  PORT: number;

  @IsString()
  MONGODB_URI: string;
}

export function validate(config: Record<string, unknown>) {
  const validatedConfig = plainToClass(EnvironmentVariables, config, {
    enableImplicitConversion: true,
  });
  
  const errors = validateSync(validatedConfig, {
    skipMissingProperties: false,
  });

  if (errors.length > 0) {
    throw new Error(errors.toString());
  }
  return validatedConfig;
}
```

### Security Headers

```bash
npm install helmet
```

```typescript
// main.ts
import helmet from 'helmet';

app.use(helmet());
```

---

## การทดสอบ

### Unit Testing

#### Testing Services

```typescript
// users.service.spec.ts
describe('UsersService', () => {
  let service: UsersService;
  let model: Model<User>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getModelToken(User.name),
          useValue: {
            findOne: jest.fn(),
            findById: jest.fn(),
            save: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    model = module.get<Model<User>>(getModelToken(User.name));
  });

  describe('findByEmail', () => {
    it('should return a user if found', async () => {
      const mockUser = { email: 'test@example.com', name: 'Test' };
      jest.spyOn(model, 'findOne').mockReturnValue({
        exec: jest.fn().mockResolvedValue(mockUser),
      } as any);

      const result = await service.findByEmail('test@example.com');
      expect(result).toEqual(mockUser);
    });

    it('should return null if user not found', async () => {
      jest.spyOn(model, 'findOne').mockReturnValue({
        exec: jest.fn().mockResolvedValue(null),
      } as any);

      const result = await service.findByEmail('nonexistent@example.com');
      expect(result).toBeNull();
    });
  });
});
```

#### Testing Controllers

```typescript
// auth.controller.spec.ts
describe('AuthController', () => {
  let controller: AuthController;
  let service: AuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: {
            register: jest.fn(),
            login: jest.fn(),
          },
        },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    service = module.get<AuthService>(AuthService);
  });

  describe('register', () => {
    it('should register a new user', async () => {
      const registerDto = {
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      };
      
      const expectedResult = {
        accessToken: 'jwt-token',
        user: { email: registerDto.email, name: registerDto.name },
      };

      jest.spyOn(service, 'register').mockResolvedValue(expectedResult);

      const result = await controller.register(registerDto);
      expect(result).toEqual(expectedResult);
      expect(service.register).toHaveBeenCalledWith(registerDto);
    });
  });
});
```

### E2E Testing

```typescript
// auth.e2e-spec.ts
describe('Auth (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/auth/register (POST)', () => {
    it('should register a new user', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('accessToken');
          expect(res.body).toHaveProperty('user');
        });
    });

    it('should fail with invalid email', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: 'invalid-email',
          password: 'password123',
          name: 'Test User',
        })
        .expect(400);
    });
  });
});
```

### รัน Tests

```bash
# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Test coverage
npm run test:cov

# Watch mode
npm run test:watch
```

---

## การ Deploy

### Deployment Checklist

- [ ] ตั้งค่า Environment Variables สำหรับ Production
- [ ] เปลี่ยน JWT_SECRET เป็นค่าที่แข็งแรง
- [ ] ตั้งค่า CORS ให้เฉพาะเจาะจง
- [ ] Enable HTTPS
- [ ] ตั้งค่า MongoDB Authentication
- [ ] เปิดใช้งาน Rate Limiting
- [ ] ตั้งค่า Logging และ Monitoring
- [ ] Backup Strategy
- [ ] Health Check Endpoint

### Docker Deployment

**Dockerfile:**
```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/main"]
```

**Build และ Run:**
```bash
# Build image
docker build -t loan-advisor-backend .

# Run container
docker run -d \
  -p 3000:3000 \
  --env-file .env \
  --name loan-advisor-api \
  loan-advisor-backend
```

### ทำด้วย Docker Compose

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  mongodb:
    image: mongo:7
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD}
    volumes:
      - mongodb_data:/data/db
    networks:
      - backend

  backend:
    build: .
    restart: always
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      MONGODB_URI: mongodb://admin:${MONGO_ROOT_PASSWORD}@mongodb:27017/loan-advisor?authSource=admin
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      - mongodb
    networks:
      - backend

volumes:
  mongodb_data:

networks:
  backend:
```

**Deploy:**
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Cloud Deployment

#### Heroku

```bash
# Install Heroku CLI
npm install -g heroku

# Login
heroku login

# Create app
heroku create loan-advisor-api

# Set environment variables
heroku config:set JWT_SECRET=your-secret
heroku config:set MONGODB_URI=your-mongodb-uri

# Deploy
git push heroku main

# View logs
heroku logs --tail
```

#### AWS EC2

```bash
# 1. SSH to EC2
ssh -i your-key.pem ubuntu@your-ec2-ip

# 2. Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 3. Install PM2
sudo npm install -g pm2

# 4. Clone repository
git clone https://github.com/yourrepo/loan-advisor.git
cd loan-advisor/backend

# 5. Install dependencies
npm install

# 6. Build
npm run build

# 7. Start with PM2
pm2 start dist/main.js --name loan-advisor-api

# 8. Auto-start on reboot
pm2 startup
pm2 save
```

#### MongoDB Atlas

```bash
# 1. สมัครที่ https://www.mongodb.com/cloud/atlas
# 2. สร้าง Cluster
# 3. เพิ่ม IP Address ที่อนุญาต
# 4. สร้าง Database User
# 5. Get Connection String

# Connection String format:
mongodb+srv://username:password@cluster.mongodb.net/loan-advisor?retryWrites=true&w=majority
```

---

## การแก้ปัญหา

### ปัญหาที่พบบ่อย

#### 1. MongoDB Connection Failed

**อาการ:**
```
MongooseServerSelectionError: connect ECONNREFUSED 127.0.0.1:27017
```

**สาเหตุ:**
- MongoDB ไม่ได้รัน
- Connection string ผิด
- Network/Firewall block

**วิธีแก้:**
```bash
# Check MongoDB status
# macOS
brew services list | grep mongodb

# Linux
sudo systemctl status mongod

# Start MongoDB
brew services start mongodb-community  # macOS
sudo systemctl start mongod            # Linux

# Test connection
mongosh
```

#### 2. JWT Token Invalid/Expired

**อาการ:**
```
UnauthorizedException: Unauthorized
```

**สาเหตุ:**
- Token หมดอายุ
- JWT_SECRET ไม่ตรงกัน
- Token format ผิด

**วิธีแก้:**
```typescript
// ตรวจสอบ token format
// Header: Authorization: Bearer <token>

// Login ใหม่เพื่อรับ token ใหม่
// ตรวจสอบ JWT_SECRET ใน .env
```

#### 3. Port Already in Use

**อาการ:**
```
Error: listen EADDRINUSE: address already in use :::3000
```

**วิธีแก้:**
```bash
# Find process using port 3000
# macOS/Linux
lsof -i :3000
kill -9 <PID>

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Or change PORT in .env
PORT=3001
```

#### 4. Validation Errors

**อาการ:**
```json
{
  "statusCode": 400,
  "message": ["email must be an email"],
  "error": "Bad Request"
}
```

**สาเหตุ:**
- Input data ไม่ตรงตาม DTO validation rules

**วิธีแก้:**
```typescript
// ตรวจสอบ request body
// ดูที่ DTO validators

// ตัวอย่าง RegisterDto
@IsEmail()
email: string;  // ต้องเป็น email format

@MinLength(6)
password: string;  // ต้องยาวอย่างน้อย 6 ตัวอักษร
```

#### 5. Dependencies Installation Failed

**อาการ:**
```
npm ERR! code ERESOLVE
npm ERR! ERESOLVE unable to resolve dependency tree
```

**วิธีแก้:**
```bash
# ลบ node_modules และ package-lock.json
rm -rf node_modules package-lock.json

# Install ใหม่
npm install

# หรือใช้ --legacy-peer-deps
npm install --legacy-peer-deps
```

### Debugging Tips

#### Enable Debug Logs

```bash
# Development
DEBUG=* npm run start:dev

# NestJS specific
DEBUG=nestjs:* npm run start:dev
```

#### MongoDB Query Logging

```typescript
// app.module.ts
MongooseModule.forRootAsync({
  useFactory: async (configService: ConfigService) => ({
    uri: configService.get<string>('MONGODB_URI'),
    // Enable query logging
    debug: process.env.NODE_ENV === 'development',
  }),
}),
```

#### HTTP Request Logging

```bash
npm install morgan
```

```typescript
// main.ts
import * as morgan from 'morgan';

app.use(morgan('dev'));
```

### Performance Issues

#### ตรวจสอบ Slow Queries

```javascript
// MongoDB Shell
db.setProfilingLevel(1, { slowms: 100 });
db.system.profile.find().sort({ ts: -1 }).limit(5);
```

#### เพิ่ม Indexes

```typescript
// user.schema.ts
UserSchema.index({ email: 1 });
UserSchema.index({ createdAt: -1 });
UserSchema.index({ email: 1, isActive: 1 }); // Compound index
```

#### Connection Pooling

```typescript
MongooseModule.forRootAsync({
  useFactory: async (configService: ConfigService) => ({
    uri: configService.get<string>('MONGODB_URI'),
    maxPoolSize: 10,
    minPoolSize: 2,
    serverSelectionTimeoutMS: 5000,
  }),
}),
```

---

## ภาคผนวก

### A. คำสั่งที่ใช้บ่อย

#### NPM Scripts

```bash
# Development
npm run start:dev        # รัน development mode (hot reload)
npm run start:debug      # รันพร้อม debugger

# Production
npm run build            # Build production
npm run start:prod       # รัน production

# Testing
npm run test             # รัน unit tests
npm run test:e2e         # รัน E2E tests
npm run test:cov         # Test coverage

# Code Quality
npm run format           # Format code
npm run lint             # Lint code
npm run lint:fix         # Fix linting errors
```

#### Docker Commands

```bash
# Build
docker build -t loan-advisor-backend .

# Run
docker run -d -p 3000:3000 --name api loan-advisor-backend

# Logs
docker logs -f api

# Stop
docker stop api

# Remove
docker rm api
docker rmi loan-advisor-backend
```

#### MongoDB Commands

```bash
# Connect
mongosh "mongodb://localhost:27017/loan-advisor"

# Show databases
show dbs

# Use database
use loan-advisor

# Show collections
show collections

# Query
db.users.find()
db.users.countDocuments()

# Create index
db.users.createIndex({ email: 1 }, { unique: true })

# Drop collection
db.users.drop()
```

### B. API Endpoints Reference

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/health` | ❌ | Health check |
| POST | `/auth/register` | ❌ | ลงทะเบียนผู้ใช้ใหม่ |
| POST | `/auth/login` | ❌ | เข้าสู่ระบบ |
| GET | `/users/profile` | ✅ | ดึงข้อมูล Profile |

### C. Environment Variables

```env
# Application
PORT=3000
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/loan-advisor

# Authentication
JWT_SECRET=your-jwt-secret-key
JWT_EXPIRES_IN=7d

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

# Logging
LOG_LEVEL=debug
```

### D. เอกสารอ้างอิง

**เอกสารภาษาไทย:**
- [คู่มือ Backend (BACKEND_TH.md)](./BACKEND_TH.md)
- [คู่มือ API (API_GUIDE_TH.md)](./API_GUIDE_TH.md)
- [Database Schema (DATABASE_SCHEMA_TH.md)](./DATABASE_SCHEMA_TH.md)

**เอกสารภาษาอังกฤษ:**
- [README.md](./README.md)
- [API Testing Guide (API_TESTING.md)](./API_TESTING.md)
- [Implementation Summary (IMPLEMENTATION_SUMMARY.md)](./IMPLEMENTATION_SUMMARY.md)

**Official Documentation:**
- [NestJS Documentation](https://docs.nestjs.com/)
- [MongoDB Manual](https://docs.mongodb.com/manual/)
- [Mongoose Documentation](https://mongoosejs.com/docs/)
- [JWT.io](https://jwt.io/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)

### E. Clean Architecture Resources

**หนังสือและบทความแนะนำ:**
- "Clean Architecture" by Robert C. Martin
- "Implementing Domain-Driven Design" by Vaughn Vernon
- [The Clean Architecture (Blog Post)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

**Clean Architecture ใน NestJS:**
- [NestJS Clean Architecture Example](https://github.com/topics/nestjs-clean-architecture)
- [Domain-Driven Hexagon](https://github.com/Sairyss/domain-driven-hexagon)

---

## สรุป

คู่มือฉบับนี้ครอบคลุม:

✅ **สถาปัตยกรรม**: NestJS Modular Architecture และ Clean Architecture Principles  
✅ **โครงสร้างโค้ด**: โมดูล, Controllers, Services, DTOs, Schemas  
✅ **การพัฒนา**: Best Practices, Coding Standards, Git Workflow  
✅ **ความปลอดภัย**: Authentication, Password Hashing, Input Validation  
✅ **การทดสอบ**: Unit Tests, E2E Tests  
✅ **การ Deploy**: Docker, Cloud Platforms  
✅ **การแก้ปัญหา**: Common Issues และ Solutions  

Backend ของ Loan Advisor พร้อมใช้งานและสามารถขยายต่อยอดได้อย่างยืดหยุ่น โดยยึดหลัก Clean Architecture เพื่อให้โค้ดมีคุณภาพ บำรุงรักษาง่าย และทดสอบได้ครบถ้วน

สำหรับคำถามและข้อสงสัย โปรดดูเอกสารเพิ่มเติมในภาคผนวก D หรือติดต่อทีมพัฒนา

---

**เวอร์ชัน:** 1.0.0  
**อัพเดทล่าสุด:** 27 ตุลาคม 2025  
**ผู้เขียน:** Loan Advisor Development Team
