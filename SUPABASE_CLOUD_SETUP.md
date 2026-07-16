# Supabase Cloud Migration Guide

## ✅ Configuration Files Updated

Your backend and frontend have been updated with the new Supabase Cloud credentials:

- **Backend**: `/backend/.env`
- **Frontend**: `/frontend/lib/config/api_config.dart`

## 📋 Database Setup Instructions

### Step 1: Access Supabase SQL Editor

1. Go to https://app.supabase.com
2. Select your project: **ayvwifmobthpievoyzsx**
3. Click **SQL Editor** in the left sidebar
4. Click **New Query**

### Step 2: Create Database Schema

Copy and paste the entire SQL below into the SQL Editor and click **Run**:

```sql
-- Salariann Platform Schema
-- Core tables for job market platform with cost-of-living calculator

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name VARCHAR(255),
  lifestyle VARCHAR(50) DEFAULT 'single' CHECK (lifestyle IN ('single', 'family')),
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Companies table
CREATE TABLE IF NOT EXISTS public.companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  logo_url TEXT,
  website TEXT,
  employee_count INTEGER,
  description TEXT,
  city VARCHAR(100),
  founded_year INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Jobs table
CREATE TABLE IF NOT EXISTS public.jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  city VARCHAR(100) NOT NULL,
  annual_ctc_min DECIMAL(12, 2),
  annual_ctc_max DECIMAL(12, 2),
  tech_stack TEXT[],
  ats_url TEXT NOT NULL,
  posted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Reviews table
CREATE TABLE IF NOT EXISTS public.reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  overall_rating DECIMAL(3, 2) CHECK (overall_rating >= 1 AND overall_rating <= 5),
  work_life_balance DECIMAL(3, 2) CHECK (work_life_balance >= 1 AND work_life_balance <= 5),
  skill_development DECIMAL(3, 2) CHECK (skill_development >= 1 AND skill_development <= 5),
  management DECIMAL(3, 2) CHECK (management >= 1 AND management <= 5),
  pros TEXT,
  cons TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Salaries table (anonymous contribution)
CREATE TABLE IF NOT EXISTS public.salaries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  role VARCHAR(255) NOT NULL,
  annual_ctc DECIMAL(12, 2) NOT NULL,
  experience_years INTEGER,
  is_anonymous BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Interviews table
CREATE TABLE IF NOT EXISTS public.interviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  role VARCHAR(255) NOT NULL,
  difficulty INTEGER CHECK (difficulty >= 1 AND difficulty <= 5),
  questions JSONB,
  experience_text TEXT,
  result VARCHAR(50) CHECK (result IN ('selected', 'rejected', 'pending')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- City Metrics table (baseline cost of living data)
CREATE TABLE IF NOT EXISTS public.city_metrics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  city_name VARCHAR(100) NOT NULL UNIQUE,
  avg_rent DECIMAL(10, 2) NOT NULL,
  avg_food DECIMAL(10, 2) NOT NULL,
  avg_commute DECIMAL(10, 2) NOT NULL,
  avg_utilities DECIMAL(10, 2) NOT NULL,
  lifestyle VARCHAR(50) DEFAULT 'single' CHECK (lifestyle IN ('single', 'family')),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Click Events table (ATS redirect tracking)
CREATE TABLE IF NOT EXISTS public.click_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  job_id UUID NOT NULL REFERENCES public.jobs(id) ON DELETE CASCADE,
  clicked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_jobs_company_id ON public.jobs(company_id);
CREATE INDEX IF NOT EXISTS idx_jobs_city ON public.jobs(city);
CREATE INDEX IF NOT EXISTS idx_jobs_is_active ON public.jobs(is_active);
CREATE INDEX IF NOT EXISTS idx_reviews_company_id ON public.reviews(company_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_salaries_company_id ON public.salaries(company_id);
CREATE INDEX IF NOT EXISTS idx_interviews_company_id ON public.interviews(company_id);
CREATE INDEX IF NOT EXISTS idx_city_metrics_city ON public.city_metrics(city_name);
CREATE INDEX IF NOT EXISTS idx_click_events_job_id ON public.click_events(job_id);
CREATE INDEX IF NOT EXISTS idx_click_events_user_id ON public.click_events(user_id);

-- Row Level Security (RLS) Policies
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.salaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.click_events ENABLE ROW LEVEL SECURITY;

-- Users can read all users
CREATE POLICY "Users can read all users" ON public.users FOR SELECT USING (true);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);

-- Users can read all reviews
CREATE POLICY "Reviews are readable by all" ON public.reviews FOR SELECT USING (true);

-- Users can insert reviews
CREATE POLICY "Users can insert reviews" ON public.reviews FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update own reviews
CREATE POLICY "Users can update own reviews" ON public.reviews FOR UPDATE USING (auth.uid() = user_id);

-- Users can read all salaries
CREATE POLICY "Salaries are readable by all" ON public.salaries FOR SELECT USING (true);

-- Users can insert salaries
CREATE POLICY "Users can insert salaries" ON public.salaries FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can read all interviews
CREATE POLICY "Interviews are readable by all" ON public.interviews FOR SELECT USING (true);

-- Users can insert interviews
CREATE POLICY "Users can insert interviews" ON public.interviews FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update own interviews
CREATE POLICY "Users can update own interviews" ON public.interviews FOR UPDATE USING (auth.uid() = user_id);

-- Users can insert click events
CREATE POLICY "Users can insert click events" ON public.click_events FOR INSERT WITH CHECK (true);

-- Seed data: City Metrics (baseline cost of living for major Indian IT hubs)
INSERT INTO public.city_metrics (city_name, avg_rent, avg_food, avg_commute, avg_utilities, lifestyle) VALUES
('Bangalore', 15000, 8000, 2000, 2500, 'single'),
('Bangalore', 25000, 12000, 3000, 3500, 'family'),
('Hyderabad', 12000, 7000, 1500, 2000, 'single'),
('Hyderabad', 20000, 10000, 2500, 3000, 'family'),
('Pune', 11000, 6500, 1500, 1800, 'single'),
('Pune', 18000, 9500, 2500, 2800, 'family'),
('Mumbai', 20000, 9000, 2500, 3000, 'single'),
('Mumbai', 35000, 13000, 4000, 4500, 'family'),
('Delhi', 15000, 7500, 2000, 2500, 'single'),
('Delhi', 25000, 11000, 3500, 3500, 'family'),
('Gurgaon', 16000, 8000, 2000, 2500, 'single'),
('Gurgaon', 26000, 12000, 3500, 3500, 'family'),
('Noida', 12000, 7000, 1500, 2000, 'single'),
('Noida', 20000, 10000, 2500, 3000, 'family'),
('Chennai', 10000, 6000, 1500, 1500, 'single'),
('Chennai', 16000, 9000, 2500, 2500, 'family'),
('Kolkata', 8000, 5000, 1000, 1200, 'single'),
('Kolkata', 13000, 7500, 2000, 2000, 'family');

-- Seed data: Sample companies
INSERT INTO public.companies (name, logo_url, website, employee_count, description, city, founded_year) VALUES
('TCS', 'https://via.placeholder.com/150', 'https://www.tcs.com', 500000, 'Tata Consultancy Services - Leading IT services company', 'Mumbai', 1968),
('Infosys', 'https://via.placeholder.com/150', 'https://www.infosys.com', 300000, 'Infosys Limited - Global IT consulting and services', 'Bangalore', 1981),
('Wipro', 'https://via.placeholder.com/150', 'https://www.wipro.com', 250000, 'Wipro Limited - IT services and consulting', 'Bangalore', 1980),
('HCL Technologies', 'https://via.placeholder.com/150', 'https://www.hcltech.com', 200000, 'HCL Technologies - IT services and software solutions', 'Noida', 1976),
('Accenture', 'https://via.placeholder.com/150', 'https://www.accenture.com', 150000, 'Accenture - Global professional services company', 'Bangalore', 1989),
('Cognizant', 'https://via.placeholder.com/150', 'https://www.cognizant.com', 300000, 'Cognizant Technology Solutions - IT services', 'Bangalore', 1994),
('Tech Mahindra', 'https://via.placeholder.com/150', 'https://www.techmahindra.com', 150000, 'Tech Mahindra - IT services and consulting', 'Pune', 1986),
('Capgemini', 'https://via.placeholder.com/150', 'https://www.capgemini.com', 100000, 'Capgemini - Global IT consulting and services', 'Bangalore', 1967);
```

