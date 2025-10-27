# 🚀 คู่มือด่วน: Widget และ Layout

คู่มือฉบับย่อสำหรับการอ้างอิงอย่างรวดเร็ว

---

## 📱 สรุปหน้าจอทั้งหมด

| หน้า | Layout Type | Widgets หลัก | จำนวน Fields |
|------|-------------|--------------|--------------|
| Login | Center Layout | Form, TextFormField, ElevatedButton | 2 |
| Register | Form Layout | Form, TextFormField, ElevatedButton | 4 |
| Home | Header + Grid | GridView, AppIcon, LoanTypeIcon | - |
| House Loan | Form + Results | Form, TextFormField, Results Card | 3 |
| Car Loan | Form + Results | Form, TextFormField, Results Card | 4-5 |
| Personal Loan | Form + Results | Form, TextFormField, Results Card | 3 |
| Other Loan | Form + Results | Form, TextFormField, Results Card | 3 |
| Profile | Sections List | Container, InkWell, AlertDialog | - |

---

## 🎨 สีหลัก

```dart
Color(0xFF4285F4)  // Google Blue - สีหลัก
Color(0xFF8E24AA)  // Purple - สีรอง
Color(0xFFFF9800)  // Orange - สินเชื่อบ้าน
Color(0xFF34A853)  // Green - สินเชื่อรถยนต์
Color(0xFFEA4335)  // Red - Logout, Error
```

---

## 📐 ขนาดมาตรฐาน

```dart
// Padding
EdgeInsets.all(16)          // ทั่วไป
EdgeInsets.all(24)          // หน้าจอ

// Border Radius
BorderRadius.circular(10)    // ปุ่ม, ช่องกรอก
BorderRadius.circular(12)    // การ์ด
BorderRadius.circular(24)    // Container ใหญ่

// Font Size
24-32  // หัวข้อหลัก
18-20  // หัวข้อรอง
16     // ข้อความปกติ
14     // รายละเอียด
12     // ข้อความเล็ก
```

---

## 🔧 Pattern ที่ใช้บ่อย

### 1. Gradient Background
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF4285F4), Color(0xFF8E24AA)],
    ),
  ),
)
```

### 2. White Curved Container
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
    ),
  ),
)
```

### 3. Form Field
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Label',
    prefixIcon: Icon(Icons.icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
  ),
)
```

### 4. Primary Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF4285F4),
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('ปุ่ม'),
)
```

---

## 🏗️ Layout Templates

### Center Layout (Login, Register)
```
Scaffold
└── Container (Gradient)
    └── SafeArea
        └── Center
            └── SingleChildScrollView
                └── Column (เนื้อหา)
```

### Header + Content (Home, Calculators)
```
Scaffold
└── Container (Gradient)
    └── SafeArea
        └── Column
            ├── Padding (Header - Fixed)
            └── Expanded (Content - Scrollable)
                └── Container (White Curved)
                    └── SingleChildScrollView
```

### Sections List (Profile)
```
Scaffold
└── Container (Gradient)
    └── SafeArea
        └── Column
            ├── Padding (Header)
            └── Expanded
                └── Container (White)
                    └── SingleChildScrollView
                        └── Column (Sections)
```

---

## 📦 Widget Checklist

### Layout Widgets
- [ ] `Scaffold` - โครงสร้างหลัก
- [ ] `Container` - กล่อง/พื้นหลัง
- [ ] `SafeArea` - ป้องกันซ้อนทับ
- [ ] `Column` - จัดแนวตั้ง
- [ ] `Row` - จัดแนวนอน
- [ ] `Expanded` - ขยายเต็มพื้นที่
- [ ] `Padding` - เพิ่มระยะห่าง
- [ ] `SizedBox` - ช่องว่าง

### Scrolling
- [ ] `SingleChildScrollView` - เลื่อนได้
- [ ] `ListView` - รายการเลื่อนได้
- [ ] `GridView` - ตารางเลื่อนได้

### Input
- [ ] `Form` - ฟอร์ม
- [ ] `TextFormField` - ช่องกรอกข้อมูล
- [ ] `GlobalKey<FormState>` - จัดการฟอร์ม
- [ ] `TextEditingController` - ควบคุมข้อความ

### Buttons
- [ ] `ElevatedButton` - ปุ่มหลัก
- [ ] `TextButton` - ปุ่มรอง
- [ ] `IconButton` - ปุ่มไอคอน
- [ ] `InkWell` - พื้นที่กดได้

### Display
- [ ] `Text` - ข้อความ
- [ ] `Icon` - ไอคอน
- [ ] `CircleAvatar` - รูปโปรไฟล์
- [ ] `Card` - การ์ด

### Feedback
- [ ] `CircularProgressIndicator` - Loading
- [ ] `SnackBar` - แจ้งเตือน
- [ ] `AlertDialog` - Dialog

### Custom Widgets
- [ ] `AppIcon` - ไอคอนแอป
- [ ] `LoanTypeIcon` - ไอคอนประเภทสินเชื่อ

---

## 🎯 Common Tasks

### Navigate to new screen
```dart
Navigator.push(context, 
  MaterialPageRoute(builder: (context) => NewScreen())
);
```

### Replace current screen
```dart
Navigator.pushReplacement(context,
  MaterialPageRoute(builder: (context) => NewScreen())
);
```

### Go back
```dart
Navigator.pop(context);
```

### Show SnackBar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
);
```

### Validate Form
```dart
if (_formKey.currentState!.validate()) {
  // Form is valid
}
```

### Update UI
```dart
setState(() {
  _variable = newValue;
});
```

---

## 📚 ดูเพิ่มเติม

- [WIDGETS_AND_LAYOUTS.md](WIDGETS_AND_LAYOUTS.md) - คู่มือฉบับเต็ม
- [LAYOUT_GUIDE.md](LAYOUT_GUIDE.md) - คู่มือ Layout โดยละเอียด
- [lib/widgets/README.md](lib/widgets/README.md) - Custom Widgets

---

**อัพเดทล่าสุด: October 2025**
