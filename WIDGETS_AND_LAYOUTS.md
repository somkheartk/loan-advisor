# 📱 คู่มือ Widget และ Layout แยกตามหน้า

คู่มือฉบับนี้อธิบายรายละเอียดการใช้ Widget และวิธีการสร้าง Layout สำหรับแต่ละหน้าในแอป Loan Advisor โดยเฉพาะ พร้อมตัวอย่างโค้ดที่ใช้งานจริง

---

## 📋 สารบัญ

1. [หน้า Login (เข้าสู่ระบบ)](#1-หน้า-login-เข้าสู่ระบบ)
2. [หน้า Register (สมัครสมาชิก)](#2-หน้า-register-สมัครสมาชิก)
3. [หน้า Home (หน้าหลัก)](#3-หน้า-home-หน้าหลัก)
4. [หน้า House Loan Calculator](#4-หน้า-house-loan-calculator)
5. [หน้า Car Loan Calculator](#5-หน้า-car-loan-calculator)
6. [หน้า Personal Loan Calculator](#6-หน้า-personal-loan-calculator)
7. [หน้า Other Loan Calculator](#7-หน้า-other-loan-calculator)
8. [หน้า Profile (โปรไฟล์)](#8-หน้า-profile-โปรไฟล์)
9. [สรุป Widget ที่ใช้ทั้งหมด](#สรุป-widget-ที่ใช้ทั้งหมด)

---

## 1. หน้า Login (เข้าสู่ระบบ)

### 🎨 ลักษณะหน้าจอ
หน้า Login ใช้ Layout แบบ **Center Layout** โดยจัดเนื้อหาให้อยู่ตรงกลางหน้าจอ มีพื้นหลังเป็น Gradient สีน้ำเงิน-ม่วง

### 📦 Widget ที่ใช้

| Widget | จำนวน | หน้าที่ |
|--------|-------|---------|
| `Scaffold` | 1 | โครงสร้างหลักของหน้าจอ |
| `Container` | 4 | พื้นหลัง gradient, การ์ดฟอร์ม, วงกลมโลโก้ |
| `SafeArea` | 1 | ป้องกันการซ้อนทับกับ system UI |
| `Center` | 1 | จัดเนื้อหาให้อยู่ตรงกลาง |
| `SingleChildScrollView` | 1 | ทำให้เลื่อนได้เมื่อหน้าจอเล็ก |
| `Column` | 2 | จัดเรียง widgets แนวตั้ง |
| `Form` | 1 | จัดการฟอร์มและ validation |
| `TextFormField` | 2 | ช่องกรอกอีเมลและรหัสผ่าน |
| `ElevatedButton` | 1 | ปุ่มเข้าสู่ระบบ |
| `TextButton` | 1 | ปุ่มสมัครสมาชิก |
| `Icon` | 3 | ไอคอนโลโก้, อีเมล, รหัสผ่าน |
| `Text` | 8+ | แสดงข้อความต่างๆ |
| `CircularProgressIndicator` | 1 | แสดงสถานะ loading |
| `GestureDetector` | 1 | ตรวจจับการแตะเพื่อเติมข้อมูลทดสอบ |

### 🏗️ โครงสร้าง Layout

```
Scaffold
└── Container (Gradient Background)
    └── SafeArea
        └── Center
            └── SingleChildScrollView
                └── Column [mainAxisAlignment: center]
                    ├── Container (วงกลมขาว)
                    │   └── Icon (calculate)
                    ├── Text ("Loan Calculator")
                    ├── Text ("คำนวณเงินกู้ง่ายๆ")
                    ├── Container (การ์ดฟอร์มขาว)
                    │   └── Form
                    │       └── Column
                    │           ├── Text ("เข้าสู่ระบบ")
                    │           ├── TextFormField (อีเมล)
                    │           ├── TextFormField (รหัสผ่าน)
                    │           └── ElevatedButton ("เข้าสู่ระบบ")
                    └── Container (ส่วนสมัครสมาชิก)
                        └── Column
                            ├── Text ("ยังไม่มีบัญชี?")
                            ├── TextButton ("สมัครสมาชิก")
                            └── Container (ข้อมูลทดสอบ)
```

### 💻 วิธีสร้าง Layout ทีละขั้นตอน

#### ขั้นที่ 1: สร้างพื้นหลัง Gradient
```dart
Scaffold(
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF4285F4), // Google Blue
          Color(0xFF8E24AA), // Purple
        ],
      ),
    ),
    // เนื้อหาต่อไป...
  ),
)
```

#### ขั้นที่ 2: เพิ่ม SafeArea และ Center
```dart
child: SafeArea(
  child: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // เนื้อหาต่อไป...
        ],
      ),
    ),
  ),
)
```

#### ขั้นที่ 3: สร้างโลโก้
```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: const BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
  ),
  child: const Icon(
    Icons.calculate,
    size: 60,
    color: Color(0xFF4285F4),
  ),
),
const SizedBox(height: 24),
```

#### ขั้นที่ 4: เพิ่มชื่อแอป
```dart
const Text(
  'Loan Calculator',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  textAlign: TextAlign.center,
),
const SizedBox(height: 8),
const Text(
  'คำนวณเงินกู้ง่ายๆ ในมือถือ',
  style: TextStyle(
    fontSize: 16,
    color: Colors.white70,
  ),
  textAlign: TextAlign.center,
),
```

#### ขั้นที่ 5: สร้างการ์ดฟอร์ม
```dart
Container(
  padding: const EdgeInsets.all(24.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  ),
  child: Form(
    key: _formKey,
    child: Column(
      children: [
        // ฟอร์มต่อไป...
      ],
    ),
  ),
)
```

#### ขั้นที่ 6: เพิ่มช่องกรอกข้อมูล
```dart
TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
    hintText: 'example@email.com',
    labelText: 'อีเมล',
    prefixIcon: const Icon(Icons.email_outlined),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
  ),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    if (!value.contains('@')) {
      return 'กรุณากรอกอีเมลให้ถูกต้อง';
    }
    return null;
  },
),
```

#### ขั้นที่ 7: เพิ่มปุ่ม
```dart
ElevatedButton(
  onPressed: _isLoading ? null : _login,
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4285F4),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: _isLoading
    ? const CircularProgressIndicator(color: Colors.white)
    : const Text('เข้าสู่ระบบ'),
)
```

### 🎯 จุดสำคัญ
- ใช้ `GlobalKey<FormState>` สำหรับจัดการ Form validation
- ใช้ `TextEditingController` สำหรับเข้าถึงค่าในช่องกรอก
- มี loading state (`_isLoading`) สำหรับแสดง progress
- ใช้ `Navigator.pushReplacement` เพื่อไปหน้าหลักหลังจาก login สำเร็จ

---

## 2. หน้า Register (สมัครสมาชิก)

### 🎨 ลักษณะหน้าจอ
หน้า Register ใช้ Layout แบบ **Form Layout** มี AppBar และฟอร์มกรอกข้อมูล

### 📦 Widget ที่ใช้

| Widget | จำนวน | หน้าที่ |
|--------|-------|---------|
| `Scaffold` | 1 | โครงสร้างหลัก |
| `AppBar` | 1 | แถบด้านบน |
| `SafeArea` | 1 | ป้องกันการซ้อนทับ |
| `SingleChildScrollView` | 1 | เลื่อนได้ |
| `Form` | 1 | จัดการฟอร์ม |
| `Column` | 1 | จัดเรียงแนวตั้ง |
| `TextFormField` | 4 | ชื่อ, อีเมล, รหัสผ่าน, ยืนยันรหัสผ่าน |
| `ElevatedButton` | 1 | ปุ่มสมัครสมาชิก |
| `Icon` | 5 | ไอคอนต่างๆ |
| `Text` | 2 | หัวข้อ |

### 🏗️ โครงสร้าง Layout

```
Scaffold
├── AppBar
│   └── Text ("สมัครสมาชิก")
└── SafeArea
    └── SingleChildScrollView
        └── Form
            └── Column
                ├── Icon (person_add)
                ├── Text ("สร้างบัญชีใหม่")
                ├── TextFormField (ชื่อ)
                ├── TextFormField (อีเมล)
                ├── TextFormField (รหัสผ่าน)
                ├── TextFormField (ยืนยันรหัสผ่าน)
                └── ElevatedButton ("สมัครสมาชิก")
```

### 💻 วิธีสร้าง Layout

#### ขั้นที่ 1: สร้าง Scaffold พร้อม AppBar
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('สมัครสมาชิก'),
  ),
  body: SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // เนื้อหา...
          ],
        ),
      ),
    ),
  ),
)
```

#### ขั้นที่ 2: เพิ่มไอคอนและหัวข้อ
```dart
const Icon(
  Icons.person_add,
  size: 80,
  color: Colors.blue,
),
const SizedBox(height: 24),
const Text(
  'สร้างบัญชีใหม่',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  textAlign: TextAlign.center,
),
const SizedBox(height: 32),
```

#### ขั้นที่ 3: เพิ่มฟิลด์กรอกข้อมูล
```dart
TextFormField(
  controller: _nameController,
  decoration: const InputDecoration(
    labelText: 'ชื่อ',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.person),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกชื่อ';
    }
    return null;
  },
),
const SizedBox(height: 16),
// ช่องอื่นๆ ตามมา...
```

#### ขั้นที่ 4: ยืนยันรหัสผ่านต้องตรงกัน
```dart
TextFormField(
  controller: _confirmPasswordController,
  obscureText: true,
  validator: (value) {
    if (value != _passwordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }
    return null;
  },
)
```

### 🎯 จุดสำคัญ
- ตรวจสอบว่ารหัสผ่านและยืนยันรหัสผ่านตรงกัน
- Auto-login หลังจากสมัครสำเร็จ
- ใช้ `Navigator.pushReplacement` เพื่อไปหน้าหลัก

---

## 3. หน้า Home (หน้าหลัก)

### 🎨 ลักษณะหน้าจอ
หน้า Home ใช้ Layout แบบ **Header + Scrollable Content** มี Header แบบ Fixed และเนื้อหาที่เลื่อนได้

### 📦 Widget ที่ใช้

| Widget | จำนวน | หน้าที่ |
|--------|-------|---------|
| `Scaffold` | 1 | โครงสร้างหลัก |
| `Container` | 10+ | พื้นหลัง, การ์ด, กล่องต่างๆ |
| `SafeArea` | 1 | ป้องกันการซ้อนทับ |
| `Column` | 5+ | จัดเรียงแนวตั้ง |
| `Row` | 3+ | จัดเรียงแนวนอน |
| `Expanded` | 2 | ขยายเต็มพื้นที่ |
| `SingleChildScrollView` | 1 | เลื่อนได้ |
| `GridView.count` | 1 | แสดงตัวเลือกแบบตาราง 2x2 |
| `InkWell` | 4 | การ์ดที่กดได้ |
| `AppIcon` | 1 | ไอคอนแอป (Custom Widget) |
| `LoanTypeIcon` | 4 | ไอคอนประเภทสินเชื่อ (Custom Widget) |
| `TextFormField` | 3 | ฟอร์มคำนวณด่วน |
| `IconButton` | 1 | ปุ่มโปรไฟล์ |
| `CircleAvatar` | 1 | รูปโปรไฟล์ |

### 🏗️ โครงสร้าง Layout

```
Scaffold
└── Container (Gradient Background)
    └── SafeArea
        └── Column
            ├── Padding (Header - Fixed)
            │   └── Row
            │       ├── AppIcon + Text (Logo & Title)
            │       └── IconButton (Profile)
            └── Expanded (Content Area)
                └── Container (White Background with Curves)
                    └── SingleChildScrollView
                        └── Column
                            ├── Container (User Info Card)
                            │   └── Row
                            │       ├── CircleAvatar
                            │       ├── Column (Name & Status)
                            │       └── IconButton
                            ├── Text ("เครื่องมือคำนวณ")
                            ├── GridView.count (2x2)
                            │   ├── Card (House Loan)
                            │   ├── Card (Car Loan)
                            │   ├── Card (Personal Loan)
                            │   └── Card (Other Loan)
                            └── Container (Quick Calculator)
                                └── Form
                                    ├── TextFormField (จำนวนเงิน)
                                    ├── TextFormField (อัตราดอกเบี้ย)
                                    ├── TextFormField (ระยะเวลา)
                                    ├── ElevatedButton (คำนวณ)
                                    └── Container (Results - conditional)
