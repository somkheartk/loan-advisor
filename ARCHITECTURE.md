# Flutter App Architecture

**Note:** This app has been refactored to follow **Clean Architecture** principles. For detailed information about the new architecture, see [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md).

## Clean Architecture Overview

The application is now structured in three main layers:

### 1. **Domain Layer** (Business Logic)
- **Entities**: User, LoanCalculation, LoanResult
- **Use Cases**: Login, Register, Logout, GetCurrentUser, CalculateLoan
- **Repositories**: Interfaces for data access (AuthRepository)

### 2. **Data Layer** (Data Access)
- **Data Sources**: LocalDataSource (SharedPreferences)
- **Repository Implementations**: AuthRepositoryImpl

### 3. **Presentation Layer** (UI)
- **Screens**: All Flutter widgets and UI components

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

### 3. User Data Storage (Clean Architecture Flow)
```
Presentation Layer (Screens)
    ↓ uses
Use Cases (Domain Layer)
    ├── LoginUseCase
    ├── RegisterUseCase
    ├── LogoutUseCase
    └── GetCurrentUserUseCase
        ↓ depends on
AuthRepository Interface (Domain Layer)
        ↓ implemented by
AuthRepositoryImpl (Data Layer)
        ↓ uses
LocalDataSource (Data Layer)
        ↓ stores in
SharedPreferences
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

1. **Clean Architecture**
   - Domain Layer: Pure business logic
   - Data Layer: Repository pattern
   - Presentation Layer: UI components

2. **Repository Pattern**
   - AuthRepository interface in domain layer
   - AuthRepositoryImpl in data layer
   - Abstracts data source details

3. **Use Case Pattern**
   - Each business operation is a separate use case
   - Single Responsibility Principle
   - Easy to test and maintain

4. **Dependency Injection**
   - Use cases depend on repository interfaces
   - Screens inject required use cases
   - Loose coupling between layers

5. **Separation of Concerns**
   - Domain (business logic) → independent of frameworks
   - Data (storage) → implements domain interfaces
   - Presentation (UI) → uses domain use cases
