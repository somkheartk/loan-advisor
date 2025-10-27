# 📐 คู่มือการวาง Layout และการเลือก Component/Widget

## 📋 สารบัญ
- [ภาพรวม](#ภาพรวม)
- [โครงสร้าง Layout พื้นฐาน](#โครงสร้าง-layout-พื้นฐาน)
- [การเลือก Widget/Component](#การเลือก-widgetcomponent)
- [รูปแบบ Layout ในแอป](#รูปแบบ-layout-ในแอป)
- [ตัวอย่างการวาง Layout](#ตัวอย่างการวาง-layout)
- [Best Practices](#best-practices)

---

## ภาพรวม

เอกสารนี้อธิบายวิธีการวาง Layout และการเลือกใช้ Component/Widget ใน Flutter สำหรับแอป Loan Advisor โดยแบ่งเป็นส่วนๆ ตามประเภทของหน้าจอและการใช้งาน

### หลักการออกแบบ Layout
- ✅ **ความเรียบง่าย (Simplicity)**: Layout ที่เข้าใจง่าย ไม่ซับซ้อน
- ✅ **ความสม่ำเสมอ (Consistency)**: ใช้รูปแบบเดียวกันทั่วทั้งแอป
- ✅ **การตอบสนอง (Responsiveness)**: รองรับหน้าจอหลากหลายขนาด
- ✅ **การเข้าถึง (Accessibility)**: ออกแบบให้ใช้งานง่ายสำหรับทุกคน

---

## โครงสร้าง Layout พื้นฐาน

### 1. Layout หลักของแอป (Main Layout Structure)

ทุกหน้าจอในแอปใช้โครงสร้างพื้นฐานนี้:

```
┌─────────────────────────────────────┐
│   SafeArea (ป้องกันการซ้อนทับ)     │
│ ┌─────────────────────────────────┐ │
│ │   Container (พื้นหลัง Gradient) │ │
│ │ ┌─────────────────────────────┐ │ │
│ │ │   Column (แนวตั้ง)          │ │ │
│ │ │                             │ │ │
│ │ │   [Header Area]             │ │ │
│ │ │                             │ │ │
│ │ │   [Expanded Content]        │ │ │
│ │ │   (ScrollView)              │ │ │
│ │ │                             │ │ │
│ │ └─────────────────────────────┘ │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### 2. Widget Hierarchy (ลำดับชั้นของ Widget)

```dart
Scaffold                              // โครงสร้างหลัก
└── Container (Gradient Background)   // พื้นหลังไล่สี
    └── SafeArea                      // พื้นที่ปลอดภัย
        └── Column                    // จัดเรียงแนวตั้ง
            ├── Header Widget         // ส่วนหัว (Fixed)
            └── Expanded              // พื้นที่เนื้อหา (ขยายเต็ม)
                └── Container         // พื้นหลังสีขาว + มุมมน
                    └── SingleChildScrollView  // เลื่อนได้
                        └── Content Widgets    // เนื้อหาจริง
```

---

## การเลือก Widget/Component

### 1. Layout Widgets (Widget สำหรับจัดวาง)

#### **Column** - จัดเรียงแนวตั้ง
```dart
// ใช้เมื่อ: ต้องการวาง Widget เรียงกันในแนวตั้ง
Column(
  crossAxisAlignment: CrossAxisAlignment.start, // จัดชิดซ้าย
  children: [
    Text('หัวข้อ'),
    TextField(),
    ElevatedButton(),
  ],
)
```

**ใช้ใน:**
- การจัดวาง Form fields แนวตั้ง
- รายการข้อมูลแนวตั้ง
- หน้าจอที่มีหลายส่วน

#### **Row** - จัดเรียงแนวนอน
```dart
// ใช้เมื่อ: ต้องการวาง Widget เรียงกันในแนวนอน
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // กระจายระยะ
  children: [
    Icon(Icons.home),
    Text('หน้าแรก'),
    Icon(Icons.arrow_forward),
  ],
)
```

**ใช้ใน:**
- Header พร้อมไอคอนและข้อความ
- ปุ่มหลายปุ่มในแนวนอน
- ข้อมูลที่แสดงคู่กัน (Label และ Value)

#### **Expanded** - ขยายเต็มพื้นที่
```dart
// ใช้เมื่อ: ต้องการให้ Widget ขยายเต็มพื้นที่ที่เหลือ
Row(
  children: [
    Icon(Icons.person),
    SizedBox(width: 8),
    Expanded(                    // ขยายเต็มพื้นที่
      child: Text('ข้อความยาว...'),
    ),
    Icon(Icons.arrow_forward),
  ],
)
```

**ใช้ใน:**
- เนื้อหาหลักที่ต้องการเต็มหน้าจอ
- Text ที่อาจยาวและต้องการพื้นที่ยืดหยุ่น

#### **Container** - กล่องที่ปรับแต่งได้
```dart
// ใช้เมื่อ: ต้องการกล่องที่กำหนด padding, margin, สี, เงา
Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(...)],
  ),
  child: Text('เนื้อหา'),
)
```

**ใช้ใน:**
- Card หรือกล่องที่มีพื้นหลัง
- พื้นที่ที่ต้องการ spacing
- Widget ที่ต้องการตกแต่ง

#### **SingleChildScrollView** - เลื่อนดูได้
```dart
// ใช้เมื่อ: เนื้อหาอาจยาวเกินหน้าจอ
SingleChildScrollView(
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      // เนื้อหาที่อาจยาวมาก
    ],
  ),
)
```

**ใช้ใน:**
- Form ที่มีหลาย fields
- หน้าจอที่แสดงผลลัพธ์ยาว
- เนื้อหาที่ไม่แน่นอนความยาว

#### **GridView** - ตารางแบบ Grid
```dart
// ใช้เมื่อ: ต้องการแสดงรายการในรูปแบบตาราง
GridView.count(
  crossAxisCount: 2,        // 2 คอลัมน์
  crossAxisSpacing: 10,     // ระยะห่างแนวนอน
  mainAxisSpacing: 10,      // ระยะห่างแนวตั้ง
  childAspectRatio: 1.2,    // อัตราส่วนกว้าง:สูง
  children: [
    Card(...),
    Card(...),
  ],
)
```

**ใช้ใน:**
- หน้าแรก (แสดงประเภทสินเชื่อ 2x2)
- Gallery หรือรายการที่แสดงเป็นตาราง

### 2. Input Widgets (Widget สำหรับรับข้อมูล)

#### **TextFormField** - ช่องกรอกข้อมูล
```dart
// ใช้เมื่อ: ต้องการรับข้อมูลจากผู้ใช้พร้อม Validation
TextFormField(
  controller: _controller,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'จำนวนเงินกู้',
    hintText: 'กรุณากรอกจำนวนเงิน',
    suffixText: 'บาท',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }
    return null;
  },
)
```

**ใช้ใน:**
- Form login/register
- Calculator inputs
- ช่องกรอกข้อมูลทุกประเภท

**ประเภท Keyboard:**
- `TextInputType.number` - ตัวเลขอย่างเดียว
- `TextInputType.numberWithOptions(decimal: true)` - ทศนิยม
- `TextInputType.emailAddress` - อีเมล
- `TextInputType.text` - ข้อความทั่วไป

### 3. Display Widgets (Widget สำหรับแสดงผล)

#### **Text** - แสดงข้อความ
```dart
// ใช้เมื่อ: ต้องการแสดงข้อความ
Text(
  'หัวข้อ',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
)
```

**ประเภทการใช้งาน:**
- **หัวข้อหลัก**: `fontSize: 24, fontWeight: FontWeight.bold`
- **หัวข้อรอง**: `fontSize: 18, fontWeight: FontWeight.w600`
- **เนื้อหา**: `fontSize: 16, fontWeight: FontWeight.normal`
- **รายละเอียด**: `fontSize: 14, color: Colors.grey`

#### **Card** - กล่องเนื้อหา
```dart
// ใช้เมื่อ: ต้องการกล่องที่มี elevation และเงา
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(...),
  ),
)
```

**ใช้ใน:**
- แสดงข้อมูลผู้ใช้
- แสดงผลการคำนวณ
- รายการที่คลิกได้

#### **ListTile** - รายการมาตรฐาน
```dart
// ใช้เมื่อ: ต้องการรายการแบบมาตรฐาน (leading, title, subtitle, trailing)
ListTile(
  leading: Icon(Icons.home),
  title: Text('สินเชื่อบ้าน'),
  subtitle: Text('คำนวณยอดผ่อนรายเดือน'),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () { },
)
```

**ใช้ใน:**
- เมนูการตั้งค่า
- รายการที่มีไอคอน
- การนำทาง

### 4. Action Widgets (Widget สำหรับปุ่มและการกระทำ)

#### **ElevatedButton** - ปุ่มหลัก
```dart
// ใช้เมื่อ: ปุ่ม Call-to-Action หลัก
ElevatedButton(
  onPressed: () { },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF4285F4),
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Text('คำนวณ'),
)
```

**ใช้ใน:**
- ปุ่มหลักในแต่ละหน้า (คำนวณ, เข้าสู่ระบบ)
- Call-to-Action สำคัญ

#### **TextButton** - ปุ่มรอง
```dart
// ใช้เมื่อ: ปุ่มรองหรือลิงก์
TextButton(
  onPressed: () { },
  child: Text('ยังไม่มีบัญชี? สมัครสมาชิก'),
)
```

**ใช้ใน:**
- ลิงก์ไปหน้าอื่น
- ปุ่มที่ไม่ใช่ action หลัก

#### **IconButton** - ปุ่มไอคอน
```dart
// ใช้เมื่อ: ปุ่มที่เป็นไอคอนเพียงอย่างเดียว
IconButton(
  icon: Icon(Icons.arrow_back),
  onPressed: () { Navigator.pop(context); },
)
```

**ใช้ใน:**
- ปุ่มย้อนกลับ
- ปุ่มบน AppBar
- ไอคอนที่คลิกได้

### 5. Navigation Widgets

#### **InkWell** - คลิกได้พร้อม Ripple Effect
```dart
// ใช้เมื่อ: ต้องการ Widget ที่คลิกได้พร้อมเอฟเฟกต์
InkWell(
  onTap: () { },
  borderRadius: BorderRadius.circular(12),
  child: Container(...),
)
```

**ใช้ใน:**
- Card ที่คลิกได้
- พื้นที่ขนาดใหญ่ที่ต้องการให้คลิกได้

#### **GestureDetector** - จัดการ Gesture
```dart
// ใช้เมื่อ: ต้องการจัดการ gesture แบบละเอียด
GestureDetector(
  onTap: () { },
  onDoubleTap: () { },
  onLongPress: () { },
  child: Container(...),
)
```

**ใช้ใน:**
- การจัดการ gesture ที่ซับซ้อน
- ไม่ต้องการ Material ripple effect

---

## รูปแบบ Layout ในแอป

### 1. หน้า Login/Register (Center Layout)

```dart
Scaffold(
  body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF4285F4), Color(0xFF8E24AA)],
      ),
    ),
    child: SafeArea(
      child: Center(                    // จัดกึ่งกลางทั้งหมด
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              // Form Card
              // Buttons
            ],
          ),
        ),
      ),
    ),
  ),
)
```

**โครงสร้าง:**
```
┌─────────────────────────────────────┐
│     Gradient Background             │
│                                     │
│         ┌─────────────┐             │
│         │    Logo     │             │
│         └─────────────┘             │
│                                     │
│         "App Title"                 │
│         "Subtitle"                  │
│                                     │
│   ┌───────────────────────────┐    │
│   │      Form Card            │    │
│   │  ┌─────────────────────┐  │    │
│   │  │  Email Field        │  │    │
│   │  └─────────────────────┘  │    │
│   │  ┌─────────────────────┐  │    │
│   │  │  Password Field     │  │    │
│   │  └─────────────────────┘  │    │
│   │  ┌─────────────────────┐  │    │
│   │  │    Login Button     │  │    │
│   │  └─────────────────────┘  │    │
│   └───────────────────────────┘    │
│                                     │
│      "Register Link"                │
└─────────────────────────────────────┘
```

**เมื่อไหร่ใช้:**
- หน้า Authentication (Login, Register)
- หน้า Onboarding
- หน้าที่ต้องการ focus ที่เนื้อหาตรงกลาง

### 2. หน้าหลัก (Header + Scrollable Content)

```dart
Scaffold(
  body: Container(
    decoration: BoxDecoration(gradient: ...),
    child: SafeArea(
      child: Column(
        children: [
          // Fixed Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Logo, Title
                // Profile Button
              ],
            ),
          ),
          
          // Scrollable Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // User Info Card
                    // Calculator Grid
                    // Quick Calculator Form
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
)
```

**โครงสร้าง:**
```
┌─────────────────────────────────────┐
│  🎨 Gradient Header (Fixed)         │
│  Logo | Title      Profile 👤       │
├─────────────────────────────────────┤
│ ╭───────────────────────────────╮  │
│ │  White Content Area (Curved)  │  │
│ │  ┏━━━━━━━━━━━━━━━━━━━━━━━━┓  │  │
│ │  ┃  User Info Card        ┃  │  │
│ │  ┗━━━━━━━━━━━━━━━━━━━━━━━━┛  │  │
│ │                               │  │
│ │  ┌──────────┐  ┌──────────┐  │  │
│ │  │  บ้าน   │  │  รถยนต์  │  │  │ ScrollView
│ │  │  🏠      │  │  🚗      │  │  │
│ │  └──────────┘  └──────────┘  │  │
│ │  ┌──────────┐  ┌──────────┐  │  │
│ │  │  บุคคล  │  │  อื่นๆ   │  │  │
│ │  │  💰      │  │  🏦      │  │  │
│ │  └──────────┘  └──────────┘  │  │
│ │                               │  │
│ │  Quick Calculator Form        │  │
│ │  ┌─────────────────────────┐  │  │
│ │  │  Input Fields           │  │  │
│ │  └─────────────────────────┘  │  │
│ ╰───────────────────────────────╯  │
└─────────────────────────────────────┘
```

**เมื่อไหร่ใช้:**
- หน้าหลักของแอป
- Dashboard
- หน้าที่มีหลาย sections

### 3. หน้า Calculator (Header + Form + Results)

```dart
Scaffold(
  body: Container(
    decoration: BoxDecoration(gradient: ...),
    child: SafeArea(
      child: Column(
        children: [
          // Fixed Header with Back Button
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back)),
                Column(
                  children: [
                    Text('หัวข้อ'),
                    Text('คำอธิบาย'),
                  ],
                ),
              ],
            ),
          ),
          
          // Form + Results
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    children: [
                      // Icon + Title
                      // Input Fields
                      // Calculate Button
                      // Results Card (conditional)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
)
```

**โครงสร้าง:**
```
┌─────────────────────────────────────┐
│  ← Back | Title                     │
│           Subtitle                  │
├─────────────────────────────────────┤
│ ╭───────────────────────────────╮  │
│ │     🏠 สินเชื่อบ้าน           │  │
│ │                               │  │
│ │  ┌─────────────────────────┐  │  │
│ │  │ จำนวนเงินกู้ (บาท)      │  │  │
│ │  │ [____________] บาท      │  │  │ ScrollView
│ │  └─────────────────────────┘  │  │
│ │  ┌─────────────────────────┐  │  │
│ │  │ อัตราดอกเบี้ย (%)       │  │  │
│ │  │ [____________] %        │  │  │
│ │  └─────────────────────────┘  │  │
│ │  ┌─────────────────────────┐  │  │
│ │  │ ระยะเวลา (ปี)           │  │  │
│ │  │ [____________] ปี       │  │  │
│ │  └─────────────────────────┘  │  │
│ │  ┌─────────────────────────┐  │  │
│ │  │      คำนวณ             │  │  │
│ │  └─────────────────────────┘  │  │
│ │                               │  │
│ │  ┏━━━━━━━━━━━━━━━━━━━━━━━┓  │  │
│ │  ┃ ผลการคำนวณ           ┃  │  │
│ │  ┃ ยอดผ่อนต่อเดือน      ┃  │  │
│ │  ┃    ฿15,228.00        ┃  │  │
│ │  ┗━━━━━━━━━━━━━━━━━━━━━━━┛  │  │
│ ╰───────────────────────────────╯  │
└─────────────────────────────────────┘
```

**เมื่อไหร่ใช้:**
- หน้า Calculator ทุกประเภท
- Form ที่มีผลลัพธ์
- หน้าที่มี Input และ Output

### 4. หน้า Profile (List Layout)

```dart
Scaffold(
  appBar: AppBar(title: Text('โปรไฟล์')),
  body: ListView(
    padding: EdgeInsets.all(16),
    children: [
      // User Info Card
      Card(
        child: ListTile(...),
      ),
      SizedBox(height: 16),
      
      // Menu Items
      ListTile(...),
      Divider(),
      ListTile(...),
      Divider(),
      
      // Logout Button
      ElevatedButton(...),
    ],
  ),
)
```

**โครงสร้าง:**
```
┌─────────────────────────────────────┐
│ ← โปรไฟล์                          │
├─────────────────────────────────────┤
│  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   │
│  ┃ 👤  ชื่อผู้ใช้              ┃   │
│  ┃     email@example.com      ┃   │
│  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   │
│                                     │
│  📧  อีเมล                    →    │
│  ─────────────────────────────     │
│  🔒  เปลี่ยนรหัสผ่าน          →    │
│  ─────────────────────────────     │
│  ℹ️   เกี่ยวกับแอป             →    │
│  ─────────────────────────────     │
│                                     │
│  ┌───────────────────────────┐     │
│  │      ออกจากระบบ          │     │
│  └───────────────────────────┘     │
└─────────────────────────────────────┘
```

**เมื่อไหร่ใช้:**
- หน้า Settings
- หน้า Profile
- รายการเมนู

---

## ตัวอย่างการวาง Layout

### ตัวอย่าง 1: Header แบบ Fixed พร้อมไอคอนและข้อความ

```dart
// ใช้สำหรับ: Header ด้านบนหน้าจอ
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // ซ้าย: Logo + Title
      Row(
        children: [
          AppIcon(
            size: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            iconColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loan Advisor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'คำนวณเงินกู้ง่ายๆ ในมือถือ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
      
      // ขวา: Profile Button
      IconButton(
        icon: Icon(Icons.person, color: Colors.white),
        onPressed: () { /* Navigate to Profile */ },
      ),
    ],
  ),
)
```

**เมื่อไหร่ใช้:**
- Header หน้าหลัก
- แสดง Logo, ชื่อแอป และปุ่ม Profile

### ตัวอย่าง 2: Card แสดงข้อมูลผู้ใช้

```dart
// ใช้สำหรับ: แสดงข้อมูลผู้ใช้แบบ Card
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.grey.shade50,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.shade200),
  ),
  child: Row(
    children: [
      // Avatar
      CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFF4285F4),
        child: Icon(Icons.person, color: Colors.white, size: 18),
      ),
      
      const SizedBox(width: 12),
      
      // ข้อมูลผู้ใช้
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'สมาชิกทั่วไป',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      
      // ปุ่มดูโปรไฟล์
      IconButton(
        icon: Icon(Icons.arrow_forward_ios, size: 14),
        onPressed: () { /* Navigate */ },
      ),
    ],
  ),
)
```

**เมื่อไหร่ใช้:**
- แสดงข้อมูลผู้ใช้บนหน้าหลัก
- Card ที่มี Avatar, ข้อมูล และปุ่ม

### ตัวอย่าง 3: Grid Calculator Cards

```dart
// ใช้สำหรับ: แสดงรายการเครื่องคิดเลขในรูปแบบ Grid
GridView.count(
  shrinkWrap: true,                      // ไม่ขยายเกินเนื้อหา
  physics: NeverScrollableScrollPhysics(), // ไม่ scroll แยก
  crossAxisCount: 2,                     // 2 คอลัมน์
  crossAxisSpacing: 10,                  // ระยะห่างแนวนอน
  mainAxisSpacing: 10,                   // ระยะห่างแนวตั้ง
  childAspectRatio: 1.2,                 // อัตราส่วน กว้าง:สูง
  children: [
    _buildCalculatorCard(
      title: 'บ้าน',
      icon: LoanTypeIcon(type: LoanType.house),
      color: Color(0xFF4285F4),
      onTap: () { /* Navigate */ },
    ),
    _buildCalculatorCard(
      title: 'รถยนต์',
      icon: LoanTypeIcon(type: LoanType.car),
      color: Color(0xFF34A853),
      onTap: () { /* Navigate */ },
    ),
    // ...
  ],
)

