# Complete API Integration Guide

**Date**: June 17, 2026  
**Status**: ✅ **COMPLETE**

---

## 🎯 All APIs Used in Salariann

The Salariann platform uses **3 main external APIs** integrated into the backend:

---

## 1️⃣ JSearch API (RapidAPI) - Live Job Listings

### What It Does
Fetches real-time job listings from across the web

### Integration Details
- **Provider**: RapidAPI
- **API Name**: JSearch
- **Base URL**: `https://jsearch.p.rapidapi.com/search`
- **Authentication**: API Key (RAPIDAPI_KEY)
- **Documentation**: https://rapidapi.com/letscrape-6bRBa3QguO5/api/jsearch

### How It's Integrated

#### Backend Setup
```javascript
// File: /backend/src/controllers/liveJobs.controller.js
const JSEARCH_API_URL = 'https://jsearch.p.rapidapi.com/search';
const RAPIDAPI_KEY = process.env.RAPIDAPI_KEY;
```

#### API Endpoints Using JSearch
```
GET /api/live/jobs
GET /api/live/jobs/city/{city}
GET /api/live/jobs/company/{company}
POST /api/live/sync
```

#### How It Works
```javascript
// Example: Fetch jobs by city
const response = await fetch(
  `${JSEARCH_API_URL}?query=${encodeURIComponent(searchQuery)}&page=${page}&num_pages=1&country=in`,
  {
    method: 'GET',
    headers: {
      'x-rapidapi-key': RAPIDAPI_KEY,
      'x-rapidapi-host': 'jsearch.p.rapidapi.com'
    }
  }
);
```

#### Data Transformation
```javascript
const jobs = (data.data || []).map(job => ({
  id: job.job_id,
  title: job.job_title,
  company: job.employer_name,
  company_logo: job.employer_logo,
  company_website: job.employer_website,
  city: job.job_city || 'Remote',
  description: job.job_description,
  employment_type: job.job_employment_type,
  is_remote: job.job_is_remote,
  salary_min: job.job_min_salary,
  salary_max: job.job_max_salary,
  salary_period: job.job_salary_period,
  posted_at: job.job_posted_at_datetime_utc,
  apply_link: job.job_apply_link,
  tech_stack: job.required_technologies || [],
  qualifications: job.job_highlights?.Qualifications || [],
  responsibilities: job.job_highlights?.Responsibilities || [],
  benefits: job.job_highlights?.Benefits || [],
  seniority_level: job.seniority_level,
  experience_required: job.required_experience_years,
  source: 'jsearch'
}));
```

#### Response Example
```json
{
  "success": true,
  "city": "Bangalore",
  "total": 25,
  "data": [
    {
      "id": "job_123",
      "title": "Senior Software Engineer",
      "company": "TCS",
      "company_logo": "https://...",
      "description": "We are looking for...",
      "posted_at": "2026-06-17T10:30:00Z",
      "tech_stack": ["Java", "Spring Boot"],
      "salary_min": 1200000,
      "salary_max": 1800000
    }
  ]
}
```

---

## 2️⃣ Numbeo API - Cost of Living Data

### What It Does
Fetches real-time cost of living data for Indian cities

### Integration Details
- **Provider**: Numbeo
- **Type**: Web Scraping (No API key required)
- **Base URL**: `https://www.numbeo.com/cost-of-living/in`
- **Authentication**: None (Public pages)
- **Documentation**: https://www.numbeo.com

### How It's Integrated

#### Backend Setup
```javascript
// File: /backend/src/utils/externalApis.js
const NUMBEO_BASE_URL = 'https://www.numbeo.com/cost-of-living/in';

const CITY_URL_MAP = {
  'Bangalore': 'Bangalore',
  'Mumbai': 'Mumbai',
  'Delhi': 'Delhi',
  'Hyderabad': 'Hyderabad',
  'Pune': 'Pune',
  // ... 15+ more cities
};
```

#### API Endpoints Using Numbeo
```
GET /api/cost-of-living/cities
GET /api/cost-of-living/{city}
GET /api/cost-of-living
GET /api/affordability
```

