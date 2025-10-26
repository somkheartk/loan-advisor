# Clean Architecture Implementation

## Overview

This application has been refactored to follow **Clean Architecture** principles, which provides:
- **Separation of Concerns**: Each layer has a clear responsibility
- **Testability**: Business logic is independent of UI and data sources
- **Maintainability**: Easy to modify or replace components
- **Scalability**: Simple to add new features

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│              (UI/Screens - Flutter Widgets)                  │
│  - LoginScreen, HomeScreen, ProfileScreen                    │
│  - Calculator Screens (House, Car, Personal)                 │
└───────────────────────┬─────────────────────────────────────┘
                        │ uses
                        ↓
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│             (Business Logic - Pure Dart)                     │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Entities   │  │  Use Cases   │  │ Repositories │      │
│  │              │  │              │  │ (Interfaces) │      │
│  │ - User       │  │ - Login      │  │              │      │
│  │ - LoanCalc   │  │ - Register   │  │ - Auth       │      │
│  │ - LoanResult │  │ - Calculate  │  │   Repository │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└───────────────────────┬─────────────────────────────────────┘
                        │ implements
                        ↓
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│           (Data Access - Framework Dependent)                │
│                                                              │
│  ┌──────────────────────┐  ┌──────────────────────┐         │
│  │   Repositories       │  │   Data Sources       │         │
│  │  (Implementations)   │  │                      │         │
│  │                      │  │ - LocalDataSource    │         │
│  │ - AuthRepositoryImpl │  │   (SharedPreferences)│         │
│  └──────────────────────┘  └──────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## Layer Details

### 1. Domain Layer (`lib/domain/`)

The **core** of the application. Contains business logic with **no dependencies** on external frameworks.

#### Entities (`lib/domain/entities/`)
Plain Dart classes representing business objects:
- **`User`**: Represents a user with email and name
- **`LoanCalculation`**: Input parameters for loan calculation
- **`LoanResult`**: Output of loan calculation

#### Repositories (`lib/domain/repositories/`)
Abstract interfaces defining data operations:
- **`AuthRepository`**: Interface for authentication operations

#### Use Cases (`lib/domain/usecases/`)
Single-purpose business logic operations:
- **`LoginUseCase`**: Handles user login
- **`RegisterUseCase`**: Handles user registration
- **`LogoutUseCase`**: Handles user logout
- **`GetCurrentUserUseCase`**: Retrieves current user
- **`CalculateLoanUseCase`**: Performs loan calculations

### 2. Data Layer (`lib/data/`)

Handles data access and storage. Implements domain repository interfaces.

#### Data Sources (`lib/data/datasources/`)
- **`LocalDataSource`**: Manages local storage using SharedPreferences
  - Save/retrieve user data
  - Authentication state management

#### Repositories (`lib/data/repositories/`)
- **`AuthRepositoryImpl`**: Implements `AuthRepository` interface
  - Bridges between domain layer and data sources
  - Converts data source responses to domain entities

### 3. Presentation Layer (`lib/screens/`)

UI layer with Flutter widgets. Depends on domain layer use cases.

#### Screens
- **Authentication**: `LoginScreen`, `RegisterScreen`
- **Main**: `HomeScreen`, `ProfileScreen`
- **Calculators**: `HouseLoanCalculator`, `CarLoanCalculator`, `PersonalLoanCalculator`

## Dependency Rules

```
Presentation → Domain ← Data
     ↓           ↑        ↑
   Domain       ↓        ↓
     ↓         Data  →  External
   Nothing            (SharedPreferences)
```

- **Domain layer** has NO dependencies (pure Dart)
- **Data layer** depends on Domain layer only
- **Presentation layer** depends on Domain layer only
- Dependencies point **inward** toward domain

## Data Flow

### Example: User Login Flow

```
1. User enters credentials in LoginScreen
         ↓
2. LoginScreen calls LoginUseCase.execute()
         ↓
3. LoginUseCase calls AuthRepository.login()
         ↓
4. AuthRepositoryImpl calls LocalDataSource.authenticateUser()
         ↓
5. LocalDataSource checks SharedPreferences
         ↓
6. Result flows back up:
   LocalDataSource → AuthRepositoryImpl → LoginUseCase → LoginScreen
         ↓
7. LoginScreen updates UI based on result
```

