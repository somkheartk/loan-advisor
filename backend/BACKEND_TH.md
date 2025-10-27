# เอกสารคู่มือ Backend Loan Advisor

## ภาพรวม

Backend ของแอปพลิเคชัน Loan Advisor เป็นระบบ API ที่พัฒนาด้วย NestJS และใช้ MongoDB เป็นฐานข้อมูล มีหน้าที่จัดการข้อมูลผู้ใช้ การยืนยันตัวตน และการจัดการเซสชันผ่าน JWT Token

## สถาปัตยกรรม (Architecture)

### เทคโนโลยีหลัก

- **NestJS** (v11.1.8) - Framework สำหรับ Node.js ที่ใช้ TypeScript
- **MongoDB** (v8.19.2) - ฐานข้อมูล NoSQL
- **Mongoose** (v8.19.2) - ODM (Object Document Mapper) สำหรับ MongoDB
- **JWT** (JSON Web Tokens) - สำหรับการยืนยันตัวตนและการจัดการเซสชัน
- **Bcrypt** (v6.0.0) - สำหรับการเข้ารหัสรหัสผ่าน
- **Passport** - Middleware สำหรับการยืนยันตัวตน
- **Class Validator** - สำหรับการตรวจสอบข้อมูลที่เข้ามา

### โครงสร้างโปรเจค

```
backend/
├── src/
│   ├── auth/                      # โมดูลการยืนยันตัวตน
│   │   ├── dto/                   # Data Transfer Objects
│   │   │   ├── login.dto.ts       # DTO สำหรับ Login
│   │   │   ├── register.dto.ts    # DTO สำหรับ Register
│   │   │   └── auth-response.dto.ts # DTO สำหรับ Response
│   │   ├── guards/                # Guards สำหรับป้องกัน Routes
│   │   │   └── jwt-auth.guard.ts  # JWT Authentication Guard
│   │   ├── strategies/            # Passport Strategies
│   │   │   └── jwt.strategy.ts    # JWT Strategy
│   │   ├── auth.controller.ts     # Controller สำหรับ Authentication
│   │   ├── auth.service.ts        # Service สำหรับ Authentication Logic
│   │   └── auth.module.ts         # Module Configuration
│   ├── users/                     # โมดูลผู้ใช้
│   │   ├── dto/                   # Data Transfer Objects
│   │   │   ├── create-user.dto.ts # DTO สำหรับสร้างผู้ใช้
│   │   │   └── user-response.dto.ts # DTO สำหรับ Response
│   │   ├── user.schema.ts         # MongoDB Schema สำหรับ User
│   │   ├── users.controller.ts    # Controller สำหรับ Users
│   │   ├── users.service.ts       # Service สำหรับ Users Logic
│   │   └── users.module.ts        # Module Configuration
│   ├── app.module.ts              # Root Module หลัก
│   ├── app.controller.ts          # App Controller (Health Check)
│   └── main.ts                    # Entry Point ของแอปพลิเคชัน
├── .env                           # ตัวแปร Environment (ไม่อยู่ใน Git)
├── .env.example                   # ตัวอย่างไฟล์ Environment
├── docker-compose.yml             # Docker Compose Configuration
├── Dockerfile                     # Docker Configuration
├── nest-cli.json                  # Nest CLI Configuration
├── package.json                   # Dependencies และ Scripts
└── tsconfig.json                  # TypeScript Configuration
```

## โมดูลหลัก (Main Modules)

### 1. App Module (`app.module.ts`)

เป็น Root Module หลักที่รวมโมดูลต่างๆ เข้าด้วยกัน

**หน้าที่:**
- กำหนดค่า Configuration Module (จัดการตัวแปร Environment)
- เชื่อมต่อกับ MongoDB ผ่าน Mongoose
- นำเข้า Auth Module และ Users Module

**การเชื่อมต่อ MongoDB:**
```typescript
MongooseModule.forRootAsync({
  imports: [ConfigModule],
  useFactory: async (configService: ConfigService) => ({
    uri: configService.get<string>('MONGODB_URI') || 'mongodb://localhost:27017/loan-advisor',
  }),
  inject: [ConfigService],
})
```

### 2. Auth Module (โมดูลการยืนยันตัวตน)

#### ไฟล์หลัก

**`auth.service.ts`** - Logic การยืนยันตัวตน
- `register()` - ลงทะเบียนผู้ใช้ใหม่
- `login()` - เข้าสู่ระบบ
- `validateUser()` - ตรวจสอบความถูกต้องของผู้ใช้