#### How It Works
```javascript
// Scrape Numbeo public pages
async function getCostOfLiving(city) {
  const slug = CITY_URL_MAP[city];
  const url = `${NUMBEO_BASE_URL}/${slug}`;
  
  const response = await axios.get(url, {
    headers: {
      'User-Agent': 'Mozilla/5.0...',
      'Accept': 'text/html,application/xhtml+xml'
    },
    timeout: 15000
  });
  
  const html = response.data;
  const costData = parseNumbeoHtml(city, html);
  return costData;
}
```

#### Data Parsing
```javascript
// Extracts from HTML:
// - Rent (1BR in center, outside)
// - Grocery costs
// - Transportation
// - Utilities
// - Dining out
// - Entertainment
// - Total monthly expenses

const costData = {
  city: 'Bangalore',
  rent_1br_center: 18000,
  rent_1br_outside: 12000,
  grocery_monthly: 4500,
  transportation: 2000,
  utilities: 1500,
  dining_out: 3000,
  entertainment: 2000,
  total_monthly: 43000,
  currency: 'INR',
  source: 'numbeo_live'
};
```

#### Response Example
```json
{
  "city": "Bangalore",
  "rent_1br_center": 18000,
  "rent_1br_outside": 12000,
  "grocery_monthly": 4500,
  "transportation": 2000,
  "utilities": 1500,
  "dining_out": 3000,
  "entertainment": 2000,
  "total_monthly": 43000,
  "currency": "INR",
  "source": "numbeo_live",
  "last_updated": "2026-06-17T14:30:00Z"
}
```

---

## 3️⃣ Supabase API - Database & Authentication

### What It Does
Stores and manages all application data (jobs, companies, users, reviews, etc.)

### Integration Details
- **Provider**: Supabase
- **Type**: PostgreSQL Database + Authentication
- **Base URL**: Supabase project URL
- **Authentication**: Service Key
- **Documentation**: https://supabase.com

### How It's Integrated

#### Backend Setup
```javascript
// File: /backend/src/config/supabase.js
import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);
```

#### Database Tables
```
- users (authentication & profiles)
- companies (company information)
- jobs (job listings)
- reviews (company reviews)
- salaries (salary data)
- interviews (interview experiences)
- city_metrics (cost of living data)
```

#### API Endpoints Using Supabase
```
GET /api/jobs
GET /api/jobs/:id
POST /api/jobs
GET /api/companies
GET /api/companies/:id
POST /api/companies
GET /api/reviews
POST /api/reviews
GET /api/salaries
POST /api/salaries
GET /api/interviews
POST /api/interviews
```

#### How It Works
```javascript
// Example: Fetch jobs with affordability
const { data, error, count } = await supabase
  .from('jobs')
  .select(`
    id,
    title,
    description,
    city,
    annual_ctc_min,
    annual_ctc_max,
    tech_stack,
    posted_at,
    companies (id, name, logo_url, website)
  `)
  .eq('is_active', true)
  .ilike('city', `%${city}%`)
  .order('posted_at', { ascending: false })
  .range(offset, offset + limit - 1);
```

#### Response Example
```json
{
  "data": [
    {
      "id": "job-id",
      "title": "Senior Software Engineer",
      "description": "Full description...",
      "city": "Bangalore",
      "annual_ctc_min": 1200000,
      "annual_ctc_max": 1800000,
      "tech_stack": ["Java", "Spring Boot"],
      "posted_at": "2026-06-17T10:30:00Z",
      "companies": {
        "id": "company-id",
        "name": "TCS",
        "logo_url": "https://...",
        "website": "https://..."
      }
    }
  ],
  "pagination": {
    "total": 150,
    "limit": 20,
    "offset": 0
  }
}
```

---

## 🔄 Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Web App                          │
│                   (Chrome Browser)                          │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP Requests
                         ↓
┌─────────────────────────────────────────────────────────────┐
│              Node.js Backend (Express)                      │
│              (Port 3001)                                    │
├─────────────────────────────────────────────────────────────┤
│  Routes & Controllers                                       │
│  - /api/jobs                                                │
│  - /api/companies                                           │
│  - /api/live/jobs                                           │
│  - /api/cost-of-living                                      │
└────┬──────────────────┬──────────────────┬─────────────────┘
     │                  │                  │
     ↓                  ↓                  ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ JSearch API  │  │ Numbeo API   │  │ Supabase API │
