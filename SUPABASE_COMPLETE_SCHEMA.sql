-- ============================================================================
-- SALARIANN PLATFORM - COMPLETE DATABASE SCHEMA
-- For Supabase Cloud (Online)
-- ============================================================================
-- This SQL file creates the complete database schema for the Salariann platform
-- Run this in Supabase Dashboard → SQL Editor → New Query
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- 1. USERS TABLE (extends Supabase auth.users)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name VARCHAR(255),
  email VARCHAR(255),
  lifestyle VARCHAR(50) DEFAULT 'single' CHECK (lifestyle IN ('single', 'family')),
  avatar_url TEXT,
  bio TEXT,
  phone VARCHAR(20),
  location VARCHAR(100),
  experience_years INTEGER,
  current_job_title VARCHAR(255),
  skills TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 2. COMPANIES TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL UNIQUE,
  logo_url TEXT,
  website TEXT,
  employee_count INTEGER,
  description TEXT,
  city VARCHAR(100),
  founded_year INTEGER,
  industry VARCHAR(100),
  rating DECIMAL(3, 2),
  total_reviews INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 3. JOBS TABLE
-- ============================================================================
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
  employment_type VARCHAR(50) DEFAULT 'Full-time',
  experience_required INTEGER,
  posted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 4. REVIEWS TABLE
-- ============================================================================
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
  title VARCHAR(255),
  is_anonymous BOOLEAN DEFAULT false,
  helpful_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 5. SALARIES TABLE (anonymous contribution)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.salaries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  role VARCHAR(255) NOT NULL,
  annual_ctc DECIMAL(12, 2) NOT NULL,
  experience_years INTEGER,
  location VARCHAR(100),
  is_anonymous BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 6. INTERVIEWS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.interviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  company_id UUID NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  role VARCHAR(255) NOT NULL,
  difficulty INTEGER CHECK (difficulty >= 1 AND difficulty <= 5),
  questions JSONB,
  experience_text TEXT,
  result VARCHAR(50) CHECK (result IN ('selected', 'rejected', 'pending')),
  interview_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 7. CITY METRICS TABLE (baseline cost of living data)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.city_metrics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  city_name VARCHAR(100) NOT NULL,
  lifestyle VARCHAR(50) NOT NULL CHECK (lifestyle IN ('single', 'family')),
  avg_rent DECIMAL(10, 2) NOT NULL,
  avg_food DECIMAL(10, 2) NOT NULL,
  avg_commute DECIMAL(10, 2) NOT NULL,
  avg_utilities DECIMAL(10, 2) NOT NULL,
  avg_entertainment DECIMAL(10, 2) DEFAULT 2000,
  avg_healthcare DECIMAL(10, 2) DEFAULT 1500,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(city_name, lifestyle)
);

-- ============================================================================
-- 8. CLICK EVENTS TABLE (ATS redirect tracking)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.click_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  job_id UUID NOT NULL REFERENCES public.jobs(id) ON DELETE CASCADE,
  company_id UUID REFERENCES public.companies(id) ON DELETE SET NULL,
  clicked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 9. SAVED JOBS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.saved_jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  job_id UUID NOT NULL REFERENCES public.jobs(id) ON DELETE CASCADE,
  saved_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, job_id)
);