### Step 3: Verify Tables Created

After running the SQL, go to **Table Editor** in the left sidebar and verify these tables exist:
- ✅ users
- ✅ companies
- ✅ jobs
- ✅ reviews
- ✅ salaries
- ✅ interviews
- ✅ city_metrics
- ✅ click_events

## 🚀 Restart Services

Once the database is set up, restart your services:

```bash
# Kill old backend process
lsof -ti :3001 | xargs kill -9

# Restart backend
cd /Users/bhaveshtayade/Desktop/salariann/backend
npm start

# In another terminal, rebuild Flutter
cd /Users/bhaveshtayade/Desktop/salariann/frontend
flutter clean
flutter pub get
flutter run -d chrome
```

## ✨ Verify Connection

Test the connection by checking:

1. **Backend Health**: `curl http://localhost:3001/api/health`
   - Should return: `{"status":"ok"}`

2. **Jobs API**: `curl http://localhost:3001/api/jobs`
   - Should return job data from Supabase Cloud

3. **Flutter App**: Open http://localhost:5000
   - Should load without database errors

## 🔐 Security Notes

- **Anon Key**: Safe to use in frontend (public)
- **Service Role Key**: Keep secret (backend only) ✅
- **Never commit** `.env` files with real keys to Git
- Consider using GitHub Secrets for CI/CD

## 📊 Project Details

- **Project ID**: ayvwifmobthpievoyzsx
- **Project URL**: https://ayvwifmobthpievoyzsx.supabase.co
- **Region**: (Check in Supabase Dashboard)

---

**Migration complete!** Your app is now using Supabase Cloud instead of self-hosted.
