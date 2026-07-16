# ⚡ Quick Schema Reference Card

## 🎯 One-Minute Setup

```bash
1. Go to: https://app.supabase.com
2. Select: ayvwifmobthpievoyzsx
3. Click: SQL Editor → New Query
4. Paste: SUPABASE_COMPLETE_SCHEMA.sql
5. Click: Run
6. Done! ✅
```

---

## 📊 11 Tables at a Glance

| Table | Purpose | Records | Key Fields |
|-------|---------|---------|-----------|
| **users** | Profiles | 0 | id, email, display_name |
| **companies** | Company Info | 15 | id, name, city |
| **jobs** | Job Listings | 10 | id, company_id, title |
| **reviews** | Ratings | 0 | user_id, company_id, rating |
| **salaries** | Pay Data | 0 | user_id, company_id, annual_ctc |
| **interviews** | Interview XP | 0 | user_id, company_id, result |
| **city_metrics** | Cost of Living | 26 | city_name, lifestyle |
| **click_events** | Tracking | 0 | user_id, job_id |
| **saved_jobs** | Bookmarks | 0 | user_id, job_id |
| **notifications** | Alerts | 0 | user_id, title |
| **messages** | DMs | 0 | sender_id, recipient_id |

---

## 🔑 Key Relationships

```
users ──┬─→ reviews ──┐
        ├─→ salaries ─┼─→ companies ──→ jobs
        ├─→ interviews┤
        ├─→ click_events ──┐
        ├─→ saved_jobs ────┘
        ├─→ notifications
        └─→ messages
```

---

## 🌍 Seed Data

**Companies**: TCS, Infosys, Wipro, HCL, Accenture, Microsoft, Google, Amazon, Flipkart, Paytm, Razorpay, Freshworks, Tech Mahindra, Capgemini, Cognizant

**Jobs**: 10 sample positions across different roles and cities

**Cities**: Bangalore, Hyderabad, Pune, Mumbai, Delhi, Gurgaon, Noida, Chennai, Kolkata, Jaipur, Chandigarh, Kochi

---

## 🔐 Security

✅ RLS enabled on: users, reviews, salaries, interviews, click_events, saved_jobs, notifications, messages

✅ Users can only access their own data

✅ Public read access to companies, jobs, reviews

---

## ⚙️ Performance

✅ 30+ indexes for fast queries

✅ Optimized for common searches

✅ Efficient relationships with foreign keys

---

## 🚀 After Schema Creation

```bash
# Terminal 1: Backend
cd backend && npm start

# Terminal 2: Frontend
cd frontend && flutter run -d chrome

# Test
curl http://localhost:3001/api/companies
```

---

## 📋 Verification

```sql
-- Count records
SELECT COUNT(*) FROM public.companies;  -- 15
SELECT COUNT(*) FROM public.jobs;       -- 10
SELECT COUNT(*) FROM public.city_metrics; -- 26
```

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| "relation already exists" | Schema already created |
| "permission denied" | Check project ownership |
| "invalid syntax" | Copy entire file again |
| Tables not showing | Refresh browser |

---

## 📚 Files

| File | Purpose |
|------|---------|
| `SUPABASE_COMPLETE_SCHEMA.sql` | The actual SQL to run |
| `RUN_SCHEMA_GUIDE.md` | Step-by-step instructions |
| `SCHEMA_SUMMARY.md` | Detailed documentation |
| `QUICK_SCHEMA_REFERENCE.md` | This file |

---

## ✅ Checklist

- [ ] Schema file copied
- [ ] Pasted into Supabase SQL Editor
- [ ] Query executed successfully
- [ ] All 11 tables visible in Table Editor
- [ ] Seed data verified (15 companies, 10 jobs, 26 city metrics)
- [ ] Backend started
- [ ] Frontend started
- [ ] APIs returning data

---

## 🎉 You're Done!

Your Salariann database is ready to use with:
- ✅ Complete schema
- ✅ Sample data
- ✅ Security policies
- ✅ Performance indexes

**Start building!** 🚀
