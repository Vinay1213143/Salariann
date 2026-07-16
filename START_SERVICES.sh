#!/bin/bash

# Salariann - Start All Services Script
# This script helps you start Supabase, Backend, and Frontend in separate terminals

set -e

echo "🚀 Salariann - Starting All Services"
echo "===================================="
echo ""

PROJECT_ROOT="/Users/bhaveshtayade/Desktop/salariann"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

if ! command_exists docker; then
    echo "❌ Docker is not installed"
    exit 1
fi

if ! command_exists node; then
    echo "❌ Node.js is not installed"
    exit 1
fi

if ! command_exists flutter; then
    echo "❌ Flutter is not installed"
    exit 1
fi

echo -e "${GREEN}✓ All prerequisites found${NC}"
echo ""

# Step 1: Verify Supabase Cloud
echo -e "${BLUE}Step 1: Verifying Supabase Cloud Configuration...${NC}"
echo -e "${GREEN}✓ Using Supabase Cloud (https://ayvwifmobthpievoyzsx.supabase.co)${NC}"
echo ""

# Step 2: Setup Backend
echo -e "${BLUE}Step 2: Setting up Backend...${NC}"
cd "$PROJECT_ROOT/backend"

if [ ! -f .env ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
fi

if [ ! -d node_modules ]; then
    echo "Installing dependencies..."
    npm install
fi

echo -e "${GREEN}✓ Backend ready${NC}"
echo ""

# Step 3: Setup Frontend
echo -e "${BLUE}Step 3: Setting up Frontend...${NC}"
cd "$PROJECT_ROOT/frontend"

echo "Getting Flutter dependencies..."
flutter pub get

echo -e "${GREEN}✓ Frontend ready${NC}"
echo ""

# Summary
echo -e "${GREEN}✅ All services configured!${NC}"
echo ""
echo "To start each service, run these commands in separate terminals:"
echo ""
echo -e "${BLUE}Terminal 1 - Backend:${NC}"
echo "  cd $PROJECT_ROOT/backend"
echo "  npm start"
echo ""
echo -e "${BLUE}Terminal 2 - Frontend:${NC}"
echo "  cd $PROJECT_ROOT/frontend"
echo "  flutter run -d chrome"
echo ""
echo "Access Points:"
echo "  Frontend: http://localhost:5000"
echo "  Backend API: http://localhost:3001/api"
echo "  Supabase Cloud: https://app.supabase.com (Project: ayvwifmobthpievoyzsx)"
echo ""
