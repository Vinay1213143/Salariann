# 🔗 Jobs & Companies Integration - Quick Summary

---

## 🎯 How They Work Together

### **Frontend Flow**

```
HOME SCREEN
├─ Fetches: JobsProvider.fetchJobs()
├─ Fetches: CompaniesProvider.fetchCompanies()
└─ Displays: Jobs with embedded Company info
   ├─ Job title, salary, city
   ├─ Company name, logo
   ├─ Affordability score (GREEN/YELLOW/RED)
   └─ Click → Job Detail Screen

JOB DETAIL SCREEN
├─ Shows: Full job details
├─ Shows: Company info (from Job.company)
├─ Shows: Affordability breakdown
│  ├─ Monthly net salary
│  ├─ Cost breakdown (rent, food, utilities, etc.)
│  ├─ Disposable income
│  └─ Savings percentage
└─ Click "View Company" → Company Profile Screen

COMPANIES SCREEN
├─ Fetches: CompaniesProvider.fetchCompanies()
├─ Displays: List of all companies
├─ Search: Filter by name, city, description
└─ Click → Company Profile Screen

COMPANY PROFILE SCREEN
├─ Fetches: CompaniesProvider.fetchCompanyById()
├─ Shows: Company overview (stats, rating, reviews)
├─ Jobs Tab: Lists company's jobs
│  └─ Click job → Job Detail Screen
├─ Reviews Tab: Company reviews
├─ Salaries Tab: Salary data by role
└─ Interviews Tab: Interview experiences
```

---

## 📊 Data Integration

### **Job Object Contains:**
```dart
Job {
  id, title, description, city
  annualCtcMin, annualCtcMax
  techStack[], atsUrl
  companyId
  
  ✅ company: Company {      // EMBEDDED COMPANY DATA
    id, name, logoUrl, website
    employeeCount, description, city
    rating, totalReviews
  }
  
  ✅ suitabilityScore: {     // AFFORDABILITY DATA
    annualCtc, netMonthly
    totalExpenses, disposableIncome
    savingsPercentage, score
  }
  
  ✅ affordability: {        // COST BREAKDOWN
    score, level, monthlyExpenses
    breakdown { rent, food, utilities, ... }
  }
}
```

### **Company Object Contains:**
```dart
Company {
  id, name, logoUrl, website
  employeeCount, description, city
  foundedYear, rating, totalReviews
  
  ✅ stats: {                // COMPANY STATS
    jobCount, reviewCount
    salaryDataCount, interviewCount
    avgRating
  }
  
  ✅ jobs: [                 // COMPANY'S JOBS
    { id, title, city, salary_range }
  ]
  
  ✅ reviews: [              // COMPANY REVIEWS
    { rating, pros, cons }
  ]
  
  ✅ salaries: [             // SALARY DATA
    { role, annual_ctc }
  ]
  
  ✅ interviews: [           // INTERVIEW EXPERIENCES
    { role, difficulty, experience }
  ]
}
```

---

## 🔌 API Integration

### **Backend Returns:**

**GET /api/jobs**
```json
{
  "data": [
    {
      "id": "...",
      "title": "Senior Software Engineer",
      "city": "Bangalore",
      "annual_ctc_min": 1200000,
      "annual_ctc_max": 1800000,
      "companies": {
        "id": "...",
        "name": "TCS",
        "logo_url": "...",
        "employee_count": 500000
      },
      "suitabilityScore": {
        "netMonthly": 95333,
        "totalExpenses": 24700,
        "disposableIncome": 70633,
        "savingsPercentage": 74.09,
        "score": "GREEN"
      },
      "affordability": {
        "score": 67,
        "level": "Affordable",
        "breakdown": {
          "rent": 25000,
          "food": 8000,
          "utilities": 2500,
          "commute": 2000
        }
      }
    }
  ]
}
```

**GET /api/companies/:id**
```json
{
  "id": "...",
  "name": "TCS",
  "logo_url": "...",
  "stats": {
    "jobCount": 2,
    "reviewCount": 150,
    "avgRating": 4.2
  },
  "jobs": [
    {
      "id": "...",
      "title": "Senior Software Engineer",
      "city": "Bangalore"
    }
  ],
  "reviews": [...],
  "salaries": [...],
  "interviews": [...]
}
```

---

## 🎯 Key Features

### **1. Job Search with Company Context**
- Search jobs by title, company, role
- See company info immediately
- Filter by city, salary, job type
- Real-time filtering

### **2. Affordability Calculation**
- Automatic for each job in each city
- Shows monthly net salary
- Breaks down all expenses
- Calculates disposable income
- Shows savings percentage
- Color-coded: GREEN (>50%), YELLOW (20-50%), RED (<20%)

### **3. Company Profiles**
- View all company details
- See company's job listings
- Read company reviews
- Check salary data by role
- Read interview experiences

### **4. Navigation**
- Job → Company Profile
- Company → Company's Jobs
- Job → Job Details
- All screens interconnected

---

## 📈 Data Statistics

| Metric | Value |
|--------|-------|
| **Companies** | 17 |
| **Jobs** | 34 |
| **Cities** | 10 |
| **Salary Range** | ₹8L - ₹35L |
| **Job-Company Links** | 34 (each job has company) |
| **Affordability Metrics** | 20 (10 cities × 2 lifestyles) |

---

## ✅ Integration Points

### **Providers**
- ✅ JobsProvider - Manages jobs, filtering, affordability
- ✅ CompaniesProvider - Manages companies, search

### **Models**
- ✅ Job - With embedded Company and affordability data
- ✅ Company - With related jobs, reviews, salaries, interviews

### **Screens**
- ✅ Home - Jobs with company info
- ✅ Job Detail - Full details with affordability
- ✅ Companies - Company list with search
- ✅ Company Profile - Company details with tabs

### **API Endpoints**
- ✅ GET /api/jobs - Jobs with company data
- ✅ GET /api/jobs/:id - Job with full details
- ✅ GET /api/companies - Company list
- ✅ GET /api/companies/:id - Company with related data

### **Database**
- ✅ companies table (17 records)
- ✅ jobs table (34 records)
- ✅ city_metrics table (20 records)
- ✅ Foreign key: jobs.company_id → companies.id

---

## 🔄 User Journey

```
1. User opens app → Home Screen
   ├─ Sees list of jobs with company names
   ├─ Sees affordability score for each job
   └─ Can search, filter by city/salary

2. User clicks on a job → Job Detail Screen
   ├─ Sees full job description
   ├─ Sees company info (name, logo, employees)
   ├─ Sees affordability breakdown
   │  ├─ Monthly net salary
   │  ├─ Cost breakdown
   │  ├─ Disposable income
   │  └─ Savings percentage
   └─ Can click "View Company" or "Apply"

3. User clicks "View Company" → Company Profile Screen
   ├─ Sees company overview (rating, reviews)
   ├─ Sees company's jobs in Jobs tab
   ├─ Sees reviews in Reviews tab
   ├─ Sees salary data in Salaries tab
   ├─ Sees interview experiences in Interviews tab
   └─ Can click any job to see details

4. User can also go to Companies Screen
   ├─ Search for specific companies
   ├─ Browse all companies
   └─ Click to view company profile
```

---

## 🎉 Result

✅ **Jobs and Companies are fully integrated**
- Seamless data flow between screens
- Company info embedded in job listings
- Affordability calculated for each job-city combination
- Easy navigation between jobs and companies
- Real-time search and filtering
- Complete company profiles with related data

---

**Status**: ✅ COMPLETE & WORKING  
**Date**: June 23, 2026, 11:50 PM UTC+05:30
