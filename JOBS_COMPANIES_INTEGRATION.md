# 🔗 Jobs & Companies Integration Architecture

**Status**: ✅ FULLY INTEGRATED  
**Date**: June 23, 2026

---

## 📊 Overview

Jobs and Companies are deeply integrated throughout the Salariann platform. Here's how they work together:

```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (Flutter)                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Home Screen                                                 │
│  ├─ Fetches Jobs (JobsProvider)                             │
│  ├─ Fetches Companies (CompaniesProvider)                   │
│  └─ Displays Jobs with Company Info (embedded)              │
│                                                               │
│  Job Detail Screen                                           │
│  ├─ Shows Job details                                        │
│  ├─ Shows Company info (from Job.company)                   │
│  └─ Shows Affordability calculation                          │
│                                                               │
│  Companies Screen                                            │
│  ├─ Lists all companies                                      │
│  └─ Can filter by search                                     │
│                                                               │
│  Company Profile Screen                                      │
│  ├─ Shows company details                                    │
│  ├─ Displays company's jobs (from Company.jobs)             │
│  ├─ Shows reviews, salaries, interviews                      │
│  └─ Links to individual jobs                                 │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                           ↓ HTTP/REST
┌─────────────────────────────────────────────────────────────┐
│                   BACKEND (Node.js/Express)                  │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  GET /api/jobs                                               │
│  ├─ Returns: Job[] with embedded Company info               │
│  ├─ Includes: affordability, suitabilityScore               │
│  └─ Query params: city, role, limit, offset                 │
│                                                               │
│  GET /api/jobs/:id                                           │
│  ├─ Returns: Single Job with full Company details           │
│  └─ Includes: affordability breakdown                        │
│                                                               │
│  GET /api/companies                                          │
│  ├─ Returns: Company[] list                                  │
│  └─ Query params: search, city, limit, offset               │
│                                                               │
│  GET /api/companies/:id                                      │
│  ├─ Returns: Single Company with related data               │
│  ├─ Includes: jobs[], reviews[], salaries[], interviews[]   │
│  └─ Includes: stats (jobCount, reviewCount, etc.)           │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                           ↓ Supabase Client
┌─────────────────────────────────────────────────────────────┐
│              DATABASE (Supabase Cloud/PostgreSQL)            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  companies table                                             │
│  ├─ id (UUID, PK)                                            │
│  ├─ name, logo_url, website                                  │
│  ├─ employee_count, description, city                        │
│  ├─ founded_year, industry, rating, total_reviews            │
│  └─ created_at, updated_at                                   │
│                                                               │
│  jobs table                                                  │
│  ├─ id (UUID, PK)                                            │
│  ├─ company_id (FK → companies.id)                           │
│  ├─ title, description, city                                 │
│  ├─ annual_ctc_min, annual_ctc_max                           │
│  ├─ tech_stack[], ats_url                                    │
│  ├─ employment_type, experience_required                     │
│  ├─ is_active, posted_at                                     │
│  └─ created_at, updated_at                                   │
│                                                               │
│  city_metrics table                                          │
│  ├─ city_name, lifestyle                                     │
│  ├─ avg_rent, avg_food, avg_utilities                        │
│  ├─ avg_commute, avg_entertainment, avg_healthcare           │
│  └─ created_at, updated_at                                   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow

### 1. **Home Screen - Jobs with Company Info**

```
User opens Home Screen
    ↓
HomeScreen.initState()
    ├─ JobsProvider.fetchJobs()
    │  └─ GET /api/jobs
    │     └─ Returns: Job[] with embedded Company data
    │
    └─ CompaniesProvider.fetchCompanies()
       └─ GET /api/companies
          └─ Returns: Company[] list
    ↓
JobsProvider._jobs = [Job(company: Company), ...]
    ↓
UI renders JobCard for each job
    ├─ Shows: job.title, job.city, job.annualCtcMax
    ├─ Shows: job.company.name (company info embedded)
    ├─ Shows: job.suitabilityScore (affordability)
    └─ Shows: job.affordability (cost breakdown)
```

### 2. **Job Detail Screen**

```
User clicks on a Job
    ↓
JobDetailScreen.initState()
    └─ JobsProvider.fetchJobById(jobId)
       └─ GET /api/jobs/:id
          └─ Returns: Job with full Company details
    ↓
UI displays:
├─ Job title, description, salary range
├─ Company name, logo, website
├─ Tech stack, experience required
├─ Affordability calculation
│  ├─ Monthly net salary
│  ├─ Cost breakdown (rent, food, utilities, etc.)
│  ├─ Disposable income
│  └─ Savings percentage
└─ "Apply" button (links to job.atsUrl)
```

### 3. **Companies Screen**

```
User clicks "Companies" tab
    ↓
CompaniesScreen.initState()
    └─ CompaniesProvider.fetchCompanies()
       └─ GET /api/companies
          └─ Returns: Company[] list
    ↓