```

### 💻 วิธีสร้าง Layout

#### ขั้นที่ 1: สร้างพื้นหลัง Gradient และ Header
```dart
Scaffold(
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF4285F4), Color(0xFF8E24AA)],
      ),
    ),
    child: SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppIcon(size: 32),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Loan Advisor', style: TextStyle(color: Colors.white)),
                        Text('คำนวณเงินกู้ง่ายๆ', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () { /* Navigate to Profile */ },
                ),
              ],
            ),
          ),
          // Content...
        ],
      ),
    ),
  ),
)
```

#### ขั้นที่ 2: สร้างพื้นที่เนื้อหาขาวมุมโค้ง
```dart
Expanded(
  child: Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // เนื้อหา...
        ],
      ),
    ),
  ),
)
```

#### ขั้นที่ 3: สร้าง User Info Card
```dart
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.grey.shade50,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.shade200),
  ),
  child: Row(
    children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFF4285F4),
        child: Icon(Icons.person, color: Colors.white, size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_userName, style: TextStyle(fontWeight: FontWeight.w600)),
            Text('สมาชิกทั่วไป', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward_ios, size: 14),
        onPressed: () { /* Navigate */ },
      ),
    ],
  ),
)
```

#### ขั้นที่ 4: สร้าง GridView สำหรับตัวเลือกคำนวณ
```dart
GridView.count(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  childAspectRatio: 1.2,
  children: [
    _buildCalculatorCard(
      title: 'บ้าน',
      icon: LoanTypeIcon(type: LoanType.house, size: 48),
      onTap: () { /* Navigate to House Calculator */ },
    ),
    _buildCalculatorCard(
      title: 'รถยนต์',
      icon: LoanTypeIcon(type: LoanType.car, size: 48),
      onTap: () { /* Navigate to Car Calculator */ },
    ),
    // ... อื่นๆ
  ],
)
```

#### ขั้นที่ 5: สร้างฟังก์ชัน _buildCalculatorCard
```dart
Widget _buildCalculatorCard({
  required String title,
  required Widget icon,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
```

### 🎯 จุดสำคัญ
- ใช้ `shrinkWrap: true` และ `physics: NeverScrollableScrollPhysics()` ใน GridView เพื่อไม่ให้ scroll แยก
- ใช้ Custom Widgets (`AppIcon`, `LoanTypeIcon`) สำหรับไอคอน
- Header เป็น Fixed ส่วนเนื้อหาใน Expanded จะ scroll ได้

---

## 4. หน้า House Loan Calculator

### 🎨 ลักษณะหน้าจอ
หน้าคำนวณสินเชื่อบ้านใช้ Layout แบบ **Header + Form + Results**

### 📦 Widget ที่ใช้

| Widget | จำนวน | หน้าที่ |
|--------|-------|---------|
| `Scaffold` | 1 | โครงสร้างหลัก |
| `Container` | 10+ | พื้นหลัง, การ์ด, กล่อง |
| `Column` | 4+ | จัดเรียงแนวตั้ง |
| `Row` | 3+ | จัดเรียงแนวนอน |
| `Form` | 1 | จัดการฟอร์ม |
| `TextFormField` | 3 | จำนวนเงิน, อัตราดอกเบี้ย, ระยะเวลา |
| `ElevatedButton` | 2 | คำนวณ, เคลียร์ |
| `Icon` | 2+ | ไอคอนบ้าน, ปุ่มย้อนกลับ |
| `IconButton` | 1 | ปุ่ม Back |

### 🏗️ โครงสร้าง Layout

```
Scaffold
└── Container (Gradient Background)
    └── SafeArea
        └── Column
            ├── Padding (Header)
            │   └── Row
            │       ├── IconButton (Back)
            │       └── Column
            │           ├── Text (Title)
            │           └── Text (Subtitle)
            └── Expanded
                └── Container (White Curved Background)
                    └── SingleChildScrollView
                        └── Form
                            └── Column
                                ├── Icon (home) + Text
                                ├── TextFormField (จำนวนเงินกู้)
                                ├── TextFormField (อัตราดอกเบี้ย)
                                ├── TextFormField (ระยะเวลา)
                                ├── ElevatedButton (คำนวณ)
                                ├── ElevatedButton (เคลียร์) [conditional]
                                └── Container (Results) [conditional]
                                    └── Column
                                        ├── Row (ยอดผ่อนต่อเดือน)
                                        ├── Row (ยอดชำระรวม)
                                        └── Row (ดอกเบี้ยรวม)
```

### 💻 วิธีสร้าง Layout

#### ขั้นที่ 1: สร้าง Header พร้อมปุ่ม Back
```dart
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'คำนวณสินเชื่อบ้าน',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'คำนวณยอดผ่อนรายเดือน',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    ],
  ),
)
```

#### ขั้นที่ 2: สร้างไอคอนและหัวข้อ
```dart
Column(
  children: [
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFF9800).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.home,
        size: 48,
        color: Color(0xFFFF9800),
      ),
    ),
    SizedBox(height: 16),
    Text(
      'สินเชื่อบ้าน',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
)
```

#### ขั้นที่ 3: สร้างฟิลด์กรอกข้อมูล
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'จำนวนเงินกู้',
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    TextFormField(
      controller: _loanAmountController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        labelText: 'จำนวนเงินกู้ (บาท)',
        hintText: 'กรุณากรอกจำนวนเงินกู้',
        suffixText: 'บาท',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกจำนวนเงินกู้';
        }
        return null;
      },
    ),
  ],
)
```

