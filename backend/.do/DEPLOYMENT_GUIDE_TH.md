# คู่มือการ Deploy ไปยัง DigitalOcean

## การ Deploy แบบคลิกเดียว (One-Click Deployment)

Deploy Backend ของ Loan Advisor ไปยัง DigitalOcean App Platform ได้ในคลิกเดียว!

### สิ่งที่ต้องเตรียม
- บัญชี DigitalOcean
- บัญชี GitHub ที่เชื่อมต่อกับ DigitalOcean

### ค่าใช้จ่าย

#### ตัวเลือกที่ 1: ใช้ MongoDB ภายนอก (แนะนำ - $5/เดือน)
- **App Service**: $5/เดือน (Basic - 512MB RAM)
- **Database**: ฟรี (MongoDB Atlas Free Tier M0)
- **รวม**: **$5/เดือน**

#### ตัวเลือกที่ 2: ใช้ MongoDB แบบ Managed ($20/เดือน)
- **App Service**: $5/เดือน (Basic - 512MB RAM)
- **Managed MongoDB**: $15/เดือน (Dev Database - 1GB RAM)
- **รวม**: **$20/เดือน**

## ขั้นตอนการ Deploy

### ตัวเลือกที่ 1: Deploy พร้อม MongoDB ภายนอก (แนะนำสำหรับ $5/เดือน)

