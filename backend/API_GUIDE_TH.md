# คู่มือ API - Loan Advisor Backend

## ข้อมูลทั่วไป

**Base URL:** `http://localhost:3000`

**Content-Type:** `application/json`

**Authentication:** JWT Bearer Token

## สถานะ HTTP ที่ใช้

| สถานะ | ความหมาย | การใช้งาน |
|-------|----------|-----------|
| 200 | OK | Request สำเร็จ (GET, PUT, DELETE) |
| 201 | Created | สร้างข้อมูลสำเร็จ (POST) |
| 400 | Bad Request | ข้อมูลไม่ถูกต้อง / Validation Error |
| 401 | Unauthorized | ไม่มี Token หรือ Token ไม่ถูกต้อง |
| 404 | Not Found | ไม่พบข้อมูลที่ร้องขอ |
| 409 | Conflict | ข้อมูลซ้ำ (เช่น Email ซ้ำ) |
| 500 | Internal Server Error | เกิดข้อผิดพลาดภายใน Server |

## Endpoints

### 1. Health Check

ตรวจสอบสถานะของ Server

**Endpoint:** `GET /health`

**Authentication:** ไม่ต้องการ

**Request:**
```bash
curl http://localhost:3000/health
```

**Response (200 OK):**
```json
{
  "status": "ok",
  "message": "Loan Advisor Backend is running"
}
```

---

## Authentication Endpoints

### 2. ลงทะเบียนผู้ใช้ใหม่ (Register)

สร้างบัญชีผู้ใช้ใหม่และรับ JWT Token

**Endpoint:** `POST /auth/register`

**Authentication:** ไม่ต้องการ

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "นายทดสอบ ระบบ"
}
```

**Validation Rules:**
- `email`: ต้องเป็นรูปแบบ Email ที่ถูกต้อง, Required
- `password`: ต้องมีอย่างน้อย 6 ตัวอักษร, Required
- `name`: Required, ต้องไม่เป็นค่าว่าง

**cURL Example:**
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "ทดสอบ ผู้ใช้"
  }'
```

**Response (201 Created):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "email": "test@example.com",
    "name": "ทดสอบ ผู้ใช้"
  }
}
```

**Error Responses:**

**400 Bad Request** - Validation Error:
```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "password must be longer than or equal to 6 characters"
  ],
  "error": "Bad Request"
}
```

**409 Conflict** - Email Already Exists:
```json
{
  "statusCode": 409,
  "message": "User with this email already exists",
  "error": "Conflict"
}
```

---

### 3. เข้าสู่ระบบ (Login)

ยืนยันตัวตนและรับ JWT Token

**Endpoint:** `POST /auth/login`

**Authentication:** ไม่ต้องการ

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Validation Rules:**
- `email`: ต้องเป็นรูปแบบ Email ที่ถูกต้อง, Required
- `password`: Required

**cURL Example:**
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

**Response (200 OK):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "email": "test@example.com",
    "name": "ทดสอบ ผู้ใช้"
  }
}
```

**Error Responses:**

**400 Bad Request** - Validation Error:
```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "password should not be empty"
  ],
  "error": "Bad Request"
}
```

**401 Unauthorized** - Invalid Credentials:
```json
{
  "statusCode": 401,
  "message": "Invalid credentials",
  "error": "Unauthorized"
}
```

---

## User Endpoints

### 4. ดึงข้อมูลโปรไฟล์ (Get Profile)

ดึงข้อมูลของผู้ใช้ที่ Login อยู่

**Endpoint:** `GET /users/profile`

**Authentication:** ✅ Required (JWT Token)

**Request Headers:**
```
Authorization: Bearer <your-jwt-token>
Content-Type: application/json
```