#### ขั้นที่ 4: สร้างปุ่มคำนวณ
```dart
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _calculate,
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF4285F4),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Text(
      'คำนวณ',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
)
```

#### ขั้นที่ 5: แสดงผลลัพธ์
```dart
if (_monthlyPayment > 0) Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Color(0xFF4285F4).withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Color(0xFF4285F4).withOpacity(0.3)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'ผลการคำนวณ',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      _buildResultRow('ยอดผ่อนต่อเดือน', _numberFormat.format(_monthlyPayment)),
      _buildResultRow('ยอดรวมที่ต้องจ่าย', _numberFormat.format(_totalPayment)),
      _buildResultRow('ดอกเบี้ยรวม', _numberFormat.format(_totalInterest)),
    ],
  ),
)

Widget _buildResultRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        Text(
          '฿$value',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
```

### 🎯 จุดสำคัญ
- ใช้ `intl` package สำหรับจัดรูปแบบตัวเลข (NumberFormat)
- ใช้ `FilteringTextInputFormatter.digitsOnly` เพื่อให้กรอกเฉพาะตัวเลข
- แสดงผลลัพธ์เมื่อ `_monthlyPayment > 0` เท่านั้น
- ใช้ Use Case pattern สำหรับการคำนวณ

---

## 5. หน้า Car Loan Calculator

