# Database Schema - ฐานข้อมูล Loan Advisor

## ภาพรวม

ระบบใช้ **MongoDB** เป็นฐานข้อมูล NoSQL พร้อม **Mongoose** เป็น ODM (Object Document Mapper) สำหรับจัดการข้อมูล

**ชื่อฐานข้อมูล:** `loan-advisor`

**Connection String (Default):** `mongodb://localhost:27017/loan-advisor`

## Collections

### 1. Users Collection

Collection นี้เก็บข้อมูลผู้ใช้ทั้งหมดในระบบ

#### ชื่อ Collection
```
users
```

#### Schema Definition

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
```

#### ฟิลด์ (Fields)

| ชื่อฟิลด์ | ประเภทข้อมูล | Required | Unique | Default | คำอธิบาย |
|----------|-------------|----------|--------|---------|----------|
| `_id` | ObjectId | ✅ | ✅ | auto-generated | ID ของเอกสาร (MongoDB auto-generated) |
| `email` | String | ✅ | ✅ | - | Email ของผู้ใช้ (ใช้สำหรับ Login) |
| `password` | String | ✅ | ❌ | - | รหัสผ่านที่เข้ารหัสด้วย bcrypt (ห้ามเก็บแบบ plain text) |
| `name` | String | ✅ | ❌ | - | ชื่อผู้ใช้ |
| `isActive` | Boolean | ❌ | ❌ | `true` | สถานะการใช้งานของบัญชี |
| `createdAt` | Date | ❌ | ❌ | auto-generated | วันเวลาที่สร้างเอกสาร |
| `updatedAt` | Date | ❌ | ❌ | auto-generated | วันเวลาที่อัพเดทเอกสารล่าสุด |

#### ข้อจำกัด (Constraints)

1. **Email Uniqueness:**
   - ไม่สามารถมี email ซ้ำกันในระบบ
   - MongoDB จะสร้าง Unique Index อัตโนมัติ

2. **Password Security:**
   - รหัสผ่านต้องผ่านการเข้ารหัสด้วย bcrypt (10 salt rounds)
   - ห้ามเก็บรหัสผ่านแบบ plain text

3. **Email Format:**
   - ต้องเป็นรูปแบบ Email ที่ถูกต้อง (ตรวจสอบโดย Class Validator)

4. **Password Length:**
   - รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร

#### Indexes

```typescript
// Index หลัก (Auto-created)
{ _id: 1 }          // Primary Index (MongoDB default)
{ email: 1 }        // Unique Index (auto-created from schema)

// Index เพิ่มเติม (ประกาศใน Schema)
UserSchema.index({ email: 1 });
```

**คำอธิบาย:**
- **Primary Index (_id):** สร้างอัตโนมัติโดย MongoDB สำหรับการค้นหาที่รวดเร็ว
- **Email Index:** ใช้สำหรับการค้นหาผู้ใช้จาก email (ใช้บ่อยใน Login)

#### ตัวอย่างข้อมูล (Sample Document)

```json
{
  "_id": "6543a1b2c3d4e5f6a7b8c9d0",
  "email": "user@example.com",
  "password": "$2b$10$abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGH",
  "name": "นายทดสอบ ระบบ",
  "isActive": true,
  "createdAt": "2025-10-27T10:30:00.000Z",
  "updatedAt": "2025-10-27T10:30:00.000Z",
  "__v": 0
}
```

#### การเข้ารหัสรหัสผ่าน (Password Hashing)

**Algorithm:** bcrypt
**Salt Rounds:** 10

```typescript
// การเข้ารหัสรหัสผ่าน
const hashedPassword = await bcrypt.hash(plainPassword, 10);