│ (RapidAPI)   │  │ (Web Scrape) │  │ (Database)   │
│              │  │              │  │              │
│ Live Jobs    │  │ Cost of      │  │ Jobs         │
│ Real-time    │  │ Living Data  │  │ Companies    │
│ Data         │  │ Real-time    │  │ Users        │
└──────────────┘  └──────────────┘  └──────────────┘
```

---

## 📊 API Usage Summary

| API | Purpose | Type | Auth | Status |
|-----|---------|------|------|--------|
| JSearch | Live job listings | REST | API Key | ✅ Active |
| Numbeo | Cost of living | Web Scrape | None | ✅ Active |
| Supabase | Database & Auth | REST | Service Key | ✅ Active |

---

## 🚀 How APIs Are Used in Flutter

### 1. Fetch Jobs by City
```dart
// In JobsProvider
Future<void> fetchJobsByCity(String city) async {
  final response = await http.get(
    Uri.parse('http://localhost:3001/api/live/jobs/city/$city'),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    jobs = (data['data'] as List)
        .map((job) => Job.fromJson(job))
        .toList();
  }
}
```

### 2. Fetch Jobs with Affordability
```dart
// In JobsProvider
Future<void> fetchJobsWithAffordability(String city) async {
  final response = await http.get(
    Uri.parse('http://localhost:3001/api/jobs?city=$city'),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    jobs = (data['data'] as List)
        .map((job) => Job.fromJson(job))
        .toList();
  }
}
```

### 3. Fetch Cost of Living
```dart
// In CostOfLivingProvider
Future<void> fetchCostOfLiving(String city) async {
  final response = await http.get(
    Uri.parse('http://localhost:3001/api/cost-of-living/$city'),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    costData = CostOfLiving.fromJson(data);
  }
}
```

---

## 🔑 Environment Variables

### Backend (.env)
```
# JSearch API (RapidAPI)
RAPIDAPI_KEY=your_jsearch_api_key

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your_service_key

# JWT
JWT_SECRET=your_jwt_secret

# Cache
CACHE_TTL=3600
```

### Frontend (.env)
```
FLUTTER_APP_API_BASE_URL=http://localhost:3001
```

---

## ✨ Key Features

✅ **Real-time Data**
- Live job listings from JSearch
- Real-time cost of living from Numbeo
- Database updates via Supabase

✅ **Data Enrichment**
- Jobs combined with affordability analysis
- Company information with reviews
- Salary data with statistics

✅ **Caching**
- In-memory cache for cost of living (1 hour TTL)
- Reduces API calls to Numbeo

✅ **Error Handling**
- Fallback data if APIs fail
- Proper error messages
- Retry logic

✅ **Authentication**
- JWT tokens for secure endpoints
- Optional auth for public endpoints
- Supabase auth integration

---

## 🎯 API Integration Points

### Home Page
- Fetches live jobs by city (JSearch)
- Shows affordability analysis (Numbeo + Supabase)
- Displays company information (Supabase)

### Jobs Page
- Lists all jobs with filters (Supabase)
- Shows affordability badges (Numbeo)
- Displays suitability scores (Supabase)

### Job Detail Page
- Shows full job description (JSearch/Supabase)
- Cost of living breakdown (Numbeo)
- Company details (Supabase)

### Companies Page
- Lists all companies (Supabase)
- Shows company reviews (Supabase)
- Displays salary data (Supabase)

### Profile Page
- User authentication (Supabase)
- Profile management (Supabase)
- Contribution tracking (Supabase)

---

## 📝 Summary

**Three APIs working together:**

1. **JSearch API** - Real-time job listings
2. **Numbeo API** - Cost of living data
3. **Supabase API** - Database & authentication

**All integrated into:**
- Backend: Node.js Express server
- Frontend: Flutter web app
- Data flow: Seamless and efficient

**Result:** Complete job search platform with affordability analysis!

---

*Complete API Integration Guide*  
*June 17, 2026*  
*Status: Complete ✅*