### 🎨 ลักษณะหน้าจอ
หน้าคำนวณสินเชื่อรถยนต์ คล้ายกับ House Loan แต่มีฟิลด์เพิ่มเติมสำหรับเงินดาวน์

### 📦 Widget ที่ใช้เพิ่มเติม
- `TextFormField` สำหรับ "ราคารถ" และ "เงินดาวน์"
- การคำนวณที่ซับซ้อนกว่า (มีการหักเงินดาวน์)

### 🏗️ โครงสร้าง Layout
โครงสร้างเหมือนกับ House Loan Calculator แต่มีฟิลด์เพิ่มเติม:
- ราคารถ
- เงินดาวน์ (หรือเปอร์เซ็นต์)
- จำนวนเงินกู้ (คำนวณอัตโนมัติ)
- อัตราดอกเบี้ย
- ระยะเวลา

### 💻 จุดเด่น
- คำนวณจำนวนเงินกู้ = ราคารถ - เงินดาวน์
- แสดงเปอร์เซ็นต์เงินดาวน์

---

## 6. หน้า Personal Loan Calculator

### 🎨 ลักษณะหน้าจอ
หน้าคำนวณสินเชื่อส่วนบุคคล มีฟิลด์พื้นฐาน 3 ช่อง

### 📦 Widget และ Layout
เหมือนกับ House Loan Calculator