// การตรวจสอบรหัสผ่าน
const isMatch = await bcrypt.compare(plainPassword, hashedPassword);
```

**ตัวอย่าง:**
- Input: `"password123"`
- Output: `"$2b$10$N9qo8uLOickgx2ZMRZoMye.1YuO/j4pC3tY3JEKj7XFMU9dU1r0.m"`

**ข้อดีของ bcrypt:**
- ป้องกัน Rainbow Table Attack
- ใช้เวลานานในการ Crack (Slow by Design)
- Auto-generated Salt สำหรับแต่ละรหัสผ่าน

## Timestamps

ทุก Collection ใช้ `timestamps: true` ซึ่งจะสร้างฟิลด์ `createdAt` และ `updatedAt` อัตโนมัติ

- **createdAt:** บันทึกเวลาที่สร้างเอกสารครั้งแรก (ไม่เปลี่ยนแปลง)
- **updatedAt:** อัพเดทอัตโนมัติทุกครั้งที่มีการแก้ไขเอกสาร

## Relationships

ในระบบปัจจุบันมีเพียง Collection เดียว (Users) จึงยังไม่มี Relationships

### แนวทางการขยายในอนาคต

เมื่อเพิ่มฟีเจอร์การขอสินเชื่อ อาจต้องเพิ่ม Collections เพิ่มเติม:

#### 1. Loans Collection (ข้อมูลการขอสินเชื่อ)
```typescript
{
  userId: ObjectId,           // Reference to Users._id
  loanType: String,           // ประเภทสินเชื่อ (home, car, personal)
  amount: Number,             // จำนวนเงินที่ขอกู้
  interestRate: Number,       // อัตราดอกเบี้ย
  term: Number,               // ระยะเวลา (เดือน)
  status: String,             // สถานะ (pending, approved, rejected)
  monthlyPayment: Number,     // ค่าผ่อนต่อเดือน
  createdAt: Date,
  updatedAt: Date
}
```

**Relationship:** Many-to-One (User สามารถมีหลาย Loans)

#### 2. Documents Collection (เอกสารประกอบ)
```typescript
{
  userId: ObjectId,           // Reference to Users._id
  loanId: ObjectId,           // Reference to Loans._id
  documentType: String,       // ประเภทเอกสาร (id_card, income, etc.)
  filePath: String,           // Path ไฟล์ในระบบ
  fileUrl: String,            // URL สำหรับดาวน์โหลด
  uploadedAt: Date,
}
```

**Relationship:** Many-to-One (Loan สามารถมีหลาย Documents)

#### ตัวอย่าง ERD (Entity Relationship Diagram)

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Users     │         │   Loans     │         │  Documents  │
├─────────────┤         ├─────────────┤         ├─────────────┤
│ _id (PK)    │────────<│ userId (FK) │────────<│ loanId (FK) │
│ email       │    1:N  │ _id (PK)    │    1:N  │ userId (FK) │
│ password    │         │ loanType    │         │ fileType    │
│ name        │         │ amount      │         │ filePath    │
│ isActive    │         │ status      │         │ uploadedAt  │
│ createdAt   │         │ createdAt   │         │             │
│ updatedAt   │         │ updatedAt   │         │             │
└─────────────┘         └─────────────┘         └─────────────┘
```

## Queries ที่ใช้บ่อย

### 1. สร้างผู้ใช้ใหม่
```typescript
const user = new this.userModel({
  email: 'user@example.com',
  password: hashedPassword,
  name: 'John Doe',
});
await user.save();
```

### 2. ค้นหาผู้ใช้จาก Email
```typescript
const user = await this.userModel.findOne({ 
  email: 'user@example.com',
  isActive: true 
}).exec();
```

### 3. ค้นหาผู้ใช้จาก ID
```typescript
const user = await this.userModel.findById(userId).exec();
```

### 4. อัพเดทข้อมูลผู้ใช้
```typescript
await this.userModel.findByIdAndUpdate(
  userId,
  { name: 'New Name' },
  { new: true }
).exec();
```

### 5. ลบผู้ใช้ (Soft Delete)
```typescript
await this.userModel.findByIdAndUpdate(
  userId,
  { isActive: false },
  { new: true }
).exec();
```

### 6. ลบผู้ใช้ (Hard Delete)
```typescript
await this.userModel.findByIdAndDelete(userId).exec();
```

## Performance Optimization

### 1. Indexing Strategy

**Indexes ที่มีอยู่:**
```javascript
db.users.getIndexes()

[
  { "v": 2, "key": { "_id": 1 }, "name": "_id_" },
  { "v": 2, "key": { "email": 1 }, "name": "email_1", "unique": true }
]
```