Widget _buildCalculatorCard({
  required String title,
  required Widget icon,
  required Color color,
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
          Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}
```

**เมื่อไหร่ใช้:**
- แสดงตัวเลือกหลายอย่างในรูปแบบ Grid
- การ์ดที่คลิกได้เพื่อนำทาง

### ตัวอย่าง 4: Form Input Fields

```dart
// ใช้สำหรับ: Form กรอกข้อมูล Calculator
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'จำนวนเงินกู้',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    
    SizedBox(height: 10),
    
    // ช่องกรอกอื่นๆ...
  ],
)
```

**เมื่อไหร่ใช้:**
- Form ทุกประเภท
- Input fields พร้อม Label และ Validation

### ตัวอย่าง 5: Results Display Card

```dart
// ใช้สำหรับ: แสดงผลการคำนวณ
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Color(0xFF4285F4).withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Color(0xFF4285F4).withOpacity(0.3),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'ผลการคำนวณ',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      
      _buildResultRow('ยอดผ่อนต่อเดือน', '฿15,228.00'),
      SizedBox(height: 6),
      _buildResultRow('ยอดรวมที่ต้องจ่าย', '฿5,482,080.00'),
      SizedBox(height: 6),
      _buildResultRow('ดอกเบี้ยรวม', '฿2,482,080.00'),
    ],
  ),
)

