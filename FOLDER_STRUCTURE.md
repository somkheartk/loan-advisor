# 📁 Loan Advisor - โครงสร้างไฟล์

## 🎯 การจัดระเบียบโครงสร้างไฟล์

แอปพลิเคชันใช้ Clean Architecture เพื่อแยกความรับผิดชอบอย่างชัดเจน โดยแบ่งโครงสร้างออกเป็น 3 layers หลัก และจัดระเบียบ UI screens เป็น folders ตามหมวดหมู่

### 📂 โครงสร้างไฟล์:

```
lib/
├── main.dart                          # จุดเริ่มต้นของแอป
│
├── 🎯 core/                           # Core Layer (ค่าคงที่และ Utilities)
│   └── constants/                     # ค่าคงที่ทั้งหมดของแอป
│       ├── app_colors.dart            # สีมาตรฐาน (Primary, Loan Types, Status)
│       ├── app_text_styles.dart       # สไตล์ข้อความ (Headings, Body, Labels)
│       ├── app_dimensions.dart        # ขนาดและระยะห่าง (Spacing, Padding, Radius)
│       ├── app_strings.dart           # ข้อความและ Labels (Thai language strings)
│       ├── app_constants.dart         # ค่าคงที่ทั่วไป (Limits, Formats, Keys)
│       ├── constants.dart             # Export file สำหรับ import ทั้งหมด
│       └── README.md                  # คู่มือการใช้งาน constants
│
├── 🏛️ domain/                        # Domain Layer (Business Logic - Pure Dart)
│   ├── entities/                      # ข้อมูลพื้นฐาน (Business Objects)
│   │   ├── user.dart                  # ข้อมูลผู้ใช้
│   │   ├── loan_calculation.dart      # ข้อมูลการคำนวณสินเชื่อ
│   │   └── loan_result.dart           # ผลลัพธ์การคำนวณ
│   │
│   ├── repositories/                  # Repository Interfaces
│   │   └── auth_repository.dart       # Interface สำหรับ Authentication
│   │
│   └── usecases/                      # Business Logic (Use Cases)
│       ├── login_usecase.dart         # Use Case: เข้าสู่ระบบ
│       ├── register_usecase.dart      # Use Case: สมัครสมาชิก
│       ├── logout_usecase.dart        # Use Case: ออกจากระบบ
│       ├── get_current_user_usecase.dart  # Use Case: ดึงข้อมูลผู้ใช้
│       └── calculate_loan_usecase.dart    # Use Case: คำนวณสินเชื่อ
│
├── 💾 data/                           # Data Layer (Data Access)
│   ├── datasources/                   # แหล่งข้อมูล
│   │   └── local_data_source.dart     # จัดการข้อมูลใน SharedPreferences
│   │
│   └── repositories/                  # Repository Implementations
│       └── auth_repository_impl.dart  # Implementation ของ AuthRepository
│
├── 🎨 widgets/                        # Reusable Widgets (Custom Components)
│   ├── app_icons.dart                 # ไอคอนหลักและไอคอนประเภทสินเชื่อ
│   └── README.md                      # เอกสารการใช้งาน widgets ภาษาไทย
│
└── 🎨 screens/                        # Presentation Layer (UI)
    ├── 🔐 auth/                       # Authentication Screens
    │   ├── login_screen.dart          # หน้าเข้าสู่ระบบ
    │   ├── register_screen.dart       # หน้าสมัครสมาชิก
    │   └── auth_screens.dart          # Export file สำหรับ auth
    │
    ├── 🧮 calculators/                # Calculator Screens
    │   ├── house_loan_calculator.dart      # คำนวณสินเชื่อบ้าน
    │   ├── car_loan_calculator.dart        # คำนวณสินเชื่อรถยนต์
    │   ├── personal_loan_calculator.dart   # คำนวณสินเชื่อส่วนบุคคล
    │   ├── other_loan_calculator.dart      # คำนวณสินเชื่ออื่นๆ
    │   └── calculator_screens.dart         # Export file สำหรับ calculators
    │
    ├── 🏠 main/                       # Main App Screens
    │   ├── home_screen.dart           # หน้าหลัก
    │   ├── main_navigation.dart       # Navigation และ Settings
    │   └── main_screens.dart          # Export file สำหรับ main
    │
    ├── 👤 profile/                    # Profile Related Screens
    │   ├── profile_screen.dart        # หน้าโปรไฟล์ผู้ใช้
    │   └── profile_screens.dart       # Export file สำหรับ profile
    │
    └── 📋 screens.dart                # Main export file ทั้งหมด
```

### 🎯 ประโยชน์ของโครงสร้าง Clean Architecture:

#### 1. **🏛️ แยก Layer อย่างชัดเจน**
- **Core Layer**: ค่าคงที่และ Utilities ที่ใช้ทั่วทั้งแอป
- **Domain Layer**: Business Logic ที่เป็นอิสระจาก Framework
- **Data Layer**: จัดการข้อมูลและ Storage
- **Presentation Layer**: UI และ Screens ที่จัดกลุ่มตามหน้าที่

#### 2. **📐 Constants เป็นมาตรฐาน (NEW!)**
- **สี (Colors)**: สีมาตรฐานสำหรับแอป, สีประเภทสินเชื่อ, สีสถานะ
- **ข้อความ (Text Styles)**: Headings, Body, Labels, Buttons
- **ขนาด (Dimensions)**: Spacing, Padding, Border Radius, Icon Sizes
- **ข้อความ (Strings)**: Labels, Messages, Hints ภาษาไทย
- **ค่าคงที่ (Constants)**: Limits, Formats, Keys, Configuration
- **ประโยชน์**: 
  - UI สม่ำเสมอทั่วทั้งแอป
  - แก้ไขค่าที่เดียว เปลี่ยนทั่วทั้งแอป
  - รองรับ Theming และ Dark Mode
  - ลดข้อผิดพลาดจาก hardcoded values

