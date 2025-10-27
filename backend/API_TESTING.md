# API Testing Guide

This guide shows you how to test the Loan Advisor Backend API using various tools.

## Prerequisites

- Backend server running on `http://localhost:3000`
- MongoDB running and connected

## Starting the Backend

### Using npm
```bash
cd backend
npm install
npm run start:dev
```

### Using Docker Compose
```bash
cd backend
docker-compose up -d
```

## API Endpoints

### 1. Health Check

Check if the API is running.

**Endpoint:** `GET /health`

#### Using cURL
```bash
curl http://localhost:3000/health
```

#### Using HTTPie
```bash
http GET http://localhost:3000/health
```

#### Expected Response
```json
{
  "status": "ok",
  "timestamp": "2025-10-27T10:00:00.000Z",
  "service": "loan-advisor-backend",
  "version": "1.0.0"
}
```

---

### 2. Register User

Register a new user account.

**Endpoint:** `POST /auth/register`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### Using cURL
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }'
```

#### Using HTTPie
```bash
http POST http://localhost:3000/auth/register \
  email=user@example.com \
  password=password123 \
  name="John Doe"
```

#### Using Postman
1. Set method to `POST`
2. URL: `http://localhost:3000/auth/register`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### Expected Response (201 Created)
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

#### Error Responses

**Duplicate Email (409 Conflict)**
```json
{
  "statusCode": 409,
  "message": "User with this email already exists",
  "error": "Conflict"
}
```

**Validation Error (400 Bad Request)**
```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "password must be longer than or equal to 6 characters"
  ],
  "error": "Bad Request"
}
```

---

### 3. Login

Authenticate and get access token.

**Endpoint:** `POST /auth/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Using cURL
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

#### Using HTTPie
```bash
http POST http://localhost:3000/auth/login \
  email=user@example.com \
  password=password123
```

#### Expected Response (200 OK)
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

#### Error Response

**Invalid Credentials (401 Unauthorized)**
```json
{
  "statusCode": 401,
  "message": "Invalid credentials",
  "error": "Unauthorized"
}
```

---

### 4. Get User Profile

Get authenticated user's profile information.

**Endpoint:** `GET /users/profile`

**Headers:** `Authorization: Bearer <access_token>`

#### Using cURL
```bash
# Replace YOUR_TOKEN with the accessToken from login/register
curl http://localhost:3000/users/profile \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### Using HTTPie
```bash
http GET http://localhost:3000/users/profile \
  "Authorization: Bearer YOUR_TOKEN"
```

#### Expected Response (200 OK)
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "isActive": true,
  "createdAt": "2025-10-27T10:00:00.000Z",
  "updatedAt": "2025-10-27T10:00:00.000Z"
}
```

#### Error Response

**Missing or Invalid Token (401 Unauthorized)**
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

---

## Complete Testing Flow

### 1. Register a new user
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123456",
    "name": "Test User"
  }' | jq
```

Save the `accessToken` from the response.

### 2. Login with the user
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123456"
  }' | jq
```

### 3. Get user profile
```bash
TOKEN="YOUR_ACCESS_TOKEN_HERE"
curl http://localhost:3000/users/profile \
  -H "Authorization: Bearer $TOKEN" | jq
```

---

## Testing with Postman Collection

### Import to Postman

1. Create a new collection named "Loan Advisor API"
2. Add the following requests:

#### Request 1: Health Check
- Method: `GET`
- URL: `{{base_url}}/health`

#### Request 2: Register
- Method: `POST`
- URL: `{{base_url}}/auth/register`
- Headers: `Content-Type: application/json`
- Body:
```json
{
  "email": "{{email}}",
  "password": "{{password}}",
  "name": "{{name}}"
}
```
- Tests (to save token):
```javascript
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

var jsonData = pm.response.json();
pm.environment.set("access_token", jsonData.accessToken);
```

#### Request 3: Login
- Method: `POST`
- URL: `{{base_url}}/auth/login`
- Headers: `Content-Type: application/json`
- Body:
```json
{
  "email": "{{email}}",
  "password": "{{password}}"
}
```
- Tests:
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

var jsonData = pm.response.json();
pm.environment.set("access_token", jsonData.accessToken);
```

#### Request 4: Get Profile
- Method: `GET`
- URL: `{{base_url}}/users/profile`
- Headers: `Authorization: Bearer {{access_token}}`

### Environment Variables

Create an environment with:
```
base_url = http://localhost:3000
email = test@example.com
password = test123456
name = Test User
access_token = (will be set automatically)
```

---

## Testing with VS Code REST Client

Install the REST Client extension and create a file `api-test.http`:

```http
### Variables
@baseUrl = http://localhost:3000
@email = test@example.com
@password = test123456
@name = Test User

### Health Check
GET {{baseUrl}}/health

### Register
# @name register
POST {{baseUrl}}/auth/register
Content-Type: application/json

{
  "email": "{{email}}",
  "password": "{{password}}",
  "name": "{{name}}"
}

### Extract token from register
@authToken = {{register.response.body.accessToken}}

### Login
# @name login
POST {{baseUrl}}/auth/login
Content-Type: application/json

{
  "email": "{{email}}",
  "password": "{{password}}"
}

### Get Profile (using token from register)
GET {{baseUrl}}/users/profile
Authorization: Bearer {{authToken}}

### Get Profile (using token from login)
GET {{baseUrl}}/users/profile
Authorization: Bearer {{login.response.body.accessToken}}
```

---

## Common Issues

### 1. Connection Refused
- Make sure the backend is running
- Check if MongoDB is running and accessible

### 2. 401 Unauthorized on Profile Endpoint
- Make sure you're including the Bearer token in the Authorization header
- Check if the token is still valid (default expiry is 7 days)
- Ensure the token format is: `Bearer <token>`

### 3. 409 Conflict on Register
- The email is already registered
- Try with a different email or use the login endpoint

### 4. MongoDB Connection Error
- Start MongoDB: `brew services start mongodb-community` (macOS)
- Or use Docker: `docker run -d -p 27017:27017 mongo:7`
- Or use the provided docker-compose: `docker-compose up -d mongodb`

---

## Automated Testing Script

Create a file `test-api.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:3000"
EMAIL="test$(date +%s)@example.com"
PASSWORD="test123456"
NAME="Test User"

echo "=== Testing Loan Advisor API ==="
echo ""

# Health Check
echo "1. Health Check"
curl -s "$BASE_URL/health" | jq
echo ""

# Register
echo "2. Register User"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\",\"name\":\"$NAME\"}")
echo "$REGISTER_RESPONSE" | jq
TOKEN=$(echo "$REGISTER_RESPONSE" | jq -r '.accessToken')
echo ""

# Login
echo "3. Login User"
curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" | jq
echo ""

# Get Profile
echo "4. Get User Profile"
curl -s "$BASE_URL/users/profile" \
  -H "Authorization: Bearer $TOKEN" | jq
echo ""

echo "=== All Tests Complete ==="
```

Make it executable and run:
```bash
chmod +x test-api.sh
./test-api.sh
```

---

## Integration with Flutter App

To integrate with the Flutter app:

1. Update the base URL in Flutter app to point to your backend
2. Save the `accessToken` in Flutter secure storage
3. Include the token in all authenticated requests:
   ```dart
   headers: {
     'Authorization': 'Bearer $token',
     'Content-Type': 'application/json',
   }
   ```

---

## Monitoring and Logs

View backend logs:
```bash
# Direct run
npm run start:dev

# Docker
docker-compose logs -f backend
```