Widget _buildResultRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 14)),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
```

**เมื่อไหร่ใช้:**
- แสดงผลการคำนวณ
- แสดงข้อมูลแบบ Label: Value

### ตัวอย่าง 6: Button Group

```dart
// ใช้สำหรับ: กลุ่มปุ่ม (Calculate + Clear)
Column(
  children: [
    // Calculate Button
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _calculateLoan,
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    
    // Clear Button (แสดงเมื่อมีผลลัพธ์)
    if (_showResults) ...[
      SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _clearFields,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.clear, size: 16),
              SizedBox(width: 6),
              Text('เคลียร์ข้อมูล'),
            ],
          ),
        ),
      ),
    ],
  ],
)
```

**เมื่อไหร่ใช้:**
- กลุ่มปุ่มที่เกี่ยวข้องกัน
- ปุ่มหลักและปุ่มรอง

---

## Best Practices

### 1. การใช้ Padding และ Margin

```dart
// ✅ ดี: ใช้ EdgeInsets สม่ำเสมอ
padding: EdgeInsets.all(16)              // ทุกด้านเท่ากัน
padding: EdgeInsets.symmetric(
  horizontal: 16,                        // ซ้าย-ขวา
  vertical: 12,                          // บน-ล่าง
)
padding: EdgeInsets.fromLTRB(20, 24, 20, 0)  // ละเอียด