### 🎯 จุดสำคัญ
- ใช้สีเขียวเป็นสีหลัก (`Color(0xFF34A853)`)
- ไอคอน `Icons.person`

---

## 7. หน้า Other Loan Calculator

### 🎨 ลักษณะหน้าจอ
หน้าคำนวณสินเชื่ออื่นๆ (ทั่วไป)

### 📦 Widget และ Layout
เหมือนกับ House Loan Calculator

### 🎯 จุดสำคัญ
- ใช้สีม่วงเป็นสีหลัก (`Color(0xFF8E24AA)`)
- ไอคอน `Icons.account_balance`

---

## 8. หน้า Profile (โปรไฟล์)

### 🎨 ลักษณะหน้าจอ
หน้า Profile ใช้ Layout แบบ **Header + Scrollable Sections**

### 📦 Widget ที่ใช้

| Widget | จำนวน | หน้าที่ |
|--------|-------|---------|
| `Scaffold` | 1 | โครงสร้างหลัก |
| `WillPopScope` | 1 | จัดการปุ่ม Back |
| `Container` | 15+ | พื้นหลัง, การ์ด, กล่อง |
| `Column` | 8+ | จัดเรียงแนวตั้ง |
| `Row` | 5+ | จัดเรียงแนวนอน |
| `IconButton` | 3 | Back, Logout |
| `CircleAvatar` | 1 | รูปโปรไฟล์ |
| `InkWell` | 7 | รายการที่กดได้ |
| `Icon` | 10+ | ไอคอนต่างๆ |
| `AlertDialog` | 4 | แสดง dialog ต่างๆ |

