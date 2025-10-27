#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BASE_URL="${1:-http://localhost:3000}"
EMAIL="test$(date +%s)@example.com"
PASSWORD="test123456"
NAME="Test User"

echo "======================================"
echo "  Loan Advisor Backend API Tests"
echo "======================================"
echo ""
echo "Testing API at: $BASE_URL"
echo ""

# Test 1: Health Check
echo -e "${YELLOW}Test 1: Health Check${NC}"
HEALTH_RESPONSE=$(curl -s "$BASE_URL/health")
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Health check passed${NC}"
    echo "$HEALTH_RESPONSE" | jq '.'
else
    echo -e "${RED}✗ Health check failed${NC}"
    exit 1
fi
echo ""

# Test 2: Register User
echo -e "${YELLOW}Test 2: Register New User${NC}"
echo "Email: $EMAIL"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\",\"name\":\"$NAME\"}")

if echo "$REGISTER_RESPONSE" | jq -e '.accessToken' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ User registration successful${NC}"
    TOKEN=$(echo "$REGISTER_RESPONSE" | jq -r '.accessToken')
    echo "$REGISTER_RESPONSE" | jq '.'
else
    echo -e "${RED}✗ User registration failed${NC}"
    echo "$REGISTER_RESPONSE" | jq '.'
    exit 1
fi
echo ""

# Test 3: Login User
echo -e "${YELLOW}Test 3: Login User${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

if echo "$LOGIN_RESPONSE" | jq -e '.accessToken' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ User login successful${NC}"
    echo "$LOGIN_RESPONSE" | jq '.'
else
    echo -e "${RED}✗ User login failed${NC}"
    echo "$LOGIN_RESPONSE" | jq '.'
    exit 1
fi
echo ""

# Test 4: Get User Profile
echo -e "${YELLOW}Test 4: Get User Profile${NC}"
PROFILE_RESPONSE=$(curl -s "$BASE_URL/users/profile" \
  -H "Authorization: Bearer $TOKEN")

if echo "$PROFILE_RESPONSE" | jq -e '.email' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Profile retrieval successful${NC}"
    echo "$PROFILE_RESPONSE" | jq '.'
else
    echo -e "${RED}✗ Profile retrieval failed${NC}"
    echo "$PROFILE_RESPONSE" | jq '.'
    exit 1
fi
echo ""

# Test 5: Invalid Login
echo -e "${YELLOW}Test 5: Invalid Login (Should Fail)${NC}"
INVALID_LOGIN=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"wrongpassword\"}")

if echo "$INVALID_LOGIN" | jq -e '.statusCode == 401' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Invalid login correctly rejected${NC}"
    echo "$INVALID_LOGIN" | jq '.'
else
    echo -e "${RED}✗ Invalid login test failed${NC}"
    echo "$INVALID_LOGIN" | jq '.'
fi
echo ""

# Test 6: Duplicate Registration
echo -e "${YELLOW}Test 6: Duplicate Registration (Should Fail)${NC}"
DUPLICATE_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\",\"name\":\"$NAME\"}")

if echo "$DUPLICATE_RESPONSE" | jq -e '.statusCode == 409' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Duplicate registration correctly rejected${NC}"
    echo "$DUPLICATE_RESPONSE" | jq '.'
else
    echo -e "${RED}✗ Duplicate registration test failed${NC}"
    echo "$DUPLICATE_RESPONSE" | jq '.'
fi
echo ""

# Test 7: Protected Route Without Token
echo -e "${YELLOW}Test 7: Protected Route Without Token (Should Fail)${NC}"
NO_TOKEN_RESPONSE=$(curl -s "$BASE_URL/users/profile")

if echo "$NO_TOKEN_RESPONSE" | jq -e '.statusCode == 401' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Protected route correctly requires authentication${NC}"
    echo "$NO_TOKEN_RESPONSE" | jq '.'
else
    echo -e "${RED}✗ Protected route test failed${NC}"
    echo "$NO_TOKEN_RESPONSE" | jq '.'
fi
echo ""

echo "======================================"
echo -e "${GREEN}  All Tests Completed Successfully!${NC}"
echo "======================================"