### Example: Loan Calculation Flow

```
1. User enters loan details in HouseLoanCalculator
         ↓
2. HouseLoanCalculator creates LoanCalculation entity
         ↓
3. HouseLoanCalculator calls CalculateLoanUseCase.execute()
         ↓
4. CalculateLoanUseCase performs calculation
         ↓
5. Returns LoanResult entity
         ↓
6. HouseLoanCalculator displays results
```

## Benefits of This Architecture

### 1. **Testability**
- Business logic (use cases) can be unit tested without UI or database
- Easy to mock dependencies

### 2. **Flexibility**
- Can swap SharedPreferences for a different storage solution by:
  - Creating a new DataSource
  - Updating AuthRepositoryImpl
  - No changes to domain or presentation layers needed

### 3. **Maintainability**
- Clear separation of concerns
- Each class has a single responsibility
- Easy to locate and fix bugs

### 4. **Scalability**
- Adding new features follows established patterns
- Minimal impact on existing code

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── domain/                            # Domain Layer (Pure Dart)
│   ├── entities/                      # Business objects
│   │   ├── user.dart
│   │   ├── loan_calculation.dart
│   │   └── loan_result.dart
│   ├── repositories/                  # Repository interfaces
│   │   └── auth_repository.dart
│   └── usecases/                      # Business logic
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       ├── logout_usecase.dart
│       ├── get_current_user_usecase.dart
│       └── calculate_loan_usecase.dart
├── data/                              # Data Layer
│   ├── datasources/                   # Data sources
│   │   └── local_data_source.dart
│   └── repositories/                  # Repository implementations
│       └── auth_repository_impl.dart
└── screens/                           # Presentation Layer
    ├── login_screen.dart
    ├── register_screen.dart
    ├── home_screen.dart
    ├── profile_screen.dart
    ├── house_loan_calculator.dart
    ├── car_loan_calculator.dart
    └── personal_loan_calculator.dart
```

## Adding New Features

### Example: Add a new type of loan calculator

1. **Domain Layer**:
   - Reuse existing `LoanCalculation` and `LoanResult` entities
   - Reuse `CalculateLoanUseCase` (or create specialized if needed)

2. **Presentation Layer**:
   - Create new screen (e.g., `BusinessLoanCalculator`)
   - Inject `CalculateLoanUseCase`
   - Follow existing calculator patterns

### Example: Add remote authentication

1. **Data Layer**:
   - Create `RemoteDataSource` class
   - Update `AuthRepositoryImpl` to use both local and remote sources
   - Handle network calls, caching, etc.

2. **Domain & Presentation**:
   - No changes needed!

## Testing Strategy

### Unit Tests
- Test use cases with mocked repositories
- Test repository implementations with mocked data sources
- Test entities (if they contain logic)

### Widget Tests
- Test screens with mocked use cases
- Verify UI behavior and user interactions

### Integration Tests
- Test complete flows from UI to data layer
- Verify real storage operations

## Migration Notes

The refactoring maintained **100% backward compatibility**:
- All existing features work as before
- User data is preserved
- No breaking changes to the UI

Changes made:
- Moved `UserService` logic to `LocalDataSource` and `AuthRepositoryImpl`
- Extracted calculation logic from screens to `CalculateLoanUseCase`
- Screens now use dependency injection for use cases
- Old `services/` directory removed

## Best Practices

1. **Keep domain layer pure**: No Flutter or external dependencies
2. **Use dependency injection**: Pass dependencies through constructors
3. **Single Responsibility**: Each class should do one thing well
4. **Interface over implementation**: Depend on abstractions (repository interfaces)
5. **Test-driven development**: Write tests for business logic first

## Further Improvements

Potential enhancements:
1. **Add state management** (BLoC, Provider, Riverpod)
2. **Dependency injection container** (GetIt, injectable)
3. **Error handling layer** with custom exceptions
4. **API integration** for remote data
5. **Analytics tracking** use case
6. **Loan history** feature with new repository

## Conclusion

This clean architecture provides a solid foundation for:
- Easy testing and maintenance
- Team collaboration with clear boundaries
- Future growth and feature additions
- Professional, production-ready code structure
