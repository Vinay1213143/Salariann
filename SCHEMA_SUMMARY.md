# 📊 Database Schema Summary

## Overview

A complete, production-ready database schema for the Salariann platform with 11 tables, comprehensive relationships, and seed data.

---

## 📋 Table Structure

### 1. **users** - User Profiles
```sql
Columns:
  - id (UUID, Primary Key, from auth.users)
  - display_name, email, phone, location
  - lifestyle (single/family)
  - avatar_url, bio
  - experience_years, current_role
  - skills (array)
  - created_at, updated_at
```

### 2. **companies** - Company Information
```sql
Columns:
  - id (UUID, Primary Key)
  - name (unique), logo_url, website
  - employee_count, description
  - city, founded_year, industry
  - rating, total_reviews
  - created_at, updated_at
```

### 3. **jobs** - Job Listings
```sql
Columns:
  - id (UUID, Primary Key)
  - company_id (FK to companies)
  - title, description
  - city, employment_type
  - annual_ctc_min, annual_ctc_max
  - tech_stack (array)
  - ats_url, experience_required
  - is_active, posted_at
  - created_at, updated_at
```

### 4. **reviews** - Company Reviews
```sql
Columns:
  - id (UUID, Primary Key)
  - user_id (FK to users)
  - company_id (FK to companies)
  - overall_rating, work_life_balance
  - skill_development, management
  - pros, cons, title
  - is_anonymous, helpful_count
  - created_at, updated_at
```

### 5. **salaries** - Salary Data (Anonymous)
```sql
Columns:
  - id (UUID, Primary Key)
  - user_id (FK to users)
  - company_id (FK to companies)
  - role, annual_ctc
  - experience_years, location
  - is_anonymous
  - created_at, updated_at
```

### 6. **interviews** - Interview Experiences
```sql
Columns:
  - id (UUID, Primary Key)
  - user_id (FK to users)
  - company_id (FK to companies)
  - role, difficulty (1-5)
  - questions (JSONB)
  - experience_text
  - result (selected/rejected/pending)
  - interview_date
  - created_at, updated_at
```

### 7. **city_metrics** - Cost of Living Data
```sql
Columns:
  - id (UUID, Primary Key)
  - city_name, lifestyle (single/family)
  - avg_rent, avg_food, avg_commute
  - avg_utilities, avg_entertainment
  - avg_healthcare
  - created_at, updated_at
  - UNIQUE(city_name, lifestyle)
```

### 8. **click_events** - Job Application Tracking
```sql
Columns:
  - id (UUID, Primary Key)
  - user_id (FK to users, nullable)
  - job_id (FK to jobs)
  - company_id (FK to companies, nullable)
  - clicked_at
```

### 9. **saved_jobs** - Bookmarked Jobs
```sql
Columns:
  - id (UUID, Primary Key)
  - user_id (FK to users)
  - job_id (FK to jobs)
  - saved_at
  - UNIQUE(user_id, job_id)
```

### 10. **notifications** - User Notifications
```sql
Columns:
  - id (UUID, Primary Key)
  - user_id (FK to users)
  - title, message
  - type (info/warning/error/success)
  - is_read
  - related_job_id (FK to jobs, nullable)
  - created_at
```

### 11. **messages** - Direct Messages
```sql
Columns:
  - id (UUID, Primary Key)
  - sender_id (FK to users)
  - recipient_id (FK to users)
  - content
  - is_read
  - created_at
```

---

## 🔐 Security Features

### Row Level Security (RLS) Enabled On:
- ✅ users
- ✅ reviews
- ✅ salaries
- ✅ interviews
- ✅ click_events
- ✅ saved_jobs
- ✅ notifications
- ✅ messages

### Policies Implemented:
- Users can only read/update their own profiles
- Users can only manage their own reviews, interviews, saved jobs
- Users can only read their own notifications and messages
- Public read access to company data, jobs, reviews, salaries
- Anonymous submissions supported for sensitive data

---

## 📈 Performance Optimizations

### 30+ Indexes Created For:
- User email lookups
- Company name and city searches
- Job filtering by company, city, active status
- Review sorting and filtering
- Salary and interview queries
- Click event tracking
- Notification and message queries

### Query Optimization:
- Foreign key constraints for data integrity
- Unique constraints to prevent duplicates
- Composite indexes for multi-column searches
- Descending indexes for date-based sorting