// ❌ ไม่ดี: ค่าที่ไม่สม่ำเสมอ
padding: EdgeInsets.all(13)
padding: EdgeInsets.fromLTRB(17, 23, 19, 5)
```

**แนวทาง:**
- ใช้เท่ากับ `4, 8, 12, 16, 20, 24, 32` (หารด้วย 4 ลงตัว)
- Padding ภายใน: `12-16`
- Margin ระหว่าง Widget: `8-16`
- Padding ด้านนอก screen: `16-24`

### 2. การเลือก Widget ที่เหมาะสม

```dart
// ✅ ดี: ใช้ SingleChildScrollView กับ Column
SingleChildScrollView(
  child: Column(children: [...]),
)

// ❌ ไม่ดี: ใช้ ListView กับ children น้อย
ListView(
  children: [Widget1(), Widget2()],  // ควรใช้ Column แทน
)

// ✅ ดี: ใช้ Expanded ใน Row/Column
Row(
  children: [
    Icon(Icons.star),
    Expanded(child: Text('ข้อความยาว...')),
    Icon(Icons.arrow_forward),
  ],
)

// ❌ ไม่ดี: ไม่ใช้ Expanded
Row(
  children: [
    Icon(Icons.star),
    Text('ข้อความยาวมาก...'),  // อาจล้น
    Icon(Icons.arrow_forward),
  ],
)
```

### 3. การตั้งชื่อและจัดกลุ่ม Widget

```dart
// ✅ ดี: แยก Widget เป็น method
Widget _buildUserInfoCard() {
  return Container(...);
}

