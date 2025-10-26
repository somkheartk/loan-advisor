# Visual Design Guide

## Color Scheme

### Primary Colors
- **Blue** (#2196F3): House Loan Calculator, Primary actions
- **Green** (#4CAF50): Car Loan Calculator, Success states
- **Orange** (#FF9800): Personal Loan Calculator, Warnings
- **Red** (#F44336): Error states, Interest amounts

### Background Colors
- **White** (#FFFFFF): Main backgrounds
- **Light Blue** (#E3F2FD): House calculator results
- **Light Green** (#E8F5E9): Car calculator results
- **Light Orange** (#FFF3E0): Personal calculator results

## Typography

### Thai Language Support
- All text is in Thai (ภาษาไทย)
- Clear and readable font sizes
- Consistent text hierarchy

### Text Sizes
- **App Title**: 32px, Bold
- **Screen Titles**: 24px, Bold
- **Section Headers**: 20px, Bold
- **Card Titles**: 18px, Bold
- **Body Text**: 16px, Regular
- **Subtitles**: 14px, Regular
- **Result Values**: 20px, Bold (highlighted)

## UI Components

### 1. Login Screen
```
┌─────────────────────────────────────┐
│                                     │
│           💰 (Calculate Icon)        │
│                                     │
│         Loan Advisor                │
│    คำนวณการผ่อนบ้าน รถ และดอกเบี้ย  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 📧 อีเมล                      │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🔒 รหัสผ่าน                   │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │      เข้าสู่ระบบ              │  │
│  └───────────────────────────────┘  │
│                                     │
│    ยังไม่มีบัญชี? สมัครสมาชิก      │
│                                     │
└─────────────────────────────────────┘
```

### 2. Home Screen
```
┌─────────────────────────────────────┐
│ Loan Advisor          👤 🚪         │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 👤  สวัสดี                    │  │
│  │     ชื่อผู้ใช้                │  │
│  └───────────────────────────────┘  │
│                                     │
│  เครื่องมือคำนวณ                   │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🏠  คำนวณการผ่อนบ้าน         │→ │
│  │     คำนวณยอดผ่อนรายเดือน...  │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🚗  คำนวณการผ่อนรถ           │→ │
│  │     คำนวณยอดผ่อนรายเดือน...  │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 💰  คำนวณดอกเบี้ยส่วนบุคคล   │→ │
│  │     คำนวณดอกเบี้ยสำหรับ...   │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### 3. House Loan Calculator
```
┌─────────────────────────────────────┐
│ ← คำนวณการผ่อนบ้าน                 │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ข้อมูลสินเชื่อบ้าน            │  │
│  │                               │  │
│  │ 💰 ยอดกู้ (บาท)               │  │
│  │ ┌───────────────────────────┐ │  │
│  │ │                           │ │  │
│  │ └───────────────────────────┘ │  │
│  │                               │  │
│  │ % อัตราดอกเบี้ยต่อปี (%)      │  │
│  │ ┌───────────────────────────┐ │  │
│  │ │                           │ │  │
│  │ └───────────────────────────┘ │  │
│  │                               │  │
│  │ 📅 ระยะเวลากู้ (ปี)           │  │
│  │ ┌───────────────────────────┐ │  │
│  │ │                           │ │  │
│  │ └───────────────────────────┘ │  │
│  │                               │  │
│  │ ┌───────────────────────────┐ │  │
│  │ │       คำนวณ               │ │  │
│  │ └───────────────────────────┘ │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ผลการคำนวณ                    │  │
│  │ ────────────────────────────  │  │
│  │                               │  │
│  │ ยอดผ่อนต่อเดือน               │  │
│  │           ฿15,228.00 (Blue)   │  │
│  │                               │  │
│  │ ยอดชำระรวมทั้งหมด             │  │
│  │           ฿5,482,080.00       │  │
│  │                               │  │
│  │ ดอกเบี้ยรวม                   │  │
│  │           ฿2,482,080.00 (Red) │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

## Interaction Patterns

### Form Inputs
- **Text Fields**: Outlined style with prefix icons (in login/register screens)
- **Validation**: Error messages shown on form submission
- **Keyboard**: Numeric for numbers, email for email
- **Focus**: Blue highlight border

### Buttons
- **Primary**: Elevated button with padding
- **Secondary**: Text button for less important actions
- **Loading**: Show CircularProgressIndicator

### Cards
- **Elevation**: 2dp shadow
- **Radius**: 12px rounded corners
- **Padding**: 16px internal spacing
- **Ripple**: Touch feedback on interactive cards

### Navigation
- **Back Button**: Standard app bar back arrow
- **Bottom Navigation**: Not used (kept simple)
- **Drawer**: Not used (kept simple)

## Accessibility

### Semantic Labels
- All interactive elements have meaningful labels
- Icons paired with text descriptions

### Touch Targets
- Minimum 48x48 dp for all interactive elements
- Sufficient spacing between touch targets

### Visual Feedback
- Loading indicators for async operations
- Success/error messages via SnackBar
- Validation errors shown immediately

## Responsive Design

### Layout
- Single column layout for simplicity
- ScrollView for longer content
- Safe area padding for notched devices

### Text Scaling
- Supports system text scaling
- Maintains layout integrity

## Animation & Transitions

### Page Transitions
- Default Material page transitions
- Smooth navigation between screens

### Loading States
- CircularProgressIndicator during operations
- PumpAndSettle for test synchronization

## Error States

### Validation Errors
- Red text below input fields on form submission
- Clear, actionable messages in Thai

### Network/Storage Errors
- SnackBar notifications
- Red background for errors
- Option to retry actions

## Success States

### Registration Success
- Auto-login after registration
- Navigate directly to home

### Calculation Success
- Immediate result display
- Color-coded result cards
- Formatted numbers with commas

## Thai Language Considerations

### Text Display
- All labels and messages in Thai
- Proper Thai font rendering
- Cultural appropriateness

### Number Formatting
- Use international number format (1,234.56)
- Currency symbol: ฿ (Thai Baht)
- Decimal precision: 2 places for money
