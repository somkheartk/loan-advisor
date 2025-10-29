# Login Options

## Authentication Methods

The Loan Advisor app supports multiple authentication methods to provide flexibility for users:

### 1. Email/Password Login (Default)

Traditional email and password authentication stored locally using SharedPreferences.

**Features:**
- User registration with email, password, and name
- Secure local storage
- Password validation (minimum 6 characters)
- Mock users for testing

**Test Accounts:**
- Email: `test@email.com` / Password: `123456`
- Email: `admin@loan.com` / Password: `admin123`

### 2. Google Sign-In

Users can sign in using their Google account.

**Features:**
- One-tap sign-in with Google
- Automatic profile information retrieval (name, email)
- Seamless user experience
- Available on both Android and iOS

**Setup Required:**
See [SOCIAL_LOGIN_SETUP.md](SOCIAL_LOGIN_SETUP.md) for configuration instructions.

### 3. Apple Sign-In

Users can sign in using their Apple ID (iOS devices only).

**Features:**
- Native Apple authentication
- Privacy-focused (hide email option supported)
- Required for iOS apps with third-party authentication
- Available on iOS 13 and later

**Setup Required:**
See [SOCIAL_LOGIN_SETUP.md](SOCIAL_LOGIN_SETUP.md) for configuration instructions.

### 4. Facebook Login (Planned)

Facebook login support is prepared in the codebase but requires additional implementation.

**Status:** Not yet implemented
**To implement:** Follow instructions in [SOCIAL_LOGIN_SETUP.md](SOCIAL_LOGIN_SETUP.md)

## See Also

- [SOCIAL_LOGIN_SETUP.md](SOCIAL_LOGIN_SETUP.md) - Detailed setup instructions
- [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md) - Architecture overview
- [README.md](README.md) - General application documentation