**`auth.controller.ts`** - Endpoints สำหรับ Authentication
- `POST /auth/register` - ลงทะเบียน
- `POST /auth/login` - เข้าสู่ระบบ

**`jwt.strategy.ts`** - JWT Strategy สำหรับ Passport
- ตรวจสอบ JWT Token ที่ส่งมาใน Header
- Extract ข้อมูล User จาก Token Payload

**`jwt-auth.guard.ts`** - Guard สำหรับป้องกัน Protected Routes
- ใช้กับ Routes ที่ต้องการการยืนยันตัวตน

#### กระบวนการลงทะเบียน (Registration Flow)

1. รับข้อมูล: email, password, name จาก Client
2. ตรวจสอบความถูกต้องของข้อมูลด้วย Class Validator
3. เช็คว่า email ซ้ำหรือไม่
4. เข้ารหัสรหัสผ่านด้วย bcrypt (10 salt rounds)
5. บันทึกข้อมูลผู้ใช้ลง MongoDB
6. สร้าง JWT Token
7. ส่ง Token และข้อมูลผู้ใช้กลับไป

#### กระบวนการเข้าสู่ระบบ (Login Flow)

1. รับข้อมูล: email, password จาก Client
2. ตรวจสอบความถูกต้องของข้อมูล
3. ค้นหาผู้ใช้จาก email
4. เปรียบเทียบรหัสผ่านที่เข้ารหัสด้วย bcrypt
5. สร้าง JWT Token
6. ส่ง Token และข้อมูลผู้ใช้กลับไป

#### JWT Token Configuration

```typescript
JwtModule.registerAsync({
  imports: [ConfigModule],
  useFactory: async (configService: ConfigService) => ({
    secret: configService.get<string>('JWT_SECRET'),
    signOptions: { 
      expiresIn: '7d',  // Token หมดอายุใน 7 วัน
    },
  }),
  inject: [ConfigService],
})
```

**JWT Payload Structure:**
```typescript
{
  email: string,    // Email ของผู้ใช้
  sub: string,      // User ID
  iat: number,      // Issued At (เวลาที่สร้าง Token)
  exp: number       // Expiration Time (เวลาหมดอายุ)
}
```

### 3. Users Module (โมดูลผู้ใช้)

#### ไฟล์หลัก

**`user.schema.ts`** - MongoDB Schema สำหรับ User
- กำหนดโครงสร้างข้อมูลผู้ใช้
- สร้าง Index สำหรับการค้นหาที่เร็วขึ้น

**`users.service.ts`** - Logic การจัดการผู้ใช้
- `create()` - สร้างผู้ใช้ใหม่
- `findByEmail()` - ค้นหาผู้ใช้จาก email
- `findById()` - ค้นหาผู้ใช้จาก ID
- `validatePassword()` - ตรวจสอบรหัสผ่าน
- `getUserProfile()` - ดึงข้อมูล Profile ผู้ใช้

**`users.controller.ts`** - Endpoints สำหรับ Users
- `GET /users/profile` - ดึงข้อมูล Profile (ต้อง Login)

#### User Schema

```typescript
@Schema({ timestamps: true })
export class User {
  email: string;        // Email (unique, required)
  password: string;     // รหัสผ่านที่เข้ารหัสแล้ว (required)
  name: string;         // ชื่อ (required)
  isActive: boolean;    // สถานะการใช้งาน (default: true)
  createdAt: Date;      // วันที่สร้าง (auto-generated)
  updatedAt: Date;      // วันที่อัพเดทล่าสุด (auto-generated)
}
```

## Data Transfer Objects (DTOs)

DTOs ใช้สำหรับกำหนดรูปแบบข้อมูลที่รับเข้ามาและส่งออกไป พร้อมทั้งตรวจสอบความถูกต้อง

### Register DTO
```typescript
{
  email: string;      // Email (ต้องเป็นรูปแบบ Email ที่ถูกต้อง)
  password: string;   // รหัสผ่าน (ต้องมีอย่างน้อย 6 ตัวอักษร)
  name: string;       // ชื่อ (required)
}
```

### Login DTO
```typescript
{
  email: string;      // Email (ต้องเป็นรูปแบบ Email ที่ถูกต้อง)
  password: string;   // รหัสผ่าน (required)
}
```