**cURL Example:**
```bash
curl -X GET http://localhost:3000/users/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Response (200 OK):**
```json
{
  "email": "test@example.com",
  "name": "ทดสอบ ผู้ใช้",
  "isActive": true,
  "createdAt": "2025-10-27T10:30:00.000Z",
  "updatedAt": "2025-10-27T10:30:00.000Z"
}
```

**Error Responses:**

**401 Unauthorized** - Missing or Invalid Token:
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

**404 Not Found** - User Not Found:
```json
{
  "statusCode": 404,
  "message": "User not found",
  "error": "Not Found"
}
```

---

## JWT Token

### โครงสร้าง JWT Token

```json
{
  "email": "test@example.com",
  "sub": "6543a1b2c3d4e5f6a7b8c9d0",
  "iat": 1730027000,
  "exp": 1730631800
}
```

**คำอธิบาย:**
- `email`: Email ของผู้ใช้
- `sub`: User ID (MongoDB ObjectId)
- `iat`: Issued At - เวลาที่สร้าง Token (Unix Timestamp)
- `exp`: Expiration - เวลาหมดอายุ (Unix Timestamp, หลังจาก 7 วัน)

### การใช้งาน JWT Token

1. **รับ Token:**
   - เมื่อ Register หรือ Login สำเร็จ จะได้รับ `accessToken`
   
2. **เก็บ Token:**
   - บันทึก Token ใน Secure Storage (Flutter: flutter_secure_storage)
   - **ห้าม** เก็บใน localStorage หรือ SharedPreferences แบบไม่เข้ารหัส
   
3. **ส่ง Token:**
   - ใส่ Token ใน Authorization Header
   - Format: `Bearer <token>`
   
4. **อายุ Token:**
   - Token หมดอายุใน 7 วัน
   - ต้อง Login ใหม่เมื่อ Token หมดอายุ

### ตัวอย่างการใช้ Token

**JavaScript/Node.js:**
```javascript
const axios = require('axios');

const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

const response = await axios.get('http://localhost:3000/users/profile', {
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
});
```

**Flutter/Dart:**
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

final response = await http.get(
  Uri.parse('http://localhost:3000/users/profile'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
);

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  print('User: ${data['name']}');
}
```

**Python:**
```python
import requests

token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'

headers = {
    'Authorization': f'Bearer {token}',
    'Content-Type': 'application/json'
}

response = requests.get('http://localhost:3000/users/profile', headers=headers)
print(response.json())
```

---

## Error Handling

### รูปแบบ Error Response

```json
{
  "statusCode": 400,
  "message": "คำอธิบายข้อผิดพลาด",
  "error": "ประเภท Error"
}
```

### Error Types

#### 1. Validation Error (400)

เกิดเมื่อข้อมูลที่ส่งมาไม่ถูกต้อง

```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "password must be longer than or equal to 6 characters",
    "name should not be empty"
  ],
  "error": "Bad Request"
}
```

**วิธีแก้ไข:**
- ตรวจสอบข้อมูลที่ส่งไปให้ตรงตามเงื่อนไข
- ดูรายละเอียดใน `message` array

#### 2. Authentication Error (401)

เกิดเมื่อไม่มี Token หรือ Token ไม่ถูกต้อง

```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

**วิธีแก้ไข:**
- ตรวจสอบว่าส่ง Token ใน Header หรือไม่
- ตรวจสอบว่า Token ยังไม่หมดอายุ
- Login ใหม่เพื่อรับ Token ใหม่

#### 3. Not Found Error (404)

เกิดเมื่อไม่พบข้อมูลที่ร้องขอ

```json
{
  "statusCode": 404,
  "message": "User not found",
  "error": "Not Found"
}
```

**วิธีแก้ไข:**
- ตรวจสอบว่า User ID ถูกต้อง
- ตรวจสอบว่าข้อมูลยังอยู่ในระบบ

#### 4. Conflict Error (409)

เกิดเมื่อข้อมูลซ้ำ

```json
{
  "statusCode": 409,
  "message": "User with this email already exists",
  "error": "Conflict"
}
```

**วิธีแก้ไข:**
- ใช้ email อื่นที่ยังไม่มีในระบบ
- ตรวจสอบว่ามีบัญชีอยู่แล้วหรือไม่

#### 5. Internal Server Error (500)

เกิดข้อผิดพลาดภายใน Server

```json
{
  "statusCode": 500,
  "message": "Internal server error"
}
```

**วิธีแก้ไข:**
- ตรวจสอบ Server Logs
- ติดต่อทีมพัฒนา

---

## Integration Examples

### Flutter Integration

#### 1. ติดตั้ง Packages

```yaml
# pubspec.yaml
dependencies:
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0
```

#### 2. Auth Service

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000';
  final storage = FlutterSecureStorage();
  
  // Register
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['accessToken']);
      return data;
    } else {
      throw Exception('Registration failed');
    }
  }
  
  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['accessToken']);
      return data;
    } else {
      throw Exception('Login failed');
    }
  }
  
  // Get Profile
  Future<Map<String, dynamic>> getProfile() async {
    final token = await storage.read(key: 'token');
    
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get profile');
    }
  }
  
  // Logout
  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
  
  // Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }
}
```