**การเพิ่ม Index เพิ่มเติม (ถ้าจำเป็น):**
```javascript
// สำหรับการค้นหาผู้ใช้ที่ Active
db.users.createIndex({ "isActive": 1 })

// Compound Index สำหรับการค้นหาที่ซับซ้อน
db.users.createIndex({ "email": 1, "isActive": 1 })
```

### 2. Query Optimization

**ใช้ Projection เพื่อดึงเฉพาะฟิลด์ที่ต้องการ:**
```typescript
// ดี - ดึงเฉพาะฟิลด์ที่ต้องการ
const user = await this.userModel
  .findById(userId)
  .select('email name isActive')
  .exec();

// ไม่ดี - ดึงทุกฟิลด์รวมทั้ง password
const user = await this.userModel.findById(userId).exec();
```

**ไม่ส่งรหัสผ่านกลับไปใน Response:**
```typescript
// เอา password ออก
const { password, ...userResponse } = user.toObject();
return userResponse;
```

### 3. Connection Pooling

MongoDB Driver ใช้ Connection Pooling อัตโนมัติ

**การตั้งค่า (ถ้าจำเป็น):**
```typescript
MongooseModule.forRoot('mongodb://localhost:27017/loan-advisor', {
  maxPoolSize: 10,      // จำนวน Connection สูงสุดในพูล
  minPoolSize: 2,       // จำนวน Connection ขั้นต่ำในพูล
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 45000,
});
```

## Backup และ Restore

### Backup

```bash
# Backup ทั้งฐานข้อมูล
mongodump --db loan-advisor --out /backup/loan-advisor-$(date +%Y%m%d)

# Backup เฉพาะ Collection
mongodump --db loan-advisor --collection users --out /backup/users-$(date +%Y%m%d)

# Backup พร้อมบีบอัด
mongodump --db loan-advisor --archive=/backup/loan-advisor.archive --gzip
```

### Restore

```bash
# Restore ทั้งฐานข้อมูล
mongorestore --db loan-advisor /backup/loan-advisor-20251027

# Restore จากไฟล์ Archive
mongorestore --archive=/backup/loan-advisor.archive --gzip

# Restore ไปยังฐานข้อมูลอื่น
mongorestore --db loan-advisor-test /backup/loan-advisor-20251027/loan-advisor
```

### Automated Backup Script

```bash
#!/bin/bash
# backup.sh

BACKUP_DIR="/backup/mongodb"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="loan-advisor"

# สร้างโฟลเดอร์ถ้ายังไม่มี
mkdir -p $BACKUP_DIR

# Backup
mongodump --db $DB_NAME --archive=$BACKUP_DIR/$DB_NAME-$DATE.archive --gzip

# ลบ Backup เก่าที่เก็บไว้เกิน 7 วัน
find $BACKUP_DIR -name "*.archive" -mtime +7 -delete

echo "Backup completed: $DB_NAME-$DATE.archive"
```

**ตั้งค่า Cron Job (Linux/macOS):**
```bash
# เปิดแก้ไข crontab
crontab -e

# เพิ่มบรรทัดนี้เพื่อ Backup ทุกวันเวลา 02:00
0 2 * * * /path/to/backup.sh >> /var/log/mongodb-backup.log 2>&1
```

## Data Migration

### การย้ายข้อมูลจาก Development ไป Production

```bash
# 1. Export จาก Development
mongodump --uri="mongodb://localhost:27017/loan-advisor" \
  --archive=loan-advisor-dev.archive --gzip

# 2. Import ไป Production
mongorestore --uri="mongodb://production-server:27017/loan-advisor" \
  --archive=loan-advisor-dev.archive --gzip
```

### การ Migrate Schema

เมื่อเปลี่ยน Schema ควรใช้ Migration Script:

```typescript
// migration-add-phone-field.ts
import { MongoClient } from 'mongodb';

async function migrate() {
  const client = await MongoClient.connect('mongodb://localhost:27017');
  const db = client.db('loan-advisor');
  
  // เพิ่มฟิลด์ phone ให้กับผู้ใช้ที่ยังไม่มี
  await db.collection('users').updateMany(
    { phone: { $exists: false } },
    { $set: { phone: null } }
  );
  
  console.log('Migration completed');
  await client.close();
}

migrate();
```