### Auth Response DTO
```typescript
{
  accessToken: string;
  user: {
    email: string;
    name: string;
  }
}
```

### User Response DTO
```typescript
{
  email: string;
  name: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}
```

## ความปลอดภัย (Security)

### 1. การเข้ารหัสรหัสผ่าน
- ใช้ **bcrypt** สำหรับการเข้ารหัสรหัสผ่าน
- ใช้ **10 salt rounds** สำหรับความปลอดภัยสูง
- ไม่เก็บรหัสผ่านแบบ plain text ในฐานข้อมูล

### 2. JWT Token
- Token หมดอายุใน 7 วัน (configurable)
- ใช้ Secret Key จาก Environment Variable
- Token ต้องส่งมาใน Authorization Header: `Bearer <token>`

### 3. Input Validation
- ตรวจสอบข้อมูลทุก Request ด้วย **class-validator**
- กรองข้อมูลที่ไม่จำเป็นออกด้วย `whitelist: true`
- ป้องกันการส่งข้อมูลที่ไม่อยู่ใน DTO ด้วย `forbidNonWhitelisted: true`

### 4. NoSQL Injection Protection
- Mongoose จัดการ sanitization อัตโนมัติเมื่อใช้ object notation
- ตรวจสอบข้อมูลด้วย Class Validator ก่อนใช้ใน Query
- TypeScript ช่วยตรวจสอบ Type Safety

### 5. CORS Configuration
```typescript
app.enableCors({
  origin: '*',      // ปรับให้เฉพาะเจาะจงในระบบจริง
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
  credentials: true,
});
```

### 6. Protected Routes
- ใช้ `@UseGuards(JwtAuthGuard)` สำหรับ Routes ที่ต้องการการยืนยันตัวตน
- ตรวจสอบ Token อัตโนมัติก่อนเข้าถึง Endpoint

### คำแนะนำสำหรับการใช้งานจริง (Production)

1. **JWT Secret**: สร้าง Secret Key ที่แข็งแรง
   ```bash
   node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
   ```

2. **MongoDB Security**:
   - เปิดใช้งาน Authentication บน MongoDB
   - ใช้รหัสผ่านที่แข็งแรง
   - จำกัดการเข้าถึงด้วย Firewall

3. **Environment Variables**:
   - ไม่ commit ไฟล์ `.env` ลง Git
   - ใช้ Secrets Management (AWS Secrets Manager, Azure Key Vault)

4. **HTTPS**:
   - ใช้ HTTPS เสมอในระบบจริง
   - ใช้ Reverse Proxy (nginx, Apache) พร้อม SSL Certificate

5. **Rate Limiting**:
   - เพิ่ม Rate Limiting เพื่อป้องกัน Brute Force Attack
   - ใช้ `@nestjs/throttler`

## ตัวแปร Environment

สร้างไฟล์ `.env` จาก `.env.example`:

```bash
# Application
PORT=3000
NODE_ENV=development

# MongoDB
MONGODB_URI=mongodb://localhost:27017/loan-advisor

# JWT
JWT_SECRET=loan-advisor-secret-key-change-in-production
JWT_EXPIRES_IN=7d
```

**คำอธิบาย:**
- `PORT` - พอร์ตที่ Server จะรัน (default: 3000)
- `NODE_ENV` - Environment (development, production)
- `MONGODB_URI` - URL เชื่อมต่อ MongoDB
- `JWT_SECRET` - Secret Key สำหรับ JWT (ต้องเปลี่ยนในระบบจริง)
- `JWT_EXPIRES_IN` - ระยะเวลาหมดอายุของ Token

## การติดตั้งและรัน

### ข้อกำหนดเบื้องต้น

- Node.js v18 หรือสูงกว่า
- MongoDB (รันอยู่ที่ localhost หรือมี connection string)
- npm หรือ yarn

### ขั้นตอนการติดตั้ง

1. **ติดตั้ง Dependencies:**
   ```bash
   cd backend
   npm install
   ```

2. **สร้างไฟล์ Environment:**
   ```bash
   cp .env.example .env
   ```
   แก้ไขค่าต่างๆ ในไฟล์ `.env` ตามต้องการ

3. **เริ่มต้น MongoDB:**
   ```bash
   # macOS (ใช้ Homebrew)
   brew services start mongodb-community

   # Linux
   sudo systemctl start mongod

   # Windows
   net start MongoDB

   # หรือใช้ Docker
   docker run -d -p 27017:27017 --name mongodb mongo:7
   ```

