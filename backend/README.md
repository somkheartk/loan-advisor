# Loan Advisor Backend

Backend API for Loan Advisor application built with NestJS and MongoDB.

## 🚀 Quick Deploy

Deploy to DigitalOcean with one click - starting at **$5/month**!

[![Deploy to DO](.do/deploy-button.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/somkheartk/loan-advisor/tree/main)

📖 **[Complete Deployment Guide](.do/DEPLOYMENT_GUIDE.md)** - Step-by-step instructions for DigitalOcean deployment

## 📚 Documentation

### English Documentation
- **This file (README.md)**: Quick start and basic information

### Thai Documentation (เอกสารภาษาไทย) 🇹🇭

**📖 เอกสารฉบับสมบูรณ์ (แนะนำ):**
- **[📚 Documentation Index (เริ่มที่นี่)](DOCUMENTATION_INDEX_TH.md)**: ศูนย์รวมเอกสารและแนวทางการอ่าน
- **[📖 Backend Manual](BACKEND_MANUAL_TH.md)**: คู่มือ Backend ฉบับสมบูรณ์ (1,100+ บรรทัด)
- **[🏗️ Clean Architecture Guide](CLEAN_ARCHITECTURE_GUIDE_TH.md)**: คู่มือ Clean Architecture แบบละเอียด (700+ บรรทัด)

**📑 เอกสารเฉพาะด้าน:**
- **[Backend Documentation](BACKEND_TH.md)**: สถาปัตยกรรมและโครงสร้าง (512 บรรทัด)
- **[API Guide](API_GUIDE_TH.md)**: คู่มือการใช้งาน API (770 บรรทัด)
- **[Database Schema](DATABASE_SCHEMA_TH.md)**: โครงสร้างฐานข้อมูล (526 บรรทัด)

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

# Or use Docker
docker run -d -p 27017:27017 --name mongodb mongo:7
```

## Quick Start

### Option 1: Using npm (Development)
```bash
cd backend
npm install
npm run start:dev
```

### Option 2: Using Docker Compose (Production-like)
```bash
cd backend
# Make sure .env file is configured with your JWT_SECRET
docker-compose up -d
```

**⚠️ Security Note:** Before deploying to production, ensure you:
1. Create a `.env` file with a strong `JWT_SECRET`
2. Never commit `.env` to version control
3. Use environment variables or secrets management for production

This will start both MongoDB and the backend API.

The server will start on `http://localhost:3000`

## 🌐 Cloud Deployment

### DigitalOcean App Platform (Recommended - $5/month)

Deploy your backend to DigitalOcean with a single click:

1. **Quick Deploy**: Click the "Deploy to DO" button at the top of this README
2. **Connect GitHub**: Authorize DigitalOcean to access your repository
3. **Configure**: Set environment variables (JWT_SECRET, MONGODB_URI)
4. **Deploy**: Launch your app in minutes!

**Cost Options:**
- **$5/month**: Basic tier + MongoDB Atlas Free Tier
- **$20/month**: Basic tier + DigitalOcean Managed MongoDB

📖 **[Full Deployment Guide](.do/DEPLOYMENT_GUIDE.md)** - Complete setup instructions

### Configuration Files

The repository includes ready-to-use DigitalOcean configurations:

- `.do/app.yaml` - With managed MongoDB ($20/month)
- `.do/app-with-external-db.yaml` - For external MongoDB like Atlas ($5/month)

### Other Cloud Providers

The backend can also be deployed to:
- **Heroku**: Use `Dockerfile` and Heroku PostgreSQL
- **AWS**: Deploy with ECS/Fargate + DocumentDB
- **Google Cloud**: Use Cloud Run + MongoDB Atlas
- **Azure**: Deploy with App Service + Cosmos DB

## Testing the API

### Quick Test
```bash
# Health check
curl http://localhost:3000/health

# Or run the automated test script
./test-api.sh
```

For comprehensive testing guide, see [API_TESTING.md](API_TESTING.md)

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

### Using Docker
```bash
# Build and start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove data
docker-compose down -v
```
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

- **Password Hashing**: All passwords are hashed using bcrypt with 10 salt rounds
- **JWT Tokens**: Secure token-based authentication with 7-day expiration
- **Input Validation**: All inputs are validated using class-validator before reaching business logic
- **NoSQL Injection Protection**: Mongoose query builder provides automatic sanitization when using object notation
- **CORS**: Configured for secure cross-origin requests
- **Environment Variables**: Sensitive data (JWT secret, MongoDB URI) stored in environment variables
- **Protected Routes**: JWT authentication required for sensitive endpoints

### Security Best Practices

⚠️ **Important for Production:**

1. **JWT Secret**: Generate a strong, random JWT secret:
   ```bash
   node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
   ```
   Add it to your `.env` file as `JWT_SECRET`

2. **MongoDB Security**:
   - Enable authentication on MongoDB
   - Use strong passwords
   - Limit network access with firewall rules

3. **Environment Variables**:
   - Never commit `.env` files to version control
   - Use secrets management in production (AWS Secrets Manager, Azure Key Vault, etc.)

4. **HTTPS**:
   - Always use HTTPS in production
   - Consider using a reverse proxy (nginx, Apache) with SSL certificates

5. **Rate Limiting**:
   - Consider adding rate limiting to prevent brute force attacks
   - Use packages like `@nestjs/throttler`

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