## Security Best Practices

### 1. Database Authentication

```bash
# เปิดใช้งาน Authentication บน MongoDB
mongod --auth

# สร้าง Admin User
use admin
db.createUser({
  user: "admin",
  pwd: "strong_password_here",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
})

# สร้าง User สำหรับ Database
use loan-advisor
db.createUser({
  user: "loan_advisor_app",
  pwd: "app_password_here",
  roles: [ { role: "readWrite", db: "loan-advisor" } ]
})
```

**Connection String with Authentication:**
```
mongodb://loan_advisor_app:app_password_here@localhost:27017/loan-advisor
```

### 2. Network Security

- **Firewall:** อนุญาตเฉพาะ IP ที่จำเป็น
- **MongoDB Port:** เปลี่ยนจาก Default Port (27017) ในระบบจริง
- **SSL/TLS:** ใช้ SSL สำหรับการเชื่อมต่อ

### 3. Data Encryption

**Encryption at Rest:**
```bash
mongod --enableEncryption \
  --encryptionKeyFile /path/to/keyfile \
  --encryptionCipherMode AES256-CBC
```

**Encryption in Transit (SSL):**
```bash
mongod --tlsMode requireTLS \
  --tlsCertificateKeyFile /path/to/certificate.pem
```

### 4. Regular Updates

- อัพเดท MongoDB เป็น Version ล่าสุด
- ติดตาม Security Patches
- Review และ Audit Logs เป็นประจำ

## Monitoring

### Database Statistics

```javascript
// ขนาดฐานข้อมูล
db.stats()

// ขนาด Collection
db.users.stats()

// จำนวนเอกสาร
db.users.countDocuments()

// Performance Statistics
db.users.explain("executionStats").find({ email: "test@example.com" })
```

### Slow Queries

```javascript
// เปิดใช้งาน Profiler
db.setProfilingLevel(1, { slowms: 100 })

// ดู Slow Queries
db.system.profile.find().sort({ ts: -1 }).limit(5)
```

## Troubleshooting

### ปัญหา: Duplicate Key Error

**ข้อความ Error:**
```
E11000 duplicate key error collection: loan-advisor.users index: email_1
```

**สาเหตุ:** พยายามสร้างผู้ใช้ที่มี email ซ้ำ

**แก้ไข:**
1. ตรวจสอบว่า email นั้นมีอยู่แล้วหรือไม่ก่อนสร้าง
2. ใช้ try-catch เพื่อจัดการ Error

### ปัญหา: Connection Timeout

**สาเหตุ:** MongoDB ไม่ได้รัน หรือ Network ไม่สามารถเชื่อมต่อได้

**แก้ไข:**
1. ตรวจสอบว่า MongoDB รันอยู่
2. ตรวจสอบ Connection String
3. ตรวจสอบ Firewall Rules

### ปัญหา: Out of Memory

**สาเหตุ:** Query ข้อมูลมากเกินไป

**แก้ไข:**
1. ใช้ Pagination
2. ใช้ Projection เพื่อดึงเฉพาะฟิลด์ที่ต้องการ
3. เพิ่ม RAM ให้ Server

## สรุป

Database Schema ของ Loan Advisor ออกแบบให้เรียบง่าย มีประสิทธิภาพ และปลอดภัย:

- **Collection เดียว:** Users (ปัจจุบัน)
- **Indexes:** Email (Unique), _id (Primary)
- **Security:** Password Hashing, Authentication, Encryption
- **Performance:** Indexing, Connection Pooling, Query Optimization
- **Backup:** Automated Daily Backups
- **Monitoring:** Performance Tracking, Slow Query Detection

สามารถขยายเพิ่ม Collections อื่นๆ ได้ในอนาคตตามความต้องการของระบบ

**เอกสารที่เกี่ยวข้อง:**
- [คู่มือ Backend (ภาษาไทย)](BACKEND_TH.md)
- [คู่มือ API (ภาษาไทย)](API_GUIDE_TH.md)