-- ============================================================================
-- 10. NOTIFICATIONS TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  message TEXT,
  type VARCHAR(50) DEFAULT 'info',
  is_read BOOLEAN DEFAULT false,
  related_job_id UUID REFERENCES public.jobs(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 11. MESSAGES TABLE
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  recipient_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON public.users(created_at);

CREATE INDEX IF NOT EXISTS idx_companies_name ON public.companies(name);
CREATE INDEX IF NOT EXISTS idx_companies_city ON public.companies(city);

CREATE INDEX IF NOT EXISTS idx_jobs_company_id ON public.jobs(company_id);
CREATE INDEX IF NOT EXISTS idx_jobs_city ON public.jobs(city);
CREATE INDEX IF NOT EXISTS idx_jobs_is_active ON public.jobs(is_active);
CREATE INDEX IF NOT EXISTS idx_jobs_posted_at ON public.jobs(posted_at DESC);

CREATE INDEX IF NOT EXISTS idx_reviews_company_id ON public.reviews(company_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON public.reviews(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_salaries_company_id ON public.salaries(company_id);
CREATE INDEX IF NOT EXISTS idx_salaries_user_id ON public.salaries(user_id);

CREATE INDEX IF NOT EXISTS idx_interviews_company_id ON public.interviews(company_id);
CREATE INDEX IF NOT EXISTS idx_interviews_user_id ON public.interviews(user_id);

CREATE INDEX IF NOT EXISTS idx_city_metrics_city ON public.city_metrics(city_name);

CREATE INDEX IF NOT EXISTS idx_click_events_job_id ON public.click_events(job_id);
CREATE INDEX IF NOT EXISTS idx_click_events_user_id ON public.click_events(user_id);

CREATE INDEX IF NOT EXISTS idx_saved_jobs_user_id ON public.saved_jobs(user_id);
CREATE INDEX IF NOT EXISTS idx_saved_jobs_job_id ON public.saved_jobs(job_id);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);

CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON public.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_recipient_id ON public.messages(recipient_id);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on sensitive tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.salaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.click_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Users can read all users
CREATE POLICY "Users can read all users" ON public.users FOR SELECT USING (true);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own user record
CREATE POLICY "Users can insert own profile" ON public.users FOR INSERT WITH CHECK (auth.uid() = id);

-- Reviews are readable by all
CREATE POLICY "Reviews are readable by all" ON public.reviews FOR SELECT USING (true);

-- Users can insert reviews
CREATE POLICY "Users can insert reviews" ON public.reviews FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update own reviews
CREATE POLICY "Users can update own reviews" ON public.reviews FOR UPDATE USING (auth.uid() = user_id);

-- Users can delete own reviews
CREATE POLICY "Users can delete own reviews" ON public.reviews FOR DELETE USING (auth.uid() = user_id);

-- Salaries are readable by all
CREATE POLICY "Salaries are readable by all" ON public.salaries FOR SELECT USING (true);

-- Users can insert salaries
CREATE POLICY "Users can insert salaries" ON public.salaries FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Interviews are readable by all
CREATE POLICY "Interviews are readable by all" ON public.interviews FOR SELECT USING (true);

-- Users can insert interviews
CREATE POLICY "Users can insert interviews" ON public.interviews FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update own interviews
CREATE POLICY "Users can update own interviews" ON public.interviews FOR UPDATE USING (auth.uid() = user_id);

-- Users can delete own interviews
CREATE POLICY "Users can delete own interviews" ON public.interviews FOR DELETE USING (auth.uid() = user_id);

-- Users can insert click events
CREATE POLICY "Users can insert click events" ON public.click_events FOR INSERT WITH CHECK (true);

-- Users can manage their saved jobs
CREATE POLICY "Users can manage own saved jobs" ON public.saved_jobs FOR ALL USING (auth.uid() = user_id);

-- Users can read their notifications
CREATE POLICY "Users can read own notifications" ON public.notifications FOR SELECT USING (auth.uid() = user_id);

-- Users can update their notifications
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING (auth.uid() = user_id);

-- Users can read their messages
CREATE POLICY "Users can read own messages" ON public.messages FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = recipient_id);

-- Users can insert messages
CREATE POLICY "Users can insert messages" ON public.messages FOR INSERT WITH CHECK (auth.uid() = sender_id);

-- ============================================================================
-- SEED DATA: CITY METRICS (Cost of Living for Indian IT Hubs)
-- ============================================================================
INSERT INTO public.city_metrics (city_name, lifestyle, avg_rent, avg_food, avg_commute, avg_utilities, avg_entertainment, avg_healthcare) VALUES
-- Bangalore
('Bangalore', 'single', 15000, 8000, 2000, 2500, 2500, 1500),
('Bangalore', 'family', 25000, 12000, 3000, 3500, 3500, 2000),

-- Hyderabad
('Hyderabad', 'single', 12000, 7000, 1500, 2000, 2000, 1200),
('Hyderabad', 'family', 20000, 10000, 2500, 3000, 3000, 1800),

-- Pune
('Pune', 'single', 11000, 6500, 1500, 1800, 2000, 1200),
('Pune', 'family', 18000, 9500, 2500, 2800, 3000, 1800),

-- Mumbai
('Mumbai', 'single', 20000, 9000, 2500, 3000, 3000, 2000),
('Mumbai', 'family', 35000, 13000, 4000, 4500, 4500, 2500),

-- Delhi
('Delhi', 'single', 15000, 7500, 2000, 2500, 2500, 1500),
('Delhi', 'family', 25000, 11000, 3500, 3500, 3500, 2000),

-- Gurgaon
('Gurgaon', 'single', 16000, 8000, 2000, 2500, 2500, 1500),
('Gurgaon', 'family', 26000, 12000, 3500, 3500, 3500, 2000),

-- Noida
('Noida', 'single', 12000, 7000, 1500, 2000, 2000, 1200),
('Noida', 'family', 20000, 10000, 2500, 3000, 3000, 1800),

-- Chennai
('Chennai', 'single', 10000, 6000, 1500, 1500, 1500, 1000),
('Chennai', 'family', 16000, 9000, 2500, 2500, 2500, 1500),

-- Kolkata
('Kolkata', 'single', 8000, 5000, 1000, 1200, 1200, 800),
('Kolkata', 'family', 13000, 7500, 2000, 2000, 2000, 1200),

-- Jaipur
('Jaipur', 'single', 9000, 5500, 1200, 1500, 1500, 1000),
('Jaipur', 'family', 15000, 8000, 2000, 2500, 2500, 1500),

-- Chandigarh
('Chandigarh', 'single', 10000, 6000, 1500, 1800, 1800, 1200),
('Chandigarh', 'family', 16000, 8500, 2500, 2800, 2800, 1800),

-- Kochi
('Kochi', 'single', 9000, 5500, 1200, 1500, 1500, 1000),
('Kochi', 'family', 15000, 8000, 2000, 2500, 2500, 1500);

-- ============================================================================
-- SEED DATA: SAMPLE COMPANIES
-- ============================================================================
INSERT INTO public.companies (name, logo_url, website, employee_count, description, city, founded_year, industry, rating, total_reviews) VALUES
('TCS', 'https://via.placeholder.com/150', 'https://www.tcs.com', 500000, 'Tata Consultancy Services - Leading IT services company', 'Mumbai', 1968, 'IT Services', 4.2, 1250),
('Infosys', 'https://via.placeholder.com/150', 'https://www.infosys.com', 300000, 'Infosys Limited - Global IT consulting and services', 'Bangalore', 1981, 'IT Services', 4.1, 980),
('Wipro', 'https://via.placeholder.com/150', 'https://www.wipro.com', 250000, 'Wipro Limited - IT services and consulting', 'Bangalore', 1980, 'IT Services', 4.0, 850),
('HCL Technologies', 'https://via.placeholder.com/150', 'https://www.hcltech.com', 200000, 'HCL Technologies - IT services and software solutions', 'Noida', 1976, 'IT Services', 3.9, 720),
('Accenture', 'https://via.placeholder.com/150', 'https://www.accenture.com', 150000, 'Accenture - Global professional services company', 'Bangalore', 1989, 'IT Services', 4.3, 1100),
('Cognizant', 'https://via.placeholder.com/150', 'https://www.cognizant.com', 300000, 'Cognizant Technology Solutions - IT services', 'Bangalore', 1994, 'IT Services', 4.0, 890),
('Tech Mahindra', 'https://via.placeholder.com/150', 'https://www.techmahindra.com', 150000, 'Tech Mahindra - IT services and consulting', 'Pune', 1986, 'IT Services', 3.8, 650),
('Capgemini', 'https://via.placeholder.com/150', 'https://www.capgemini.com', 100000, 'Capgemini - Global IT consulting and services', 'Bangalore', 1967, 'IT Services', 4.2, 950),
('Microsoft India', 'https://via.placeholder.com/150', 'https://www.microsoft.com/en-in', 50000, 'Microsoft India - Cloud and software solutions', 'Bangalore', 1990, 'Software', 4.5, 1500),
('Google India', 'https://via.placeholder.com/150', 'https://www.google.com', 40000, 'Google India - Search and advertising technology', 'Bangalore', 2004, 'Software', 4.6, 1800),
('Amazon India', 'https://via.placeholder.com/150', 'https://www.amazon.in', 60000, 'Amazon India - E-commerce and cloud services', 'Bangalore', 2004, 'E-commerce', 4.1, 1100),
('Flipkart', 'https://via.placeholder.com/150', 'https://www.flipkart.com', 40000, 'Flipkart - E-commerce platform', 'Bangalore', 2007, 'E-commerce', 3.7, 580),
('Paytm', 'https://via.placeholder.com/150', 'https://www.paytm.com', 25000, 'Paytm - Digital payments and fintech', 'Noida', 2010, 'Fintech', 3.5, 420),
('Razorpay', 'https://via.placeholder.com/150', 'https://razorpay.com', 1500, 'Razorpay - Payment gateway and fintech', 'Bangalore', 2014, 'Fintech', 4.4, 680),
('Freshworks', 'https://via.placeholder.com/150', 'https://www.freshworks.com', 3000, 'Freshworks - Customer engagement software', 'Chennai', 2010, 'SaaS', 4.3, 750);

-- ============================================================================
-- SEED DATA: SAMPLE JOBS
-- ============================================================================
INSERT INTO public.jobs (company_id, title, description, city, annual_ctc_min, annual_ctc_max, tech_stack, ats_url, employment_type, experience_required, is_active) VALUES
((SELECT id FROM public.companies WHERE name = 'TCS'), 'Senior Software Developer', 'We are looking for experienced software developers to join our team. 5+ years of experience required.', 'Mumbai', 1200000, 1800000, ARRAY['Java', 'Spring Boot', 'Microservices'], 'https://tcs.com/careers', 'Full-time', 5, true),
((SELECT id FROM public.companies WHERE name = 'Infosys'), 'Full Stack Developer', 'Develop and maintain web applications using modern tech stack. 3+ years experience.', 'Bangalore', 900000, 1400000, ARRAY['React', 'Node.js', 'MongoDB'], 'https://infosys.com/careers', 'Full-time', 3, true),
((SELECT id FROM public.companies WHERE name = 'Wipro'), 'DevOps Engineer', 'Manage cloud infrastructure and CI/CD pipelines. 4+ years experience.', 'Bangalore', 1100000, 1600000, ARRAY['AWS', 'Docker', 'Kubernetes'], 'https://wipro.com/careers', 'Full-time', 4, true),
((SELECT id FROM public.companies WHERE name = 'HCL Technologies'), 'Data Scientist', 'Build ML models and analyze large datasets. 3+ years experience.', 'Noida', 1000000, 1500000, ARRAY['Python', 'TensorFlow', 'SQL'], 'https://hcltech.com/careers', 'Full-time', 3, true),
((SELECT id FROM public.companies WHERE name = 'Accenture'), 'Cloud Architect', 'Design and implement cloud solutions. 6+ years experience.', 'Bangalore', 1500000, 2200000, ARRAY['AWS', 'Azure', 'GCP'], 'https://accenture.com/careers', 'Full-time', 6, true),
((SELECT id FROM public.companies WHERE name = 'Microsoft India'), 'Software Engineer', 'Build innovative cloud solutions at Microsoft. 2+ years experience.', 'Bangalore', 1300000, 1900000, ARRAY['C#', '.NET', 'Azure'], 'https://microsoft.com/careers', 'Full-time', 2, true),
((SELECT id FROM public.companies WHERE name = 'Google India'), 'Backend Engineer', 'Work on Google''s infrastructure and services. 3+ years experience.', 'Bangalore', 1600000, 2400000, ARRAY['Java', 'Go', 'Python'], 'https://google.com/careers', 'Full-time', 3, true),
((SELECT id FROM public.companies WHERE name = 'Amazon India'), 'Solutions Architect', 'Design AWS solutions for enterprise customers. 5+ years experience.', 'Bangalore', 1400000, 2000000, ARRAY['AWS', 'Java', 'Python'], 'https://amazon.com/careers', 'Full-time', 5, true),
((SELECT id FROM public.companies WHERE name = 'Razorpay'), 'Senior Backend Engineer', 'Build payment systems at scale. 4+ years experience.', 'Bangalore', 1200000, 1800000, ARRAY['Go', 'Node.js', 'PostgreSQL'], 'https://razorpay.com/careers', 'Full-time', 4, true),
((SELECT id FROM public.companies WHERE name = 'Freshworks'), 'Frontend Developer', 'Build beautiful UIs for SaaS products. 2+ years experience.', 'Chennai', 800000, 1300000, ARRAY['React', 'TypeScript', 'CSS'], 'https://freshworks.com/careers', 'Full-time', 2, true);

-- ============================================================================
-- VERIFY SCHEMA CREATION
-- ============================================================================
-- Run this query to verify all tables were created successfully:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;

-- ============================================================================
-- NOTES FOR USERS
-- ============================================================================
-- 1. All tables are created with proper relationships and constraints
-- 2. Row Level Security (RLS) is enabled on sensitive tables
-- 3. Indexes are created for optimal query performance
-- 4. Seed data includes 15 companies and 10 sample jobs
-- 5. City metrics are pre-populated for 12 Indian cities
-- 6. You can now start using the application!
-- ============================================================================
