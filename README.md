# Loan Advisor

แอปพลิเคชัน Flutter สำหรับคำนวณการผ่อนบ้าน รถ และดอกเบี้ยส่วนบุคคล

## คุณสมบัติ

- **ระบบสมัครสมาชิกและเข้าสู่ระบบ**: จัดการบัญชีผู้ใช้งานได้อย่างปลอดภัย
- **คำนวณการผ่อนบ้าน**: คำนวณยอดผ่อนรายเดือนสำหรับสินเชื่อบ้าน
- **คำนวณการผ่อนรถ**: คำนวณยอดผ่อนรายเดือนสำหรับสินเชื่อรถยนต์ พร้อมคำนวณเงินดาวน์
- **คำนวณดอกเบี้ยส่วนบุคคล**: คำนวณดอกเบี้ยและยอดผ่อนสินเชื่อส่วนบุคคล
- **อินเทอร์เฟซภาษาไทย**: รองรับภาษาไทยทั้งหมด
- **จัดเก็บข้อมูลในเครื่อง**: ข้อมูลผู้ใช้ถูกเก็บไว้ในเครื่องอย่างปลอดภัย

## การติดตั้ง

### ข้อกำหนดเบื้องต้น

- Flutter SDK (3.0.0 หรือสูงกว่า)
- Dart SDK
- Android Studio / Xcode (สำหรับการพัฒนา)

### ขั้นตอนการติดตั้ง

1. Clone repository:
```bash
git clone https://github.com/somkheartk/loan-advisor.git
cd loan-advisor
```

2. ติดตั้ง dependencies:
```bash
flutter pub get
```

3. รันแอปพลิเคชัน:
```bash
flutter run
```

## โครงสร้างโปรเจค

```
lib/
├── main.dart                 # จุดเริ่มต้นของแอป
│
├── domain/                   # Domain Layer (Business Logic)
│   ├── entities/             # ข้อมูลพื้นฐาน
│   │   ├── user.dart
│   │   ├── loan_calculation.dart
│   │   └── loan_result.dart
│   ├── repositories/         # Repository Interfaces
│   │   └── auth_repository.dart
│   └── usecases/             # Business Logic
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       ├── logout_usecase.dart
│       ├── get_current_user_usecase.dart
│       └── calculate_loan_usecase.dart
│
├── data/                     # Data Layer (Data Access)
│   ├── datasources/          # แหล่งข้อมูล
│   │   └── local_data_source.dart
│   └── repositories/         # Repository Implementations
│       └── auth_repository_impl.dart
│
└── screens/                  # Presentation Layer (UI)
    ├── auth/                 # Authentication Screens
    │   ├── login_screen.dart
    │   ├── register_screen.dart
    │   └── auth_screens.dart
    ├── calculators/          # Calculator Screens
    │   ├── house_loan_calculator.dart
    │   ├── car_loan_calculator.dart
    │   ├── personal_loan_calculator.dart
    │   ├── other_loan_calculator.dart
    │   └── calculator_screens.dart
    ├── main/                 # Main App Screens
    │   ├── home_screen.dart
    │   ├── main_navigation.dart
    │   └── main_screens.dart
    ├── profile/              # Profile Screens
    │   ├── profile_screen.dart
    │   └── profile_screens.dart
    └── screens.dart          # Main export file
```

> **หมายเหตุ**: แอปพลิเคชันใช้ Clean Architecture เพื่อแยกความรับผิดชอบระหว่าง Business Logic, Data Access และ UI อย่างชัดเจน ดูรายละเอียดเพิ่มเติมใน [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md)

## การใช้งาน

1. **สมัครสมาชิก**: เปิดแอปและสร้างบัญชีใหม่ด้วยอีเมลและรหัสผ่าน
2. **เข้าสู่ระบบ**: ใช้ข้อมูลที่สมัครไว้เพื่อเข้าสู่ระบบ
3. **เลือกเครื่องมือคำนวณ**: เลือกประเภทสินเชื่อที่ต้องการคำนวณ
4. **กรอกข้อมูล**: ใส่ข้อมูลสินเชื่อที่ต้องการคำนวณ
5. **ดูผลลัพธ์**: ระบบจะแสดงยอดผ่อนรายเดือนและดอกเบี้ยรวม

## Dependencies

- `flutter`: Flutter SDK
- `shared_preferences`: ^2.2.2 - สำหรับจัดเก็บข้อมูลในเครื่อง
- `intl`: ^0.18.1 - สำหรับจัดรูปแบบตัวเลขและวันที่

## License

This project is licensed under the MIT License.

## ผู้พัฒนา

Somkheart K.