### วิธีรัน

#### แบบ Development (มี Hot Reload)
```bash
npm run start:dev
```

#### แบบ Production
```bash
npm run build
npm run start:prod
```

#### ใช้ Docker Compose
```bash
# เริ่มทั้ง MongoDB และ Backend
docker-compose up -d

# ดู Logs
docker-compose logs -f

# หยุด Services
docker-compose down

# หยุดและลบข้อมูล
docker-compose down -v
```

Server จะรันที่: `http://localhost:3000`

## คำสั่งที่ใช้บ่อย

```bash
# ติดตั้ง Dependencies
npm install

# รัน Development Mode
npm run start:dev

# Build สำหรับ Production
npm run build

# รัน Production Mode
npm run start:prod

# Format Code
npm run format

# Lint Code
npm run lint
```

## การทดสอบ API

### Health Check
```bash
curl http://localhost:3000/health
```

### ลงทะเบียนผู้ใช้ใหม่
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "ทดสอบ ผู้ใช้"
  }'
```

### เข้าสู่ระบบ
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### ดึงข้อมูล Profile (ต้องใส่ Token)
```bash
curl -X GET http://localhost:3000/users/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

## การใช้งานกับ Flutter App

1. เรียก API จาก Flutter แทนการใช้ SharedPreferences
2. เก็บ JWT Token ใน Flutter Secure Storage
3. ส่ง Token ใน Authorization Header สำหรับ Protected Endpoints
4. Handle Token Expiration และ Refresh Logic

ตัวอย่างการเรียก API จาก Flutter:

```dart
// Login
final response = await http.post(
  Uri.parse('http://localhost:3000/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'email': 'test@example.com',
    'password': 'password123',
  }),
);

// Get Profile
final profileResponse = await http.get(
  Uri.parse('http://localhost:3000/users/profile'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
);
```

## Troubleshooting

### ปัญหา: MongoDB Connection Failed
**สาเหตุ:** MongoDB ไม่ได้รัน หรือ Connection String ไม่ถูกต้อง

**แก้ไข:**
1. ตรวจสอบว่า MongoDB รันอยู่:
   ```bash
   # macOS
   brew services list | grep mongodb
   
   # Linux
   sudo systemctl status mongod
   ```
2. ตรวจสอบ `MONGODB_URI` ในไฟล์ `.env`

### ปัญหา: JWT Token Invalid
**สาเหตุ:** Token หมดอายุ หรือ JWT_SECRET ไม่ตรงกัน

**แก้ไข:**
1. Login ใหม่เพื่อรับ Token ใหม่
2. ตรวจสอบว่า JWT_SECRET ตรงกันระหว่าง Server กับ Token ที่สร้าง

### ปัญหา: Port Already in Use
**สาเหตุ:** มี Process อื่นใช้ Port 3000 อยู่

**แก้ไข:**
1. หา Process ที่ใช้ Port:
   ```bash
   # macOS/Linux
   lsof -i :3000
   
   # Windows
   netstat -ano | findstr :3000
   ```
2. Kill Process หรือเปลี่ยน PORT ในไฟล์ `.env`

### ปัญหา: Dependencies Installation Failed
**สาเหตุ:** Node Version ไม่ตรงตามที่กำหนด

**แก้ไข:**
1. ตรวจสอบ Node Version:
   ```bash
   node --version
   ```
2. ติดตั้ง Node.js v18 หรือสูงกว่า

## สรุป

Backend ของ Loan Advisor เป็นระบบที่มีความปลอดภัยสูง ใช้เทคโนโลยีที่ทันสมัย และออกแบบให้ขยายได้ง่าย มีโมดูลหลัก 2 โมดูล:

1. **Auth Module** - จัดการการลงทะเบียนและเข้าสู่ระบบ
2. **Users Module** - จัดการข้อมูลผู้ใช้และ Profile

ระบบใช้ JWT สำหรับการยืนยันตัวตน, MongoDB สำหรับจัดเก็บข้อมูล และมีการตรวจสอบข้อมูลอย่างเข้มงวดเพื่อความปลอดภัย

สำหรับข้อมูลเพิ่มเติม:
- [Database Schema (ภาษาไทย)](DATABASE_SCHEMA_TH.md)
- [API Guide (ภาษาไทย)](API_GUIDE_TH.md)
- [English README](README.md)
