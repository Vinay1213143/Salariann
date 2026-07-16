# 🚀 How to Run the Database Schema on Supabase Cloud

## Quick Setup (5 minutes)

### Step 1: Open Supabase Dashboard
1. Go to: https://app.supabase.com
2. Sign in with your account
3. Select project: **ayvwifmobthpievoyzsx**

### Step 2: Open SQL Editor
1. Click **SQL Editor** in the left sidebar
2. Click **New Query** button

### Step 3: Copy & Paste Schema
1. Open file: `SUPABASE_COMPLETE_SCHEMA.sql`
2. Copy **entire content**
3. Paste into Supabase SQL Editor
4. Click **Run** button

### Step 4: Wait for Completion
- Schema creation takes 10-30 seconds
- You'll see: `Query executed successfully`
- All 11 tables will be created with seed data

### Step 5: Verify Tables Created
1. Click **Table Editor** in left sidebar
2. Confirm these tables exist:
   - ✅ users
   - ✅ companies
   - ✅ jobs
   - ✅ reviews
   - ✅ salaries
   - ✅ interviews
   - ✅ city_metrics
   - ✅ click_events
   - ✅ saved_jobs
   - ✅ notifications
   - ✅ messages

---

## What's Included in the Schema

### 11 Database Tables

| Table | Purpose | Records |
|-------|---------|---------|
| **users** | User profiles & authentication | 0 (auto-created on signup) |
| **companies** | Company information | 15 sample companies |
| **jobs** | Job listings | 10 sample jobs |
| **reviews** | Company reviews | 0 (user-generated) |
| **salaries** | Salary data (anonymous) | 0 (user-generated) |
| **interviews** | Interview experiences | 0 (user-generated) |
| **city_metrics** | Cost of living data | 26 records (12 cities × 2 lifestyles) |
| **click_events** | Job application tracking | 0 (auto-tracked) |
| **saved_jobs** | Bookmarked jobs | 0 (user-generated) |
| **notifications** | User notifications | 0 (auto-generated) |
| **messages** | Direct messages | 0 (user-generated) |

### Seed Data Included

✅ **15 Sample Companies**
- TCS, Infosys, Wipro, HCL, Accenture
- Microsoft India, Google India, Amazon India
- Flipkart, Paytm, Razorpay, Freshworks
- Tech Mahindra, Capgemini, Cognizant

✅ **10 Sample Jobs**
- Senior Software Developer (TCS)
- Full Stack Developer (Infosys)
- DevOps Engineer (Wipro)
- Data Scientist (HCL)
- Cloud Architect (Accenture)
- Software Engineer (Microsoft)
- Backend Engineer (Google)
- Solutions Architect (Amazon)
- Senior Backend Engineer (Razorpay)
- Frontend Developer (Freshworks)

✅ **26 City Metrics Records**
- Bangalore, Hyderabad, Pune, Mumbai, Delhi
- Gurgaon, Noida, Chennai, Kolkata, Jaipur
- Chandigarh, Kochi
- Each city has data for 'single' and 'family' lifestyles

---

## Schema Features

### 🔐 Security
- Row Level Security (RLS) enabled on sensitive tables
- Users can only access their own data
- Anonymous salary/interview submissions supported

### 📊 Performance
- 30+ indexes for fast queries
- Optimized for common search patterns
- Efficient foreign key relationships

### 🔗 Relationships
```
users
  ├── reviews (one-to-many)
  ├── salaries (one-to-many)
  ├── interviews (one-to-many)
  ├── click_events (one-to-many)
  ├── saved_jobs (one-to-many)
  ├── notifications (one-to-many)
  └── messages (one-to-many)

companies
  ├── jobs (one-to-many)
  ├── reviews (one-to-many)
  ├── salaries (one-to-many)
  └── interviews (one-to-many)

jobs
  ├── click_events (one-to-many)
  └── saved_jobs (one-to-many)
```

---

## Verification Query

After running the schema, you can verify everything with this query:

```sql
-- Count records in each table
SELECT 
  'users' as table_name, COUNT(*) as record_count FROM public.users
UNION ALL
SELECT 'companies', COUNT(*) FROM public.companies
UNION ALL
SELECT 'jobs', COUNT(*) FROM public.jobs
UNION ALL
SELECT 'city_metrics', COUNT(*) FROM public.city_metrics
UNION ALL
SELECT 'reviews', COUNT(*) FROM public.reviews
UNION ALL
SELECT 'salaries', COUNT(*) FROM public.salaries
UNION ALL
SELECT 'interviews', COUNT(*) FROM public.interviews
UNION ALL
SELECT 'click_events', COUNT(*) FROM public.click_events
UNION ALL
SELECT 'saved_jobs', COUNT(*) FROM public.saved_jobs
UNION ALL
SELECT 'notifications', COUNT(*) FROM public.notifications
UNION ALL
SELECT 'messages', COUNT(*) FROM public.messages
ORDER BY table_name;
```

**Expected Output:**
```
click_events    | 0
city_metrics    | 26
companies       | 15
interviews      | 0
jobs            | 10
messages        | 0
notifications   | 0
reviews         | 0
salaries        | 0
saved_jobs      | 0
users           | 0
```

---

## Troubleshooting

### ❌ Error: "relation already exists"
**Cause**: Schema was already created
**Solution**: Drop tables first or use a different project

### ❌ Error: "permission denied"
**Cause**: Insufficient permissions
**Solution**: Use a project where you're the owner

### ❌ Error: "invalid syntax"
**Cause**: Incomplete SQL copy-paste
**Solution**: Copy the entire file again, ensure no text is cut off

### ❌ Tables not showing in Table Editor
**Cause**: Page not refreshed
**Solution**: Refresh the browser (F5 or Cmd+R)

---

## Next Steps

### 1. Start Backend
```bash
cd /Users/bhaveshtayade/Desktop/salariann/backend
npm start
```

### 2. Start Frontend
```bash
cd /Users/bhaveshtayade/Desktop/salariann/frontend
flutter run -d chrome
```

### 3. Test the Application
```bash
# Test backend API
curl http://localhost:3001/api/companies
curl http://localhost:3001/api/jobs

# Open app
http://localhost:5000
```

---

## Database Credentials

| Property | Value |
|----------|-------|
| **Project URL** | https://ayvwifmobthpievoyzsx.supabase.co |
| **Project ID** | ayvwifmobthpievoyzsx |
| **Database** | postgres |
| **Schema** | public |
| **Access** | Via Supabase Dashboard |

---

## Support

- **Supabase Docs**: https://supabase.com/docs
- **Schema File**: `SUPABASE_COMPLETE_SCHEMA.sql`
- **Setup Guide**: `SUPABASE_CLOUD_SETUP.md`
- **Migration Info**: `MIGRATION_COMPLETE.md`

---

## ✅ You're All Set!

Once the schema is created, your Salariann platform is ready to use with:
- ✅ Complete database structure
- ✅ 15 sample companies
- ✅ 10 sample jobs
- ✅ Cost of living data for 12 Indian cities
- ✅ Secure authentication
- ✅ Row-level security

**Happy coding! 🚀**
