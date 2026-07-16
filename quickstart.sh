#!/bin/bash

set -e

echo "🚀 Salariann Quick Start"
echo "========================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo -e "${GREEN}✓ All prerequisites found${NC}"
echo ""

# Step 1: Verify Supabase Cloud Configuration
echo -e "${BLUE}Step 1: Verifying Supabase Cloud Configuration...${NC}"
echo -e "${GREEN}✓ Using Supabase Cloud (https://ayvwifmobthpievoyzsx.supabase.co)${NC}"
echo -e "${YELLOW}⚠️  Ensure database schema is set up in Supabase Dashboard${NC}"
echo ""

# Step 2: Setup Backend
echo -e "${BLUE}Step 2: Setting up Backend...${NC}"
cd backend

if [ ! -f .env ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Please ensure .env has correct Supabase credentials${NC}"
fi

echo "Installing dependencies..."
npm install

echo -e "${GREEN}✓ Backend setup complete${NC}"
echo ""
echo -e "${YELLOW}To start backend, run: cd backend && npm start${NC}"
echo ""

cd ..

# Step 3: Setup Frontend
echo -e "${BLUE}Step 3: Setting up Frontend...${NC}"
cd frontend

echo "Getting Flutter dependencies..."
flutter pub get

echo -e "${GREEN}✓ Frontend setup complete${NC}"
echo ""
echo -e "${YELLOW}To start frontend, run: cd frontend && flutter run -d chrome${NC}"
echo ""

cd ..

# Summary
echo ""
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Start Backend:"
echo "   cd backend && npm start"
echo "   - Backend API: http://localhost:3001"
echo ""
echo "2. Start Frontend:"
echo "   cd frontend && flutter run -d chrome"
echo "   - App: http://localhost:5000"
echo ""
echo "3. Access Supabase Cloud:"
echo "   - URL: https://app.supabase.com"
echo "   - Project: ayvwifmobthpievoyzsx"
echo ""
echo "For detailed setup instructions, see SUPABASE_CLOUD_SETUP.md"
echo ""