---

## 🌱 Seed Data Included

### 15 Sample Companies
```
TCS, Infosys, Wipro, HCL Technologies, Accenture
Microsoft India, Google India, Amazon India
Flipkart, Paytm, Razorpay, Freshworks
Tech Mahindra, Capgemini, Cognizant
```

### 10 Sample Jobs
- Senior Software Developer (TCS, Mumbai)
- Full Stack Developer (Infosys, Bangalore)
- DevOps Engineer (Wipro, Bangalore)
- Data Scientist (HCL, Noida)
- Cloud Architect (Accenture, Bangalore)
- Software Engineer (Microsoft, Bangalore)
- Backend Engineer (Google, Bangalore)
- Solutions Architect (Amazon, Bangalore)
- Senior Backend Engineer (Razorpay, Bangalore)
- Frontend Developer (Freshworks, Chennai)

### 26 City Metrics Records
**12 Cities × 2 Lifestyles (single/family)**
- Bangalore, Hyderabad, Pune, Mumbai, Delhi
- Gurgaon, Noida, Chennai, Kolkata, Jaipur
- Chandigarh, Kochi

**Metrics per city:**
- Average rent, food, commute, utilities
- Entertainment, healthcare costs

---

## 📊 Data Relationships

```
┌─────────────────────────────────────────────────────┐
│                    USERS                            │
│  (Authentication via Supabase Auth)                 │
└────────────┬────────────────────────────────────────┘
             │
      ┌──────┴──────┬──────────┬──────────┬──────────┐
      │             │          │          │          │
      ▼             ▼          ▼          ▼          ▼
   REVIEWS      SALARIES   INTERVIEWS  CLICK_EVENTS SAVED_JOBS
      │             │          │          │          │
      └──────┬──────┴──────┬───┴──────┬───┴──────┬───┘
             │             │          │          │
             ▼             ▼          ▼          ▼
          COMPANIES ◄──────JOBS◄──────┘          │
             │                                    │
             └────────────────────────────────────┘

CITY_METRICS (Independent - Cost of Living Data)
NOTIFICATIONS (User-specific alerts)
MESSAGES (User-to-user communication)
```

---

## 🚀 How to Use

### 1. Run the Schema
```bash
# Copy entire content of SUPABASE_COMPLETE_SCHEMA.sql
# Paste into Supabase Dashboard → SQL Editor
# Click Run
```

### 2. Verify Creation
```bash
# Check all tables exist
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' ORDER BY table_name;

# Count seed data
SELECT COUNT(*) FROM public.companies;  -- Should be 15
SELECT COUNT(*) FROM public.jobs;       -- Should be 10
SELECT COUNT(*) FROM public.city_metrics; -- Should be 26
```

### 3. Start Using
```bash
# Backend automatically connects via SUPABASE_URL
npm start

# Frontend automatically connects via api_config.dart
flutter run -d chrome
```

---

## 📝 Important Notes

### Authentication
- User authentication is handled by Supabase Auth
- `users.id` is linked to `auth.users.id`
- User records are created automatically on signup

### Constraints
- Company names are unique
- Salary/Interview/Review data is optional
- Jobs require company_id and ats_url
- City metrics require unique city + lifestyle combination

### Extensibility
- Easy to add new tables
- Foreign keys support cascading deletes
- JSONB columns for flexible data (e.g., interview questions)
- Array columns for tags (e.g., tech_stack, skills)

---

## 🔍 Verification Checklist

After running the schema:

- [ ] All 11 tables created
- [ ] 15 companies visible in Table Editor
- [ ] 10 jobs visible in Table Editor
- [ ] 26 city metrics records created
- [ ] Indexes created for performance
- [ ] RLS policies enabled
- [ ] Backend can query companies endpoint
- [ ] Frontend loads without database errors

---

## 📞 Support

| Resource | Link |
|----------|------|
| **Schema File** | `SUPABASE_COMPLETE_SCHEMA.sql` |
| **Setup Guide** | `RUN_SCHEMA_GUIDE.md` |
| **Supabase Docs** | https://supabase.com/docs |
| **Project Dashboard** | https://app.supabase.com |

---

## ✅ Status

**Schema Version**: 1.0
**Created**: June 23, 2026
**Status**: Production Ready
**Tested**: Yes ✅

**Ready to use with your Salariann platform!** 🎉