UI displays:
├─ Company list with search
├─ Each company card shows:
│  ├─ Company name, logo
│  ├─ Employee count, city
│  ├─ Description
│  ├─ Rating and review count
│  └─ "View Profile" button
```

### 4. **Company Profile Screen**

```
User clicks "View Profile" on a company
    ↓
CompanyProfileScreen.initState()
    └─ CompaniesProvider.fetchCompanyById(companyId)
       └─ GET /api/companies/:id
          └─ Returns: Company with related data
    ↓
UI displays tabs:
├─ Overview Tab
│  └─ Shows: stats (jobCount, reviewCount, avgRating)
│
├─ Jobs Tab
│  └─ Lists: company.jobs[]
│     └─ Each job links to Job Detail Screen
│
├─ Reviews Tab
│  └─ Lists: company.reviews[]
│     └─ Shows: rating, pros, cons
│
├─ Salaries Tab
│  └─ Lists: company.salaries[]
│     └─ Shows: role, annual_ctc
│
└─ Interviews Tab
   └─ Lists: company.interviews[]
      └─ Shows: role, difficulty, experience
```

---

## 📦 Data Models

### Job Model
```dart
class Job {
  final String id;
  final String title;
  final String? description;
  final String city;
  final double? annualCtcMin;
  final double? annualCtcMax;
  final List<String>? techStack;
  final String atsUrl;
  final DateTime postedAt;
  final bool isActive;
  final String companyId;
  
  // ✅ EMBEDDED COMPANY DATA
  final Company? company;
  
  // ✅ AFFORDABILITY DATA
  final SuitabilityScore? suitabilityScore;
  final Map<String, dynamic>? affordability;
  final String? affordabilityBadge;
}
```

### Company Model
```dart
class Company {
  final String id;
  final String name;
  final String? logoUrl;
  final String? website;
  final int? employeeCount;
  final String? description;
  final String? city;
  final int? foundedYear;
  final double? rating;
  final int? totalReviews;
  
  // ✅ RELATED DATA
  final Map<String, dynamic>? stats;
  final List<dynamic>? jobs;        // Company's jobs
  final List<dynamic>? reviews;     // Company reviews
  final List<dynamic>? salaries;    // Salary data
  final List<dynamic>? interviews;  // Interview experiences
}
```

---

## 🔌 API Endpoints

### Jobs Endpoints

**GET /api/jobs**
```
Query Parameters:
- limit: number (default: 20)
- offset: number (default: 0)
- city: string (optional)
- role: string (optional)

Response:
{
  "data": [
    {
      "id": "uuid",
      "title": "Senior Software Engineer",
      "city": "Bangalore",
      "annual_ctc_min": 1200000,
      "annual_ctc_max": 1800000,
      "tech_stack": ["Java", "Spring Boot", "Docker"],
      "ats_url": "https://...",
      "companies": {
        "id": "uuid",
        "name": "TCS",
        "logo_url": "https://...",
        "employee_count": 500000
      },
      "suitabilityScore": {
        "annualCtc": 1500000,
        "netMonthly": 95333,
        "totalExpenses": 24700,
        "disposableIncome": 70633,
        "savingsPercentage": 74.09,
        "score": "GREEN",
        "status": "Comfortable"
      },
      "affordability": {
        "score": 67,
        "level": "Affordable",
        "monthlyExpenses": 35748,
        "breakdown": {
          "rent": 17983,
          "grocery": 2718,
          "transport": 1750,
          "utilities": 5961
        }
      }
    }
  ],
  "pagination": {
    "total": 34,
    "limit": 20,
    "offset": 0
  }
}
```

**GET /api/jobs/:id**
```
Response: Single Job with full Company details
```

### Companies Endpoints

**GET /api/companies**
```
Query Parameters:
- limit: number (default: 20)
- offset: number (default: 0)
- search: string (optional)
- city: string (optional)