### 🏗️ โครงสร้าง Layout

```
WillPopScope
└── Scaffold
    └── Container (Gradient Background)
        └── SafeArea
            └── Column
                ├── Padding (Header)
                │   └── Row
                │       ├── IconButton (Back)
                │       ├── Icon + Text (Title)
                │       └── IconButton (Logout)
                └── Expanded
                    └── Container (White Curved Background)
                        └── SingleChildScrollView
                            └── Column
                                ├── Container (Profile Avatar Section)
                                │   └── Column
                                │       ├── Container (Avatar)
                                │       ├── Text (Name)
                                │       └── Text (Email)
                                ├── _buildInfoSection ("ข้อมูลส่วนตัว")
                                │   └── Column
                                │       ├── _buildInfoTile (ชื่อ-นามสกุล)
                                │       ├── _buildInfoTile (อีเมล)
                                │       └── _buildInfoTile (เบอร์โทรศัพท์)
                                ├── _buildInfoSection ("เกี่ยวกับแอป")
                                │   └── Column
                                │       ├── _buildInfoTile (เวอร์ชันแอป)
                                │       ├── _buildInfoTile (เกี่ยวกับ)
                                │       ├── _buildInfoTile (วิธีใช้งาน)
                                │       └── _buildInfoTile (นโยบาย)
                                └── ElevatedButton (ออกจากระบบ)
```

