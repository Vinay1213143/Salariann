# API Integration - Quick Reference

**All APIs Used in Salariann**

---

## 🎯 Three Main APIs

### 1️⃣ JSearch API (RapidAPI)
**Live Job Listings**
- Provider: RapidAPI
- URL: `https://jsearch.p.rapidapi.com/search`
- Auth: API Key
- Data: Real-time job listings

**Backend Endpoints**:
```
GET /api/live/jobs
GET /api/live/jobs/city/{city}
GET /api/live/jobs/company/{company}
```

**Example Response**:
```json
{
  "company": "TCS",
  "title": "Senior Software Engineer",
  "description": "...",
  "posted_at": "2026-06-17T10:30:00Z",
  "salary_min": 1200000,
  "salary_max": 1800000
}
```

---

### 2️⃣ Numbeo API
**Cost of Living Data**
- Provider: Numbeo
- URL: `https://www.numbeo.com/cost-of-living/in`
- Auth: None (Web scraping)
- Data: Real-time cost of living

**Backend Endpoints**:
```
GET /api/cost-of-living/{city}
GET /api/cost-of-living/cities
GET /api/affordability
```

**Example Response**:
```json
{
  "city": "Bangalore",
  "rent_1br_center": 18000,
  "grocery_monthly": 4500,
  "transportation": 2000,
  "total_monthly": 43000
}
```

---

### 3️⃣ Supabase API
**Database & Authentication**
- Provider: Supabase
- Type: PostgreSQL + Auth
- Auth: Service Key
- Data: Jobs, companies, users, reviews, salaries

**Backend Endpoints**:
```
GET /api/jobs
GET /api/companies
POST /api/reviews
GET /api/salaries
POST /api/interviews
```

**Example Response**:
```json
{
  "id": "job-id",
  "title": "Senior Software Engineer",
  "company": {
    "name": "TCS",
    "logo_url": "https://..."
  },
  "affordability": {
    "score": 75,
    "monthlyExpenses": 45000
  }
}
```

---

## 🔄 Data Flow

```
Flutter App
    ↓
Node.js Backend (Port 3001)
    ↓
├─ JSearch API → Live Jobs
├─ Numbeo API → Cost of Living
└─ Supabase API → Database
```

---

## 📊 API Comparison

| Feature | JSearch | Numbeo | Supabase |
|---------|---------|--------|----------|
| Real-time | ✅ | ✅ | ✅ |
| Job data | ✅ | ❌ | ✅ |
| Cost data | ❌ | ✅ | ❌ |
| Database | ❌ | ❌ | ✅ |
| Auth | ❌ | ❌ | ✅ |

---

## 🚀 How to Use

### Get Jobs by City
```
GET http://localhost:3001/api/live/jobs/city/Bangalore
```

### Get Jobs with Affordability
```
GET http://localhost:3001/api/jobs?city=Bangalore
```

### Get Cost of Living
```
GET http://localhost:3001/api/cost-of-living/Bangalore
```

---

## 🔑 Environment Variables

```
RAPIDAPI_KEY=your_jsearch_key
SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_KEY=your_service_key
JWT_SECRET=your_jwt_secret
```

---

## ✨ Integration Points

**Home Page**: JSearch + Numbeo + Supabase  
**Jobs Page**: Supabase + Numbeo  
**Job Detail**: JSearch/Supabase + Numbeo  
**Companies**: Supabase  
**Profile**: Supabase  

---

*API Integration - Quick Reference*  
*June 17, 2026*  
*Status: Complete ✅*