#### 3. การใช้งานใน Widget

```dart
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  Future<void> _login() async {
    try {
      final result = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เข้าสู่ระบบไม่สำเร็จ: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เข้าสู่ระบบ')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('เข้าสู่ระบบ'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Testing

### Postman Collection

สร้าง Collection ใหม่ใน Postman พร้อม Requests ต่อไปนี้:

#### 1. Register
```
POST http://localhost:3000/auth/register
Headers:
  Content-Type: application/json
Body (raw JSON):
{
  "email": "test@example.com",
  "password": "password123",
  "name": "Test User"
}
```

#### 2. Login
```
POST http://localhost:3000/auth/login
Headers:
  Content-Type: application/json
Body (raw JSON):
{
  "email": "test@example.com",
  "password": "password123"
}
```

#### 3. Get Profile
```
GET http://localhost:3000/users/profile
Headers:
  Authorization: Bearer {{token}}
  Content-Type: application/json
```

**การใช้ Environment Variables ใน Postman:**

1. สร้าง Environment ใหม่ชื่อ "Local"
2. เพิ่มตัวแปร:
   - `base_url`: `http://localhost:3000`
   - `token`: (ว่างไว้ก่อน)
3. ใช้ใน Request: `{{base_url}}/auth/login`
4. เมื่อ Login สำเร็จ ใช้ Script ใน Tests tab:
   ```javascript
   var data = pm.response.json();
   pm.environment.set("token", data.accessToken);
   ```

### Test Script (Bash)

```bash
#!/bin/bash
# test-api.sh

BASE_URL="http://localhost:3000"
EMAIL="test@example.com"
PASSWORD="password123"
NAME="Test User"

echo "=== Testing Loan Advisor API ==="

# 1. Health Check
echo -e "\n1. Health Check"
curl -X GET "$BASE_URL/health"

# 2. Register
echo -e "\n\n2. Register New User"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$EMAIL\",
    \"password\": \"$PASSWORD\",
    \"name\": \"$NAME\"
  }")
echo $REGISTER_RESPONSE | jq .

# 3. Login
echo -e "\n3. Login"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$EMAIL\",
    \"password\": \"$PASSWORD\"
  }")
echo $LOGIN_RESPONSE | jq .

# Extract token
TOKEN=$(echo $LOGIN_RESPONSE | jq -r .accessToken)

# 4. Get Profile
echo -e "\n4. Get Profile"
curl -s -X GET "$BASE_URL/users/profile" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" | jq .

echo -e "\n\n=== Tests Completed ==="
```

**วิธีรัน:**
```bash
chmod +x test-api.sh
./test-api.sh
```

---

## Rate Limiting (แนะนำสำหรับอนาคต)

เพิ่ม Rate Limiting เพื่อป้องกัน Abuse:

```typescript
// ติดตั้ง package
npm install @nestjs/throttler

// ตั้งค่าใน app.module.ts
ThrottlerModule.forRoot([{
  ttl: 60000,  // 1 นาที
  limit: 10,   // สูงสุด 10 requests ต่อนาที
}])

// ใช้กับ Controller
@UseGuards(ThrottlerGuard)
@Controller('auth')
export class AuthController { ... }
```

---

## Versioning (แนะนำสำหรับอนาคต)

เมื่อมีการเปลี่ยนแปลง API ใหญ่ ควรใช้ Versioning:

```
v1: http://localhost:3000/v1/auth/login
v2: http://localhost:3000/v2/auth/login
```

---

## สรุป

API ของ Loan Advisor มี Endpoints หลัก 4 ตัว:

1. **GET /health** - Health Check
2. **POST /auth/register** - ลงทะเบียน
3. **POST /auth/login** - เข้าสู่ระบบ
4. **GET /users/profile** - ดึงข้อมูล Profile (ต้อง Login)

**การยืนยันตัวตน:**
- ใช้ JWT Token
- Token หมดอายุใน 7 วัน
- ส่ง Token ใน Authorization Header: `Bearer <token>`

**ความปลอดภัย:**
- Password Hashing (bcrypt)
- Input Validation
- JWT Authentication
- CORS Protection

**เอกสารที่เกี่ยวข้อง:**
- [คู่มือ Backend (ภาษาไทย)](BACKEND_TH.md)
- [Database Schema (ภาษาไทย)](DATABASE_SCHEMA_TH.md)
