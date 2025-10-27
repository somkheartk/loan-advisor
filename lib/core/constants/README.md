# 📐 Constants - ค่าคงที่ของแอปพลิเคชัน

โฟลเดอร์นี้เก็บค่าคงที่ทั้งหมดที่ใช้ในแอปพลิเคชัน เพื่อให้การจัดการและปรับแต่งค่าต่างๆ เป็นไปอย่างเป็นระบบและเป็นมาตรฐาน

## 📁 โครงสร้างไฟล์

### 🎨 `app_colors.dart`
เก็บค่าสีทั้งหมดที่ใช้ในแอป
- สีหลัก (Primary, Primary Dark, Primary Light)
- สีพื้นหลังและ Surface
- สีข้อความ (Primary, Secondary, Hint)
- สีประเภทสินเชื่อ (บ้าน, รถยนต์, บุคคล, อื่นๆ)
- สีสถานะ (Success, Error, Warning, Info)
- สีเส้นขอบและตัวแบ่ง

```dart
// ตัวอย่างการใช้งาน
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)
```

### ✍️ `app_text_styles.dart`
เก็บสไตล์ข้อความที่ใช้ในแอป
- Headings (H1, H2, H3)
- Body Text (Large, Medium, Small)
- Labels (Large, Medium, Small)
- Button Text
- Caption
- Title & Subtitle
- Currency Display
- Error Text

```dart
// ตัวอย่างการใช้งาน
Text(
  'หัวข้อหลัก',
  style: AppTextStyles.heading1,
)
```

### 📏 `app_dimensions.dart`
เก็บค่าขนาดและระยะห่างที่ใช้ในแอป
- Spacing (XS, S, M, L, XL, XXL, XXXL)
- Padding (EdgeInsets ต่างๆ)
- Border Radius (S, M, L, XL, XXL)
- Icon Sizes
- Button Heights
- Input Field Heights
- Card Elevation
- Grid Spacing

```dart
// ตัวอย่างการใช้งาน
Container(
  padding: AppDimensions.paddingAll,
  decoration: BoxDecoration(
    borderRadius: AppDimensions.borderRadiusL,
  ),
)
```

### 📝 `app_strings.dart`
เก็บข้อความทั้งหมดที่ใช้ในแอป
- ชื่อแอป
- ข้อความ Authentication
- ชื่อประเภทสินเชื่อ
- ข้อความในเครื่องคำนวณ
- ข้อความผลลัพธ์
- หน่วยต่างๆ
- ข้อความแสดงข้อผิดพลาด
- คำแนะนำ (Hints)

```dart
// ตัวอย่างการใช้งาน
Text(AppStrings.appName)
TextField(
  decoration: InputDecoration(
    labelText: AppStrings.email,
    hintText: AppStrings.hintEmail,
  ),
)
```

### ⚙️ `app_constants.dart`
เก็บค่าคงที่ทั่วไปและ configuration
- ข้อมูลแอป (Version, Build)
- ขีดจำกัดการตรวจสอบข้อมูล
- ขีดจำกัดการคำนวณสินเชื่อ
- ระยะเวลา Animation
- รูปแบบวันที่และเวลา
- รูปแบบตัวเลข
- SharedPreferences Keys
- ค่าคงที่สำหรับการคำนวณ

```dart
// ตัวอย่างการใช้งาน
if (password.length < AppConstants.minPasswordLength) {
  // แสดงข้อผิดพลาด
}
```

### 📦 `constants.dart`
ไฟล์รวม exports ทั้งหมด สำหรับ import ได้จากที่เดียว

```dart
// Import ทุกอย่างพร้อมกัน
import 'package:loan_advisor/core/constants/constants.dart';

// ใช้งานได้เลย
color: AppColors.primary,
style: AppTextStyles.heading1,
padding: AppDimensions.paddingAll,
Text(AppStrings.appName),
maxLength: AppConstants.maxPasswordLength,
```

