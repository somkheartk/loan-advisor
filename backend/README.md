# Loan Advisor Backend

Backend API for Loan Advisor application built with NestJS and MongoDB.

## Features

- **User Registration**: Register new users with email, password, and name
- **User Login**: Authenticate users with JWT tokens
- **User Profile**: Get authenticated user profile information
- **JWT Authentication**: Secure endpoints with JWT tokens
- **MongoDB Integration**: Persistent data storage with MongoDB
- **Input Validation**: Comprehensive validation for all inputs
- **Password Hashing**: Secure password storage using bcrypt
- **CORS Enabled**: Ready for Flutter app integration

## Technologies

- **NestJS**: Progressive Node.js framework
- **MongoDB**: NoSQL database with Mongoose ODM
- **JWT**: JSON Web Tokens for authentication
- **Bcrypt**: Password hashing
- **Class Validator**: Input validation
- **TypeScript**: Type-safe development

## Installation

### Prerequisites

- Node.js (v18 or higher)
- MongoDB (running locally or remote connection)
- npm or yarn

### Setup

1. Install dependencies:
```bash
npm install
```

2. Configure environment variables:
```bash
cp .env.example .env
```

Edit `.env` file with your configuration:
- `MONGODB_URI`: Your MongoDB connection string
- `JWT_SECRET`: Your JWT secret key (change in production)
- `JWT_EXPIRES_IN`: Token expiration time (default: 7 days)

3. Start MongoDB (if running locally):
```bash
# macOS (using brew)
brew services start mongodb-community

# Linux
sudo systemctl start mongod

# Windows
net start MongoDB
```

## Running the Application

### Development mode
```bash
npm run start:dev
```

### Production mode
```bash
npm run build
npm run start:prod
```

The server will start on `http://localhost:3000`

## API Endpoints

### Authentication

#### Register
- **POST** `/auth/register`
- **Body**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```
- **Response**:
```json
{
  "accessToken": "jwt-token-here",
  "user": {
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

#### Login
- **POST** `/auth/login`
- **Body**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
- **Response**:
```json
{
  "accessToken": "jwt-token-here",
  "user": {
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

### User Profile

#### Get Profile
- **GET** `/users/profile`
- **Headers**: `Authorization: Bearer <jwt-token>`
- **Response**:
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "isActive": true,
  "createdAt": "2025-10-27T10:00:00.000Z",
  "updatedAt": "2025-10-27T10:00:00.000Z"
}
```

## Project Structure

```
backend/
├── src/
│   ├── auth/                   # Authentication module
│   │   ├── dto/                # Data Transfer Objects
│   │   ├── guards/             # Auth guards
│   │   ├── strategies/         # Passport strategies
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   └── auth.module.ts
│   ├── users/                  # Users module
│   │   ├── dto/                # Data Transfer Objects
│   │   ├── user.schema.ts      # MongoDB schema
│   │   ├── users.controller.ts
│   │   ├── users.service.ts
│   │   └── users.module.ts
│   ├── app.module.ts           # Root module
│   └── main.ts                 # Application entry point
├── .env                        # Environment variables
├── .env.example                # Example environment variables
├── nest-cli.json               # Nest CLI configuration
├── package.json
└── tsconfig.json               # TypeScript configuration
```

## Security Features

- **Password Hashing**: All passwords are hashed using bcrypt with salt rounds
- **JWT Tokens**: Secure token-based authentication
- **Input Validation**: All inputs are validated using class-validator
- **CORS**: Configured for secure cross-origin requests
- **MongoDB Security**: Connection string stored in environment variables

## Testing with cURL

### Register a user
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "Test User"
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Get Profile
```bash
curl -X GET http://localhost:3000/users/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

## Development

### Available Scripts

- `npm run start` - Start the application
- `npm run start:dev` - Start in development mode with hot-reload
- `npm run start:prod` - Start in production mode
- `npm run build` - Build the application

## Integration with Flutter App

The backend is configured to work seamlessly with the Flutter Loan Advisor app:

1. Update Flutter app to call backend APIs instead of using SharedPreferences
2. Store JWT token in Flutter app for authenticated requests
3. Use the token in Authorization header for protected endpoints

## License

MIT