Widget _buildCalculatorButton({
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(...);
}

// ❌ ไม่ดี: Code ยาวเกินไปใน build method
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Container(
          // 50 บรรทัดของ Widget Tree
        ),
        Container(
          // อีก 50 บรรทัด
        ),
      ],
    ),
  );
}
```

### 4. Responsive Design

```dart
// ✅ ดี: ใช้ MediaQuery สำหรับขนาดที่ต้องการ dynamic
final screenWidth = MediaQuery.of(context).size.width;
final iconSize = screenWidth * 0.15;  // 15% ของความกว้าง

// ใช้ LayoutBuilder สำหรับ responsive layout
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return _buildWideLayout();
    } else {
      return _buildNarrowLayout();
    }
  },
)
```

### 5. การจัดการสี

```dart
// ✅ ดี: กำหนดสีเป็น constant
class AppColors {
  static const primary = Color(0xFF4285F4);
  static const secondary = Color(0xFF34A853);
  static const error = Color(0xFFEA4335);
  static const warning = Color(0xFFFBBC04);
}

// ใช้งาน
backgroundColor: AppColors.primary

// ❌ ไม่ดี: Hard-code สีทุกที่
backgroundColor: Color(0xFF4285F4)
backgroundColor: Colors.blue[500]
```

### 6. Form Validation

```dart
// ✅ ดี: ใช้ Form + GlobalKey
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          return null;
        },
      ),
    ],
  ),
)