### 💻 วิธีสร้าง Layout

#### ขั้นที่ 1: สร้าง Profile Avatar Section
```dart
Container(
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        const Color(0xFF4285F4).withOpacity(0.1),
        const Color(0xFF8E24AA).withOpacity(0.1),
      ],
    ),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0xFF4285F4).withOpacity(0.3)),
  ),
  child: Column(
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4285F4), Color(0xFF8E24AA)],
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 60, color: Colors.white),
      ),
      const SizedBox(height: 16),
      Text(_userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text(_userEmail, style: TextStyle(fontSize: 16, color: Color(0xFF666666))),
    ],
  ),
)
```

#### ขั้นที่ 2: สร้าง _buildInfoSection
```dart
Widget _buildInfoSection({
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF4285F4)),
            ),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );
}
```

#### ขั้นที่ 3: สร้าง _buildInfoTile
```dart
Widget _buildInfoTile({
  required IconData icon,
  required String title,
  required String subtitle,
  VoidCallback? onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF666666)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    ),
  );
}
```

#### ขั้นที่ 4: สร้างปุ่ม Logout
```dart
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _logout,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFEA4335),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.logout, size: 20),
        SizedBox(width: 8),
        Text('ออกจากระบบ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    ),
  ),
)
```

### 🎯 จุดสำคัญ
- ใช้ `WillPopScope` เพื่อจัดการปุ่ม Back
- แสดง AlertDialog เพื่อยืนยันการ Logout
- มี Dialog สำหรับแสดงข้อมูลต่างๆ (About, Help, Privacy)
- ใช้ `showDialog` สำหรับแสดง popup ต่างๆ

---

## สรุป Widget ที่ใช้ทั้งหมด

### 📊 ตารางสรุป Widget

| Widget | ใช้ในหน้า | จุดประสงค์หลัก |
|--------|-----------|-----------------|
| `Scaffold` | ทุกหน้า | โครงสร้างหลักของหน้าจอ |
| `Container` | ทุกหน้า | สร้างกล่อง, พื้นหลัง, กำหนดสี/รูปแบบ |
| `SafeArea` | ทุกหน้า | ป้องกันการซ้อนทับกับ system UI |
| `Column` | ทุกหน้า | จัดเรียง widgets แนวตั้ง |
| `Row` | ทุกหน้า | จัดเรียง widgets แนวนอน |
| `Text` | ทุกหน้า | แสดงข้อความ |
| `Icon` | ทุกหน้า | แสดงไอคอน |
| `SizedBox` | ทุกหน้า | สร้างระยะห่าง |
| `Padding` | ทุกหน้า | เพิ่ม padding รอบ widget |
| `Expanded` | Home, Profile | ขยาย widget ให้เต็มพื้นที่ที่เหลือ |
| `SingleChildScrollView` | ทุกหน้า | ทำให้เนื้อหาเลื่อนได้ |
| `Form` | Login, Register, Calculators | จัดการฟอร์มและ validation |
| `TextFormField` | Login, Register, Home, Calculators | ช่องกรอกข้อมูล |
| `ElevatedButton` | ทุกหน้า | ปุ่มหลัก |
| `TextButton` | Login | ปุ่มรอง/ลิงก์ |
| `IconButton` | ทุกหน้า | ปุ่มไอคอน |
| `CircularProgressIndicator` | Login, Register | แสดงสถานะ loading |
| `AppBar` | Register | แถบด้านบน |
| `GridView.count` | Home | แสดงรายการแบบตาราง |
| `InkWell` | Home, Profile | ทำให้ widget กดได้พร้อม ripple effect |
| `GestureDetector` | Login | ตรวจจับการแตะ |
| `CircleAvatar` | Home, Profile | รูปโปรไฟล์ทรงกลม |
| `AlertDialog` | Profile | แสดง dialog |
| `WillPopScope` | Profile | จัดการปุ่ม Back |
| `AppIcon` | Home | ไอคอนแอป (Custom Widget) |
| `LoanTypeIcon` | Home | ไอคอนประเภทสินเชื่อ (Custom Widget) |