## 🎯 ประโยชน์ของการใช้ Constants

### 1. **🎨 ความสม่ำเสมอ (Consistency)**
- UI มีความสม่ำเสมอทั่วทั้งแอป
- สี, ฟอนต์, ขนาดเหมือนกันทุกหน้า
- ลด bugs จากการใช้ค่าที่แตกต่างกัน

### 2. **🔧 ง่ายต่อการแก้ไข (Easy Maintenance)**
- แก้ไขค่าที่เดียว เปลี่ยนทั่วทั้งแอป
- ไม่ต้องค้นหาและแก้ทีละที่
- ลดความผิดพลาดจากการลืมแก้บางที่

### 3. **📱 รองรับ Theming**
- สามารถสร้าง Dark Mode ได้ง่าย
- เปลี่ยน Theme ทั้งแอปได้ทันที
- รองรับการปรับแต่งตามความต้องการผู้ใช้

### 4. **🌍 รองรับหลายภาษา (i18n ready)**
- แยกข้อความออกจาก code
- ง่ายต่อการแปลภาษา
- เตรียมพร้อมสำหรับ internationalization

### 5. **🧪 ง่ายต่อการทดสอบ**
- ค่าคงที่อยู่ในที่เดียว
- Unit test ได้ง่าย
- Mock ได้ง่าย

### 6. **👥 ทำงานเป็นทีมได้ดีขึ้น**
- ทุกคนใช้ค่าเดียวกัน
- ลดความสับสนในทีม
- Code review ง่ายขึ้น

## 📖 Best Practices

### ✅ ควรทำ (Do's)
- ใช้ constants แทนการใส่ค่าโดยตรง (hardcoded values)
- ตั้งชื่อที่สื่อความหมายชัดเจน
- จัดกลุ่มค่าที่เกี่ยวข้องกัน
- เขียนคำอธิบาย (comments) สำหรับค่าที่ซับซ้อน

```dart
// ✅ ดี - ใช้ constants
color: AppColors.primary

// ❌ ไม่ดี - hardcoded
color: Color(0xFF2196F3)
```

### ❌ ไม่ควรทำ (Don'ts)
- ไม่ควร hardcode ค่าในหลายๆ ที่
- ไม่ควรใช้ "magic numbers" โดยไม่มี context
- ไม่ควรซ้ำค่าเดียวกันหลายที่
- ไม่ควรตั้งชื่อที่กำกวมหรือไม่ชัดเจน

## 🔄 การอัพเดต Constants

เมื่อต้องการเพิ่มหรือแก้ไข constants:

1. **เลือกไฟล์ที่เหมาะสม**
   - สี → `app_colors.dart`
   - ข้อความ → `app_strings.dart`
   - ขนาด → `app_dimensions.dart`
   - ค่าทั่วไป → `app_constants.dart`

2. **เพิ่มค่าในคลาสที่เหมาะสม**
   ```dart
   static const Color newColor = Color(0xFF123456);
   ```

3. **เขียนคำอธิบาย (ถ้าจำเป็น)**
   ```dart
   // สีสำหรับปุ่มพิเศษในโปรโมชัน
   static const Color promotionButton = Color(0xFFFF5722);
   ```

4. **ทดสอบการใช้งาน**
   - ตรวจสอบว่าค่าใหม่ทำงานได้ถูกต้อง
   - ตรวจสอบว่าไม่กระทบส่วนอื่น

## 📚 เอกสารที่เกี่ยวข้อง

- [Clean Architecture](../../CLEAN_ARCHITECTURE.md)
- [Folder Structure](../../FOLDER_STRUCTURE.md)
- [Design Guide](../../DESIGN.md)
- [Widget Guide](../../widgets/README.md)

---

**หมายเหตุ**: Constants เหล่านี้เป็นส่วนสำคัญของ Design System ของแอป การใช้งานอย่างสม่ำเสมอจะช่วยให้แอปมีคุณภาพและง่ายต่อการดูแลรักษา