// Validate
if (_formKey.currentState!.validate()) {
  // Process form
}
```

### 7. Navigation

```dart
// ✅ ดี: ใช้ named routes หรือ MaterialPageRoute
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => TargetScreen(),
  ),
)

// Pop กลับ
Navigator.of(context).pop()

// Pop กลับพร้อมข้อมูล
Navigator.of(context).pop(result)

// Replace
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (context) => NewScreen()),
)
```

### 8. State Management

```dart
// ✅ ดี: ใช้ StatefulWidget สำหรับ local state
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _isLoading = false;
  
  void _updateState() {
    setState(() {
      _isLoading = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return _isLoading 
      ? CircularProgressIndicator()
      : Text('Ready');
  }
}
```

---

## สรุป

### เลือก Layout ตามหน้าที่:
1. **Center Layout**: Login, Register, Onboarding
2. **Header + Scrollable**: Home, Dashboard
3. **Form Layout**: Calculators, Input screens
4. **List Layout**: Settings, Profile, Menu

### เลือก Widget ตามวัตถุประสงค์:
1. **Layout**: Column, Row, Expanded, Container
2. **Scroll**: SingleChildScrollView, ListView, GridView
3. **Input**: TextFormField, Form
4. **Display**: Text, Card, ListTile
5. **Action**: ElevatedButton, TextButton, IconButton, InkWell

### หลักการสำคัญ:
- ✅ ใช้ SafeArea เสมอ
- ✅ จัดกลุ่ม Widget ที่เกี่ยวข้อง
- ✅ ใช้ const constructor เมื่อเป็นไปได้
- ✅ แยก Widget ที่ซับซ้อนเป็น method หรือ class แยก
- ✅ ใช้ค่า Padding/Margin ที่สม่ำเสมอ
- ✅ จัดการ Overflow ด้วย Expanded หรือ Flexible
- ✅ ทดสอบบนหน้าจอขนาดต่างๆ

---

## เอกสารเพิ่มเติม

- [README.md](README.md) - ภาพรวมโปรเจค
- [DESIGN.md](DESIGN.md) - Visual Design Guide
- [lib/widgets/README.md](lib/widgets/README.md) - คู่มือ Custom Widgets
- [FOLDER_STRUCTURE.md](FOLDER_STRUCTURE.md) - โครงสร้างโปรเจค
- [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md) - Clean Architecture

---

**สร้างด้วย ❤️ สำหรับ Loan Advisor**
