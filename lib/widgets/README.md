# 🎨 Widgets - คู่มือการใช้งาน Widget ประกอบ

## 📋 สารบัญ
- [ภาพรวม](#ภาพรวม)
- [Widget ทั้งหมด](#widget-ทั้งหมด)
  - [AppIcon](#appicon)
  - [LoanTypeIcon](#loantypeicon)
  - [CalculatorIcon](#calculatoricon)
- [ตัวอย่างการใช้งาน](#ตัวอย่างการใช้งาน)

---

## ภาพรวม

โฟลเดอร์นี้ประกอบด้วย **Custom Widgets** ที่ใช้ทั่วทั้งแอปพลิเคชัน Loan Advisor เพื่อสร้างอินเทอร์เฟซที่สวยงามและสม่ำเสมอ Widget เหล่านี้เป็น **reusable components** ที่สามารถนำไปใช้ในหลายหน้าได้

### ไฟล์ในโฟลเดอร์:
- `app_icons.dart` - ประกอบด้วย widget ไอคอนทั้งหมดของแอป

---

## Widget ทั้งหมด

### AppIcon

ไอคอนหลักของแอปพลิเคชัน แสดงเป็นเครื่องคิดเลขพร้อมสัญลักษณ์เงินบาท (฿)

#### 🎯 จุดประสงค์
ใช้แสดงโลโก้หรือไอคอนของแอปในที่ต่างๆ เช่น หน้า splash screen, app bar, หรือในรายการแอป

#### 📦 Properties

| Property | Type | Default | คำอธิบาย |
|----------|------|---------|---------|
| `size` | `double` | `24` | ขนาดของไอคอน (กว้างและสูงเท่ากัน) |
| `backgroundColor` | `Color?` | `Theme.primaryColor` | สีพื้นหลังของไอคอน |
| `iconColor` | `Color?` | `Colors.white` | สีของไอคอนเครื่องคิดเลข |

#### ✨ ลักษณะ
- รูปสี่เหลี่ยมมุมมน (rounded corners)
- ไอคอนเครื่องคิดเลข (Icons.calculate) อยู่ตรงกลาง
- วงกลมสีเหลือง/ส้มด้านบนขวา แสดงสัญลักษณ์บาท (฿)
- มีเงา (shadow) เล็กน้อยเพื่อความลึก

#### 💻 ตัวอย่างการใช้งาน

```dart
// ขนาดมาตรฐาน
AppIcon()

// ปรับขนาดใหญ่ขึ้น
AppIcon(size: 64)

// กำหนดสีเอง
AppIcon(
  size: 48,
  backgroundColor: Colors.blue,
  iconColor: Colors.white,
)

// ใช้ในหน้าจอหรือ Card
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        AppIcon(size: 80),
        SizedBox(height: 16),
        Text('Loan Advisor'),
      ],
    ),
  ),
)
```

---

### LoanTypeIcon

ไอคอนแสดงประเภทของสินเชื่อ แต่ละประเภทมีไอคอนและสีที่แตกต่างกัน

#### 🎯 จุดประสงค์
ใช้แสดงประเภทสินเชื่อในรายการ หรือเป็นส่วนหนึ่งของปุ่มเลือกประเภทสินเชื่อ

#### 📦 Properties

| Property | Type | Required | Default | คำอธิบาย |
|----------|------|----------|---------|---------|
| `type` | `LoanType` | ✅ | - | ประเภทสินเชื่อ (house/car/personal/other) |
| `size` | `double` | ❌ | `24` | ขนาดของไอคอน |
| `color` | `Color?` | ❌ | ตามประเภท | สีของไอคอน (override สีเริ่มต้น) |

#### 🎨 ประเภทสินเชื่อและสี

| LoanType | ไอคอน | สีเริ่มต้น | ความหมาย |
|----------|-------|----------|----------|
| `LoanType.house` | `Icons.home` | 🟠 สีส้ม | สินเชื่อบ้าน |
| `LoanType.car` | `Icons.directions_car` | 🔵 สีน้ำเงิน | สินเชื่อรถยนต์ |
| `LoanType.personal` | `Icons.person` | 🟢 สีเขียว | สินเชื่อส่วนบุคคล |
| `LoanType.other` | `Icons.account_balance` | 🟣 สีม่วง | สินเชื่ออื่นๆ |

#### ✨ ลักษณะ
- พื้นหลังสีอ่อน (10% opacity ของสีหลัก)
- ไอคอนสีเข้มตรงกลาง
- มุมมน (rounded corners)

#### 💻 ตัวอย่างการใช้งาน

```dart
// ไอคอนสินเชื่อบ้าน
LoanTypeIcon(type: LoanType.house)

// ไอคอนสินเชื่อรถขนาดใหญ่
LoanTypeIcon(
  type: LoanType.car,
  size: 48,
)

// กำหนดสีเอง
LoanTypeIcon(
  type: LoanType.personal,
  size: 36,
  color: Colors.purple,
)

// ใช้ในปุ่ม Card
Card(
  child: ListTile(
    leading: LoanTypeIcon(
      type: LoanType.house,
      size: 40,
    ),
    title: Text('คำนวณสินเชื่อบ้าน'),
    subtitle: Text('คำนวณค่าผ่อนรายเดือน'),
    onTap: () {
      // Navigate to house calculator
    },
  ),
)

// แสดงรายการประเภทสินเชื่อทั้งหมด
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    LoanTypeIcon(type: LoanType.house, size: 32),
    LoanTypeIcon(type: LoanType.car, size: 32),
    LoanTypeIcon(type: LoanType.personal, size: 32),
    LoanTypeIcon(type: LoanType.other, size: 32),
  ],
)
```

#### 📝 Enum: LoanType

```dart
enum LoanType {
  house,      // สินเชื่อบ้าน
  car,        // สินเชื่อรถยนต์
  personal,   // สินเชื่อส่วนบุคคล
  other,      // สินเชื่ออื่นๆ
}
```

---

### CalculatorIcon

ไอคอนเครื่องคิดเลขที่มีรายละเอียด มีหน้าจอแสดงผลและปุ่มกด

#### 🎯 จุดประสงค์
ใช้เป็นไอคอนตกแต่งหรือแสดงให้เห็นถึงฟังก์ชันการคำนวณ

#### 📦 Properties

| Property | Type | Default | คำอธิบาย |
|----------|------|---------|---------|
| `size` | `double` | `24` | ขนาดของไอคอน (กว้างและสูงเท่ากัน) |
| `backgroundColor` | `Color?` | `Colors.grey[100]` | สีพื้นหลังของเครื่องคิดเลข |

#### ✨ ลักษณะ
- รูปสี่เหลี่ยมคล้ายเครื่องคิดเลขจริง
- **หน้าจอ**: พื้นดำแสดงตัวเลข "฿15,000" สีเขียว
- **ปุ่ม**: Grid 4x4 ปุ่ม (16 ปุ่ม)
  - ปุ่มซ้าย 3 คอลัมน์: สีเทา (ตัวเลข)
  - คอลัมน์ขวา: สีส้ม (เครื่องหมายคำนวณ)
  - ปุ่มล่างขวาสุด: สีเขียว (ปุ่มเท่ากับ)
- กรอบสีเทาอ่อน

#### 💻 ตัวอย่างการใช้งาน

```dart
// ขนาดมาตรฐาน
CalculatorIcon()

// ขนาดใหญ่
CalculatorIcon(size: 80)

// กำหนดสีพื้นหลัง
CalculatorIcon(
  size: 64,
  backgroundColor: Colors.white,
)

// ใช้ในการแสดงฟีเจอร์
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        CalculatorIcon(size: 100),
        SizedBox(height: 16),
        Text(
          'เครื่องคิดเลขสินเชื่อ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('คำนวณยอดผ่อนได้แม่นยำ'),
      ],
    ),
  ),
)

// ใช้เป็นตัวบ่งชี้
Container(
  decoration: BoxDecoration(
    color: Colors.blue[50],
    borderRadius: BorderRadius.circular(12),
  ),
  padding: EdgeInsets.all(20),
  child: Row(
    children: [
      CalculatorIcon(size: 60),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('เครื่องมือคำนวณครบครัน'),
            Text('คำนวณสินเชื่อบ้าน รถ และส่วนบุคคล'),
          ],
        ),
      ),
    ],
  ),
)
```

---

## ตัวอย่างการใช้งาน

### การ Import

```dart
// Import widget ทั้งหมด
import 'package:loan_advisor/widgets/app_icons.dart';

// หรือ import แค่ที่ต้องการใช้
import 'package:loan_advisor/widgets/app_icons.dart' show AppIcon;
import 'package:loan_advisor/widgets/app_icons.dart' show LoanTypeIcon, LoanType;
```

### ตัวอย่างหน้าจอที่ใช้ Widget

#### หน้าแรก (Home Screen)

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AppIcon(size: 32),
            SizedBox(width: 12),
            Text('Loan Advisor'),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          _buildCalculatorCard(
            icon: LoanTypeIcon(type: LoanType.house, size: 48),
            title: 'สินเชื่อบ้าน',
            onTap: () => navigateToHouseCalculator(),
          ),
          _buildCalculatorCard(
            icon: LoanTypeIcon(type: LoanType.car, size: 48),
            title: 'สินเชื่อรถยนต์',
            onTap: () => navigateToCarCalculator(),
          ),
          _buildCalculatorCard(
            icon: LoanTypeIcon(type: LoanType.personal, size: 48),
            title: 'สินเชื่อส่วนบุคคล',
            onTap: () => navigateToPersonalCalculator(),
          ),
          _buildCalculatorCard(
            icon: LoanTypeIcon(type: LoanType.other, size: 48),
            title: 'สินเชื่ออื่นๆ',
            onTap: () => navigateToOtherCalculator(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorCard({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### หน้า About

```dart
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เกี่ยวกับแอป')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(size: 120),
            SizedBox(height: 24),
            Text(
              'Loan Advisor',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('แอปคำนวณสินเชื่อที่ดีที่สุด'),
            SizedBox(height: 32),
            CalculatorIcon(size: 80),
            SizedBox(height: 16),
            Text('คำนวณได้แม่นยำทุกประเภทสินเชื่อ'),
          ],
        ),
      ),
    );
  }
}
```

#### หน้าเลือกประเภทสินเชื่อ

```dart
class LoanTypeSelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เลือกประเภทสินเชื่อ')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildLoanTypeItem(
            context,
            icon: LoanTypeIcon(type: LoanType.house, size: 56),
            title: 'สินเชื่อบ้าน',
            subtitle: 'คำนวณค่าผ่อนบ้านรายเดือน',
            color: Colors.orange,
          ),
          SizedBox(height: 16),
          _buildLoanTypeItem(
            context,
            icon: LoanTypeIcon(type: LoanType.car, size: 56),
            title: 'สินเชื่อรถยนต์',
            subtitle: 'คำนวณค่าผ่อนรถรายเดือน',
            color: Colors.blue,
          ),
          SizedBox(height: 16),
          _buildLoanTypeItem(
            context,
            icon: LoanTypeIcon(type: LoanType.personal, size: 56),
            title: 'สินเชื่อส่วนบุคคล',
            subtitle: 'คำนวณดอกเบี้ยและค่าผ่อน',
            color: Colors.green,
          ),
          SizedBox(height: 16),
          _buildLoanTypeItem(
            context,
            icon: LoanTypeIcon(type: LoanType.other, size: 56),
            title: 'สินเชื่ออื่นๆ',
            subtitle: 'คำนวณสินเชื่อประเภทอื่น',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildLoanTypeItem(
    BuildContext context, {
    required Widget icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: () {
          // Navigate to calculator
        },
      ),
    );
  }
}
```

---

## 💡 Tips การใช้งาน

### 1. ขนาดที่แนะนำ

```dart
// ใน ListTile
LoanTypeIcon(type: LoanType.house, size: 40)

// ใน Card ขนาดกลาง
LoanTypeIcon(type: LoanType.car, size: 56)

// ใน Hero หรือ Feature Card
AppIcon(size: 80)
CalculatorIcon(size: 100)

// ใน AppBar
AppIcon(size: 32)
```

### 2. การใช้สี

```dart
// ใช้สีตาม Theme
AppIcon(
  backgroundColor: Theme.of(context).primaryColor,
  iconColor: Theme.of(context).colorScheme.onPrimary,
)

// ใช้สีที่กำหนดเอง
LoanTypeIcon(
  type: LoanType.house,
  color: Theme.of(context).primaryColor,
)
```

### 3. Responsive Design

```dart
// ขนาดตามหน้าจอ
final screenWidth = MediaQuery.of(context).size.width;
final iconSize = screenWidth * 0.15; // 15% ของความกว้างหน้าจอ

AppIcon(size: iconSize)
```

### 4. Animation

```dart
// ใช้ AnimatedScale หรือ Hero
Hero(
  tag: 'app-icon',
  child: AppIcon(size: 100),
)

// หรือ
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: Duration(milliseconds: 500),
  builder: (context, scale, child) {
    return Transform.scale(
      scale: scale,
      child: AppIcon(size: 80),
    );
  },
)
```

---

## 🔧 การปรับแต่ง

### การสร้าง Widget ใหม่

หากต้องการเพิ่ม Widget ใหม่ในไฟล์นี้:

1. เพิ่ม Class ใหม่ใน `app_icons.dart`
2. สืบทอดจาก `StatelessWidget`
3. รับ parameters ที่จำเป็น
4. ใช้ `const` constructor ถ้าเป็นไปได้
5. อัพเดทเอกสารนี้

### ตัวอย่างการสร้าง Widget ใหม่

```dart
class CustomBadgeIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final double size;

  const CustomBadgeIcon({
    Key? key,
    required this.text,
    required this.icon,
    this.color = Colors.blue,
    this.size = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size * 0.2),
          ),
          child: Icon(icon, color: color, size: size * 0.5),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 📚 เอกสารเพิ่มเติม

- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Material Design Icons](https://material.io/resources/icons/)
- [README.md หลัก](../../README.md)
- [FOLDER_STRUCTURE.md](../../FOLDER_STRUCTURE.md)

---

## 🤝 การมีส่วนร่วม

หากต้องการเพิ่ม Widget ใหม่หรือปรับปรุง Widget ที่มีอยู่:

1. สร้าง Widget ใน `app_icons.dart`
2. เขียนเอกสารในไฟล์นี้
3. เพิ่มตัวอย่างการใช้งาน
4. Submit Pull Request

---

**สร้างด้วย ❤️ สำหรับ Loan Advisor**
