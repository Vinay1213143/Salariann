# Salariann Setup Guide

Complete step-by-step guide to set up the Salariann platform locally.

## Prerequisites

- **Docker & Docker Compose** - For Supabase
- **Node.js 16+** - For backend
- **Flutter 3.0+** - For frontend
- **Git** - For version control

## Step 1: Clone and Navigate

```bash
cd /Users/bhaveshtayade/Desktop/salariann
```

## Step 2: Setup Supabase (Self-Hosted)

### 2.1 Configure Environment

```bash
cd supabase
cp .env.example .env
```

### 2.2 Edit .env with Your Configuration

Key variables to update:
```
POSTGRES_PASSWORD=your-secure-password
JWT_SECRET=your-jwt-secret-min-32-chars
ANON_KEY=your-anon-key
SERVICE_ROLE_KEY=your-service-role-key
```

Generate secure keys:
```bash
cd supabase/utils
sh generate-keys.sh
```

### 2.3 Start Supabase

```bash
docker compose up -d
```

Wait for all services to be healthy (2-3 minutes):
```bash
docker compose ps
```

### 2.4 Access Supabase Studio

- URL: `http://localhost:3000`
- Username: `supabase` (from .env)
- Password: `this_password_is_insecure_and_should_be_updated` (from .env)

### 2.5 Verify Database Schema

The schema is automatically applied via `volumes/db/salariann-init.sql`. Check:
1. Go to SQL Editor in Studio
2. Run: `SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';`
3. Verify all 8 tables exist

## Step 3: Setup Backend

### 3.1 Install Dependencies

```bash
cd ../backend
npm install
```

### 3.2 Configure Environment

```bash
cp .env.example .env
```

### 3.3 Update .env with Supabase Credentials

```
PORT=3001
NODE_ENV=development
SUPABASE_URL=http://localhost:8000
SUPABASE_ANON_KEY=<copy from supabase/.env>
SUPABASE_SERVICE_ROLE_KEY=<copy from supabase/.env>
JWT_SECRET=<copy from supabase/.env>
```

### 3.4 Start Backend

```bash
npm run dev
```

Expected output:
```
Salariann backend running on port 3001
```

### 3.5 Test Backend

```bash
curl http://localhost:3001/api/health
# Should return: {"status":"ok"}
```

## Step 4: Setup Flutter Frontend

### 4.1 Create Flutter Project Structure

```bash
cd ../frontend
flutter pub get
```

### 4.2 Verify Flutter Installation

```bash
flutter doctor
```

All checks should pass (or show optional warnings).

### 4.3 Run on Web (Chrome)

```bash
flutter run -d chrome
```

The app will open at `http://localhost:54321` (or similar)

### 4.4 Run on Mobile Emulator

```bash
# For Android
flutter emulators --launch Pixel_4_API_30
flutter run

# For iOS
open -a Simulator
flutter run
```

## Step 5: Verify Full Stack

### 5.1 Test Landing Page
- Navigate to `http://localhost:54321`
- Should see Salariann landing page with search and city cards

### 5.2 Test Job Listing
- Click "Browse Jobs" or navigate to `/jobs`
- Should see empty list (no jobs seeded yet)

### 5.3 Test Authentication
- Click "Sign In"
- Create a test account
- Verify you can sign in and access profile

### 5.4 Test Backend API
```bash
# Get jobs
curl http://localhost:3001/api/jobs

# Get companies
curl http://localhost:3001/api/companies

# Get health
curl http://localhost:3001/api/health
```

## Step 6: Seed Sample Data (Optional)

### 6.1 Add Sample Jobs via Supabase Studio

1. Go to `http://localhost:3000` (Supabase Studio)
2. Navigate to SQL Editor
3. Run:

```sql
INSERT INTO public.jobs (company_id, title, description, city, annual_ctc_min, annual_ctc_max, tech_stack, ats_url, is_active)
SELECT 
  id,
  'Senior Software Engineer',
  'We are looking for experienced software engineers...',
  'Bangalore',
  1500000,
  2500000,
  ARRAY['Python', 'Django', 'PostgreSQL'],
  'https://example.com/apply',
  true
FROM public.companies
LIMIT 1;
```

### 6.2 Refresh Frontend

- Go back to Flutter app
- Navigate to Jobs page
- Should see the newly created job

## Troubleshooting

### Supabase Won't Start

```bash
# Check Docker logs
docker compose logs -f

# Reset everything
docker compose down -v
docker compose up -d
```

### Backend Connection Error

```bash
# Verify Supabase is running
curl http://localhost:8000

# Check backend logs
npm run dev
```

### Flutter Build Issues

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d chrome
```

### Port Already in Use

```bash
# Kill process on port
lsof -ti:3001 | xargs kill -9  # Backend
lsof -ti:8000 | xargs kill -9  # Supabase
```

## Environment Variables Reference

### Backend (.env)
```
PORT=3001
NODE_ENV=development
SUPABASE_URL=http://localhost:8000
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
JWT_SECRET=your-super-secret-jwt-token-with-at-least-32-characters-long
```

### Supabase (.env)
```
POSTGRES_PASSWORD=your-super-secret-and-long-postgres-password
JWT_SECRET=your-super-secret-jwt-token-with-at-least-32-characters-long
ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_PUBLIC_URL=http://localhost:8000
API_EXTERNAL_URL=http://localhost:8000
SITE_URL=http://localhost:3000
```

## Next Steps

1. **Add More Sample Data** - Use Supabase Studio to add companies and jobs
2. **Test Features** - Try creating reviews, contributing salary data
3. **Customize Theme** - Edit `frontend/lib/theme/app_theme.dart`
4. **Deploy** - Follow deployment guides for each service

## Support

For issues:
1. Check Docker logs: `docker compose logs`
2. Check backend logs: `npm run dev`
3. Check Flutter logs: `flutter run -v`
4. Check Supabase status: `http://localhost:3000`

## Useful Commands

```bash
# Supabase
docker compose up -d          # Start
docker compose down           # Stop
docker compose logs -f        # View logs
docker compose ps             # Check status

# Backend
npm run dev                   # Start dev server
npm install                   # Install dependencies
npm test                      # Run tests (if configured)

# Flutter
flutter pub get               # Get dependencies
flutter run -d chrome         # Run on web
flutter build web             # Build for production
flutter clean                 # Clean build artifacts
```

## Architecture Overview

```
User Browser (Flutter Web)
        ↓
   GoRouter (Navigation)
        ↓
   Provider (State Management)
        ↓
   HTTP Client (API Calls)
        ↓
   Node.js Express Backend
        ↓
   Supabase Client
        ↓
   PostgreSQL Database
```

## File Structure

```
salariann/
├── supabase/
│   ├── docker-compose.yml
│   ├── .env.example
│   └── volumes/
│       └── db/
│           └── salariann-init.sql
├── backend/
│   ├── package.json
│   ├── .env.example
│   └── src/
│       ├── index.js
│       ├── config/
│       ├── controllers/
│       ├── middleware/
│       ├── routes/
│       └── utils/
├── frontend/
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── config/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   ├── theme/
│   │   └── widgets/
│   └── web/
├── README.md
├── SETUP.md
└── .gitignore
```

Happy coding! 🚀
