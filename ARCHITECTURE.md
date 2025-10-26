# Flutter App Architecture

## Application Structure

```
Loan Advisor App
│
├── Authentication Layer
│   ├── Login Screen
│   ├── Register Screen
│   └── Auth Check (Entry Point)
│
├── Main Features
│   ├── Home Screen (Dashboard)
│   │   └── Calculator Cards Navigation
│   │
│   ├── House Loan Calculator
│   │   ├── Input: Loan Amount, Interest Rate, Term (Years)
│   │   └── Output: Monthly Payment, Total Payment, Total Interest
│   │
│   ├── Car Loan Calculator
│   │   ├── Input: Car Price, Down Payment, Interest Rate, Term (Years)
│   │   └── Output: Loan Amount, Monthly Payment, Total Payment, Total Interest
│   │
│   └── Personal Loan Calculator
│       ├── Input: Loan Amount, Interest Rate, Term (Months)
│       └── Output: Monthly Payment, Total Payment, Total Interest, Effective Rate
│
├── User Management
│   ├── Profile Screen
│   └── User Service (Local Storage)
│
└── Utilities (embedded in screens/services)
    ├── Navigation (Material Navigator)
    ├── Form Validation (Form/Validator widgets)
    └── Number Formatting (intl package)
```

## Data Flow

```
User Input
    ↓
Form Validation
    ↓
Calculation Engine
    ↓
Result Display
    ↓
User Review
```

## State Management

The app uses Flutter's built-in state management:
- **StatefulWidget** for interactive screens
- **SharedPreferences** for persistent storage
- **FormKey** for form validation

## Key Components

### 1. Authentication Flow
```
App Start → AuthCheck
    ├── isLoggedIn = true → Home Screen
    └── isLoggedIn = false → Login Screen
        └── Register → Auto Login → Home Screen
```

### 2. Calculator Logic
```dart
// Monthly Payment Formula
M = P × [r(1 + r)^n] / [(1 + r)^n - 1]

Where:
- M = Monthly Payment
- P = Principal (Loan Amount)
- r = Monthly Interest Rate (Annual Rate / 12 / 100)
- n = Number of Payments (Years × 12 or Months)
```

### 3. User Data Storage
```
UserService
    ├── register(email, password, name)
    ├── login(email, password)
    ├── logout()
    └── getCurrentUser()
        └── SharedPreferences
            ├── users: List<String> (email|password|name)
            ├── currentUser: String
            └── isLoggedIn: bool
```

## Screen Flow Diagram

```
┌─────────────────┐
│  Login Screen   │
│                 │
│  [Email]        │
│  [Password]     │
│  [Login Btn]    │
│  [Register Btn] │
└────────┬────────┘
         │
         ├──Register──→ ┌──────────────────┐
         │              │ Register Screen  │
         │              │                  │
         │              │  [Name]          │
         │              │  [Email]         │
         │              │  [Password]      │
         │              │  [Confirm Pass]  │
         │              │  [Register Btn]  │
         │              └────────┬─────────┘
         │                       │
         ↓                       ↓
    ┌────────────────────────────────┐
    │      Home Screen               │
    │  ┌──────────────────────────┐  │
    │  │  User Greeting Card      │  │
    │  └──────────────────────────┘  │
    │                                │
    │  ┌──────────────────────────┐  │
    │  │  🏠 House Loan          │──┼──→ House Calculator
    │  └──────────────────────────┘  │
    │  ┌──────────────────────────┐  │
    │  │  🚗 Car Loan            │──┼──→ Car Calculator
    │  └──────────────────────────┘  │
    │  ┌──────────────────────────┐  │
    │  │  💰 Personal Loan       │──┼──→ Personal Calculator
    │  └──────────────────────────┘  │
    │                                │
    │  [Profile] [Logout]            │
    └────────────────────────────────┘
```

## Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: StatefulWidget, setState
- **Storage**: SharedPreferences
- **UI**: Material Design 3
- **Localization**: Thai Language

## Design Patterns Used

1. **MVC-like Architecture**
   - Models: User data structures
   - Views: Screen widgets
   - Controllers: Services (UserService)

2. **Service Pattern**
   - UserService handles all auth operations

3. **Widget Composition**
   - Reusable card widgets
   - Consistent form fields
   - Shared result displays

4. **Separation of Concerns**
   - Screens (UI)
   - Services (Business Logic)
   - Models (Data)
   - Utils (Helpers)