### 🎨 สีที่ใช้ในแอป

| สี | โค้ด | การใช้งาน |
|----|------|-----------|
| Google Blue | `#4285F4` | สีหลัก, ปุ่ม, gradient |
| Purple | `#8E24AA` | สีรอง, gradient |
| Orange | `#FF9800` | สินเชื่อบ้าน |
| Green | `#34A853` | สินเชื่อรถยนต์ |
| Red | `#EA4335` | ปุ่ม Logout, Error |
| Grey | `#666666`, `#999999` | ข้อความรอง, ไอคอน |

### 📐 ขนาดที่ใช้บ่อย

| Element | ขนาด | หน่วย |
|---------|------|-------|
| Padding ทั่วไป | 16, 24 | px |
| Border Radius | 10, 12, 16, 20, 24 | px |
| Icon ขนาดเล็ก | 18, 20, 24 | px |
| Icon ขนาดกลาง | 32, 40, 48 | px |
| Icon ขนาดใหญ่ | 60, 80 | px |
| Font Size หัวข้อหลัก | 24, 32 | px |
| Font Size หัวข้อรอง | 18, 20 | px |
| Font Size ปกติ | 14, 16 | px |
| Font Size เล็ก | 12 | px |

### 🔄 Pattern ที่ใช้บ่อย

#### 1. Gradient Background Pattern
```dart
Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF4285F4), Color(0xFF8E24AA)],
    ),
  ),
)
```

#### 2. White Curved Container Pattern
```dart
Container(
  decoration: const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
    ),
  ),
)
```

#### 3. Card Pattern
```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.grey.shade50,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade200),
  ),
  child: /* เนื้อหา */,
)
```

#### 4. Form Field Pattern
```dart
TextFormField(
  controller: _controller,
  decoration: InputDecoration(
    labelText: 'Label',
    hintText: 'Hint',
    prefixIcon: Icon(Icons.icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }
    return null;
  },
)
```

#### 5. Button Pattern
```dart
ElevatedButton(
  onPressed: _action,
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF4285F4),
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('ปุ่ม'),
)
```

---

## 💡 เคล็ดลับการใช้งาน

### 1. การจัดการ State
- ใช้ `StatefulWidget` เมื่อต้องการ state ที่เปลี่ยนแปลง
- ใช้ `setState()` เพื่ออัปเดต UI
- ตัวแปร state ที่ใช้บ่อย: `_isLoading`, `_showResults`, `_userName`

### 2. การ Navigate
```dart
// ไปหน้าใหม่
Navigator.push(context, MaterialPageRoute(builder: (context) => NewScreen()));

// แทนที่หน้าปัจจุบัน
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewScreen()));

// กลับหน้าก่อนหน้า
Navigator.pop(context);
```

### 3. การแสดง SnackBar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('ข้อความ'),
    backgroundColor: Colors.red,
  ),
);
```

### 4. การจัดการ Controller
- สร้าง Controller ใน `initState()`
- ต้อง `dispose()` Controller ใน `dispose()`
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### 5. การใช้ Custom Widgets
```dart
import 'package:loan_advisor/widgets/app_icons.dart';

// ใช้งาน
AppIcon(size: 32)
LoanTypeIcon(type: LoanType.house, size: 48)
```

---

## 📚 เอกสารเพิ่มเติม

- [LAYOUT_GUIDE.md](LAYOUT_GUIDE.md) - คู่มือ Layout และ Widget โดยละเอียด
- [lib/widgets/README.md](lib/widgets/README.md) - คู่มือ Custom Widgets
- [DESIGN.md](DESIGN.md) - Visual Design Guide
- [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md) - Clean Architecture
- [README.md](README.md) - ภาพรวมโปรเจค

---

**สร้างด้วย ❤️ สำหรับ Loan Advisor**