#### 3. **🗂️ การจัดกลุ่ม Screens ตามหน้าที่**
- **Auth**: การเข้าสู่ระบบและสมัครสมาชิก
- **Calculators**: เครื่องมือคำนวณทุกประเภท
- **Main**: หน้าหลักและ navigation
- **Profile**: จัดการข้อมูลผู้ใช้
- **Widgets**: Custom widgets ที่ใช้ซ้ำได้ทั่วทั้งแอป

#### 4. **📈 ง่ายต่อการทดสอบและขยาย**
- Business Logic แยกออกจาก UI สามารถ Unit Test ได้ง่าย
- เพิ่มหน้าใหม่ได้ง่ายในแต่ละหมวด
- แยกความรับผิดชอบชัดเจน
- ลดความซับซ้อนของ imports

#### 5. **🔄 Export Files**
- ไฟล์ `*_screens.dart` ใน folder ต่างๆ
- ไฟล์ `screens.dart` หลักสำหรับ import ทั้งหมด
- ง่ายต่อการ import และใช้งาน

### 📝 วิธีใช้งาน Import ใหม่:

#### แทนที่จะใช้:
```dart
import '../screens/login_screen.dart';
import '../screens/house_loan_calculator.dart';
import '../screens/home_screen.dart';
```

#### ใช้แบบใหม่:
```dart
// Import เฉพาะหมวด
import '../screens/auth/auth_screens.dart';
import '../screens/calculators/calculator_screens.dart';

// หรือ Import ทั้งหมด
import '../screens/screens.dart';
```

### 🔄 การอัพเดต Import Paths:

**✅ แก้ไขแล้ว:**
- `main.dart` - เปลี่ยน import paths
- `login_screen.dart` - อัพเดต relative imports
- `home_screen.dart` - อัพเดต calculator imports
- `main_navigation.dart` - อัพเดต profile imports
- `profile_screen.dart` - อัพเดต auth imports
- **Test files** - อัพเดต import paths ทั้งหมด
- **Domain Layer** - สร้าง Use Cases และ Entities
- **Data Layer** - สร้าง Data Sources และ Repository Implementations
- **Screens** - อัพเดตให้ใช้ Use Cases แทน Services

### 🚀 ขั้นตอนถัดไป (ถ้าต้องการขยายต่อ):

#### 1. **เพิ่ม Features ใหม่**
```dart
// เพิ่มใน domain/usecases/
save_loan_history_usecase.dart
get_loan_history_usecase.dart

// เพิ่มใน calculators/
business_loan_calculator.dart
investment_calculator.dart

// เพิ่มใน auth/
forgot_password_screen.dart
verify_email_screen.dart

// เพิ่มใน profile/
edit_profile_screen.dart
settings_screen.dart
```

#### 2. **ขยาย Data Layer**
```
data/
├── datasources/
│   ├── local_data_source.dart      # มีอยู่แล้ว
│   └── remote_data_source.dart     # สำหรับ API calls
└── repositories/
    ├── auth_repository_impl.dart   # มีอยู่แล้ว
    └── loan_repository_impl.dart   # สำหรับประวัติการคำนวณ
```

#### 3. **จัดการ Shared Components**
```
lib/
├── core/
│   └── constants/       # ✅ Constants (มีอยู่แล้ว - สี, ขนาด, ข้อความ)
├── widgets/
│   ├── common/          # Buttons, Cards, TextFields
│   ├── forms/           # Form Components
│   └── calculators/     # Calculator-specific Widgets
└── utils/
    ├── helpers/         # Helper Functions
    └── formatters/      # Number/Date Formatters
```

> **หมายเหตุ**: Constants ได้ถูกจัดเก็บแล้วใน `lib/core/constants/` ตามมาตรฐาน Clean Architecture

### 📊 สถิติการปรับปรุง:

- **📁 Folders สร้าง**: 
  - `core/constants/` layer (colors, text_styles, dimensions, strings, constants)
  - `domain/` layer (entities, repositories, usecases)
  - `data/` layer (datasources, repositories)
  - `screens/` subdirectories (auth, calculators, main, profile)
- **📋 Files จัดระเบียบ**: 26 ไฟล์
- **🔗 Import paths แก้ไข**: 15+ ไฟล์
- **📄 Export files**: 5 ไฟล์
- **✅ Test files อัพเดต**: 8 ไฟล์
- **🏛️ Clean Architecture**: 3 layers ที่แยกความรับผิดชอบชัดเจน

### 🎉 ผลลัพธ์:

✅ **โครงสร้าง Clean Architecture ที่เป็นมาตรฐาน**  
✅ **แยก Layer ชัดเจน (Domain, Data, Presentation)**  
✅ **โครงสร้าง Screens ที่เป็นระเบียบ**  
✅ **ง่ายต่อการหาไฟล์**  
✅ **สะดวกในการพัฒนาต่อ**  
✅ **Code maintenance ที่ดีขึ้น**  
✅ **ทดสอบได้ง่าย (Testability)**  
✅ **Team collaboration ที่ง่ายขึ้น**  

**📱 แอปยังคงทำงานได้ปกติ** และมีโครงสร้างที่ดีขึ้นสำหรับการพัฒนาในอนาคต!

> **เอกสารเพิ่มเติม**: ดูรายละเอียด Clean Architecture ใน [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md)