1. **ตั้งค่า MongoDB Atlas (ฟรี)**
   - ไปที่ [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
   - สร้างบัญชีและ Cluster ฟรี (M0 Free Tier)
   - สร้าง Database User
   - เพิ่ม IP Range ของ DigitalOcean ใน Whitelist (หรืออนุญาตทั้งหมด: 0.0.0.0/0)
   - คัดลอก Connection String

2. **Deploy ไปยัง DigitalOcean**
   - คลิกปุ่มด้านล่างหรือไปที่ [DigitalOcean Apps](https://cloud.digitalocean.com/apps/new)
   - เลือก Repository: `somkheartk/loan-advisor`
   - DigitalOcean จะตรวจจับไฟล์ `.do/app-with-external-db.yaml` อัตโนมัติ
   - หรือ Import ไฟล์ Configuration เอง

3. **ตั้งค่าตัวแปร Environment**
   ใน Dashboard ของ DigitalOcean App Platform ให้ตั้งค่า:
   - `MONGODB_URI`: Connection String จาก MongoDB Atlas
     ```
     mongodb+srv://username:password@cluster.mongodb.net/loan-advisor
     ```
   - `JWT_SECRET`: สร้างโดยใช้คำสั่ง:
     ```bash
     node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
     ```

4. **Deploy**
   - คลิก "Deploy" และรอให้การ Deploy เสร็จสมบูรณ์
   - API จะพร้อมใช้งานที่: `https://loan-advisor-backend-xxxxx.ondigitalocean.app`

### ตัวเลือกที่ 2: Deploy พร้อม Managed MongoDB ($20/เดือน)

1. **Deploy ไปยัง DigitalOcean**
   - คลิกปุ่มด้านล่างหรือไปที่ [DigitalOcean Apps](https://cloud.digitalocean.com/apps/new)
   - เลือก Repository: `somkheartk/loan-advisor`
   - DigitalOcean จะตรวจจับไฟล์ `.do/app.yaml` อัตโนมัติ
   - หรือ Import ไฟล์ Configuration เอง

2. **ตั้งค่าตัวแปร Environment**
   ใน Dashboard ของ DigitalOcean App Platform ให้ตั้งค่า:
   - `JWT_SECRET`: สร้างโดยใช้คำสั่ง:
     ```bash
     node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
     ```
   - `MONGODB_URI` จะถูกตั้งค่าอัตโนมัติจาก Managed Database

3. **Deploy**
   - คลิก "Deploy"
   - API จะพร้อมใช้งานที่: `https://loan-advisor-backend-xxxxx.ondigitalocean.app`

## ไฟล์ Configuration

### `.do/app.yaml`
Configuration แบบเต็มรูปแบบพร้อม MongoDB แบบ Managed จาก DigitalOcean ($20/เดือนรวม)

### `.do/app-with-external-db.yaml`
Configuration ที่ปรับให้เหมาะสำหรับใช้ MongoDB ภายนอกอย่าง MongoDB Atlas Free Tier ($5/เดือนรวม)

## หลังจาก Deploy

### ทดสอบ API

1. **Health Check**
   ```bash
   curl https://your-app-url.ondigitalocean.app/health
   ```

2. **สมัครสมาชิก**
   ```bash
   curl -X POST https://your-app-url.ondigitalocean.app/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "password": "password123",
       "name": "ทดสอบ ผู้ใช้"
     }'
   ```

3. **เข้าสู่ระบบ**
   ```bash
   curl -X POST https://your-app-url.ondigitalocean.app/auth/login \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "password": "password123"
     }'
   ```

### เชื่อมต่อกับ Flutter App

อัพเดท API Base URL ใน Flutter App ให้ชี้ไปที่ DigitalOcean App:

```dart
const String apiBaseUrl = 'https://your-app-url.ondigitalocean.app';
```

## การตรวจสอบและ Logs

- ดู Logs ใน Dashboard ของ DigitalOcean App Platform
- ตรวจสอบประสิทธิภาพและการใช้ทรัพยากร
- ตั้งค่า Alerts สำหรับ Downtime หรือ Errors

## การ Scaling

เมื่อแอปของคุณเติบโต สามารถอัพเกรดได้ง่าย:

1. **Professional tier**: $12/เดือน (1GB RAM)
2. **Professional Plus**: $24/เดือน (2GB RAM)
3. **Horizontal Scaling**: เพิ่มจำนวน Instance

## รายการตรวจสอบความปลอดภัย

- [x] ตั้งค่า JWT_SECRET เป็นค่าที่แข็งแรงและสุ่ม
- [x] ตั้งค่า MONGODB_URI เป็น Secret (ไม่แสดงใน Logs)
- [x] จำกัดการเข้าถึง Database ให้เฉพาะ IP ของ DigitalOcean
- [x] เปิดใช้งาน HTTPS อัตโนมัติ
- [x] เข้ารหัสตัวแปร Environment

## การแก้ปัญหา

### การ Deploy ล้มเหลว

**ปัญหา**: Build ล้มเหลวระหว่าง `npm ci`
- ตรวจสอบว่า `package.json` และ `package-lock.json` ถูก Commit แล้ว
- ตรวจสอบความเข้ากันได้ของ Node.js Version

**ปัญหา**: แอปพลิเคชัน Crash เมื่อเริ่มต้น
- ตรวจสอบว่าตัวแปร Environment ถูกตั้งค่าถูกต้อง
- ตรวจสอบความถูกต้องของ MongoDB Connection String
- ดู Logs ใน Dashboard ของ DigitalOcean

### ปัญหาการเชื่อมต่อ MongoDB

**ปัญหา**: เชื่อมต่อ MongoDB Atlas ไม่ได้
- ตรวจสอบ IP Whitelist รวม DigitalOcean (หรือ 0.0.0.0/0)
- ตรวจสอบข้อมูล Database User
- ตรวจสอบรูปแบบ Connection String

### API ไม่ตอบสนอง

**ปัญหา**: Health Check ล้มเหลว
- ตรวจสอบว่า PORT ตั้งเป็น 3000
- ตรวจสอบว่ามี Endpoint `/health` ใน Code
- ดู Application Logs

## เอกสารสนับสนุน

- [DigitalOcean App Platform Documentation](https://docs.digitalocean.com/products/app-platform/)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [NestJS Documentation](https://docs.nestjs.com/)

## เคล็ดลับการประหยัดค่าใช้จ่าย

1. **ใช้ MongoDB Atlas Free Tier** (M0) สำหรับการพัฒนาและระบบขนาดเล็ก
2. **เริ่มต้นด้วย Basic tier** ($5/เดือน) และอัพเกรดเมื่อจำเป็นเท่านั้น
3. **เปิด Auto-scaling** เฉพาะเมื่อ Traffic Pattern ต้องการจริงๆ
4. **ติดตามการใช้ทรัพยากร** เพื่อปรับขนาด Instance ให้เหมาะสม
5. **ใช้ CDN** สำหรับ Static Assets หากมีการให้บริการจาก API

## ขั้นตอนถัดไป

- ตั้งค่า Custom Domain
- ตั้งค่า SSL Certificate
- ตั้งค่า CI/CD ด้วย GitHub Actions
- เพิ่มระบบ Monitoring และ Alerting
- ตั้งค่ากลยุทธ์ Backup สำหรับ MongoDB