Response:
{
  "data": [
    {
      "id": "uuid",
      "name": "TCS",
      "logo_url": "https://...",
      "website": "https://www.tcs.com",
      "employee_count": 500000,
      "description": "India's largest IT company",
      "city": "Bangalore",
      "founded_year": 1968,
      "industry": "IT Services",
      "rating": 4.2,
      "total_reviews": 5000
    }
  ],
  "pagination": {
    "total": 17,
    "limit": 20,
    "offset": 0
  }
}
```

**GET /api/companies/:id**
```
Response: Single Company with related data
{
  "id": "uuid",
  "name": "TCS",
  "logo_url": "https://...",
  "stats": {
    "jobCount": 2,
    "reviewCount": 150,
    "salaryDataCount": 45,
    "interviewCount": 30,
    "avgRating": 4.2
  },
  "jobs": [
    {
      "id": "uuid",
      "title": "Senior Software Engineer",
      "city": "Bangalore",
      "annual_ctc_min": 1200000,
      "annual_ctc_max": 1800000
    }
  ],
  "reviews": [
    {
      "overall_rating": 4.5,
      "pros": "Good work culture",
      "cons": "Long working hours"
    }
  ],
  "salaries": [
    {
      "role": "Software Engineer",
      "annual_ctc": 1500000
    }
  ],
  "interviews": [
    {
      "role": "Senior Software Engineer",
      "difficulty": 4,
      "experience": "Positive"
    }
  ]
}
```

---

## 🎯 Key Integration Points

### 1. **Job Card Widget** (`job_card.dart`)
- Displays job with embedded company info
- Shows affordability badge (GREEN/YELLOW/RED)
- Links to job detail screen

### 2. **Job Detail Screen** (`job_detail_screen.dart`)
- Shows full job details
- Displays company profile section
- Shows affordability breakdown
- Links to company profile

### 3. **Company Profile Screen** (`company_profile_screen.dart`)
- Shows company overview
- Displays company's jobs in Jobs tab
- Shows reviews, salaries, interviews
- Each job links back to job detail

### 4. **Filter Panel** (`filter_panel.dart`)
- Filters jobs by city, salary, job type
- Filters companies by search, city
- Real-time filtering with providers

---

## 🔄 Provider Pattern

### JobsProvider
```dart
class JobsProvider extends ChangeNotifier {
  List<Job> _jobs = [];
  List<Job> _filteredJobs = [];
  Job? _selectedJob;
  
  // Methods
  Future<void> fetchJobs({city, role, page})
  void filterJobs({searchQuery, city, jobType, minSalary, maxSalary})
  Future<void> fetchJobById(String id)
  Future<void> logJobClick(String jobId, String? token)
  void clearFilters()
}
```

### CompaniesProvider
```dart
class CompaniesProvider extends ChangeNotifier {
  List<Company> _companies = [];
  List<Company> _filteredCompanies = [];
  Company? _selectedCompany;
  
  // Methods
  Future<void> fetchCompanies({search, city, page})
  void searchCompanies(String query)
  Future<void> fetchCompanyById(String id)
  void clearSearch()
}
```

---

## 🔗 Relationships

### One-to-Many: Company → Jobs
```
Company (1) ──→ (Many) Jobs
  ├─ TCS
  │  ├─ Senior Software Engineer
  │  └─ Full Stack Developer
  ├─ Infosys
  │  ├─ Cloud Architect
  │  └─ Data Engineer
  └─ ...
```

### One-to-One: Job → Company
```
Job ──→ Company
  ├─ Senior Software Engineer → TCS
  ├─ Cloud Architect → Infosys
  └─ ...
```

### One-to-Many: Company → Related Data
```
Company (1) ──→ (Many) Reviews, Salaries, Interviews
  ├─ Reviews
  ├─ Salaries
  └─ Interviews
```

---

## 📊 Data Statistics

### Current Data
- **Companies**: 17 tech companies
- **Jobs**: 34 tech jobs
- **Cities**: 10 Indian cities
- **Job-Company Mapping**: Each job linked to a company

### Salary Range
- **Min**: ₹8L annually
- **Max**: ₹35L annually
- **Average**: ₹15L annually

### Affordability Coverage
- **Cities with metrics**: 10
- **Lifestyles**: 2 (single, family)
- **Cost categories**: 6 (rent, food, utilities, commute, entertainment, healthcare)

---

## ✅ Integration Checklist

✅ **Data Models**
- Job model with embedded Company
- Company model with related data
- Affordability and SuitabilityScore models

✅ **Providers**
- JobsProvider with fetch and filter methods
- CompaniesProvider with fetch and search methods
- Proper state management with ChangeNotifier

✅ **API Endpoints**
- GET /api/jobs with company data
- GET /api/jobs/:id with full details
- GET /api/companies with list
- GET /api/companies/:id with related data

✅ **Screens**
- Home screen showing jobs with company info
- Job detail screen with affordability
- Companies screen with search
- Company profile screen with tabs

✅ **Navigation**
- Job card → Job detail screen
- Job detail → Company profile screen
- Company card → Company profile screen
- Company profile jobs → Job detail screen

✅ **Affordability Integration**
- Automatic calculation for each job
- Cost of living by city
- Expense breakdown display
- Color-coded affordability scores

---

## 🎯 How to Use

### View Jobs with Company Info
1. Go to Home screen
2. See all jobs with company names
3. Click on any job to see details
4. View affordability for that job in that city

### View Company Details
1. Go to Companies screen
2. Search or browse companies
3. Click "View Profile"
4. See company's jobs, reviews, salaries, interviews

### Filter Jobs
1. Use filters on Home screen
2. Select city, salary range, job type
3. Jobs update in real-time
4. See affordability for selected city

---

## 🚀 Status

✅ **FULLY INTEGRATED**
- Jobs and Companies are seamlessly connected
- Data flows correctly through all screens
- Affordability calculations work with company jobs
- All navigation links work properly
- Real-time filtering and search working

---

**Status**: ✅ COMPLETE  
**Date**: June 23, 2026, 11:50 PM UTC+05:30
