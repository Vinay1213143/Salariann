# Jobs API Documentation - Complete Guide

**Date**: June 17, 2026  
**Status**: ✅ **COMPLETE**

---

## 🎯 Available Job APIs

The Salariann platform has **TWO** main job APIs:

### 1. **Local Database API** (Supabase)
- Fetches jobs from local database
- Includes affordability and suitability scores
- Supports filtering by city and role

### 2. **Live Jobs API** (JSearch/RapidAPI)
- Fetches live jobs from JSearch API
- Real-time job listings
- Supports city, company, and role filtering

---

## 📊 API Endpoints

### Local Database Jobs API

#### Get All Jobs
```
GET /api/jobs
```

**Query Parameters**:
- `city` (optional): Filter by city (e.g., "Bangalore")
- `role` (optional): Filter by job role (e.g., "Software Developer")
- `tech_stack` (optional): Filter by technology
- `limit` (optional): Number of jobs per page (default: 20)
- `offset` (optional): Pagination offset (default: 0)

**Example**:
```
GET http://localhost:3001/api/jobs?city=Bangalore&limit=20&offset=0
```

**Response**:
```json
{
  "data": [
    {
      "id": "job-id",
      "title": "Senior Software Engineer",
      "description": "...",
      "city": "Bangalore",
      "annual_ctc_min": 1200000,
      "annual_ctc_max": 1800000,
      "tech_stack": ["Java", "Spring Boot", "Kubernetes"],
      "ats_url": "https://...",
      "posted_at": "2026-06-17T10:00:00Z",
      "is_active": true,
      "company_id": "company-id",
      "companies": {
        "id": "company-id",
        "name": "TCS",
        "logo_url": "https://...",
        "website": "https://..."
      },
      "suitabilityScore": {
        "score": 85,
        "level": "Excellent",
        "colorCode": "green"
      },
      "affordability": {
        "score": 75,
        "level": "Affordable",
        "colorCode": "green",
        "monthlyExpenses": 45000,
        "remainingMonthly": 55000,
        "breakdown": {
          "rent": 15000,
          "food": 12000,
          "transport": 5000,
          "utilities": 3000,
          "entertainment": 10000
        }
      },
      "affordabilityBadge": "Affordable"
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

#### Get Job by ID
```
GET /api/jobs/:id
```

**Example**:
```
GET http://localhost:3001/api/jobs/4c89bd64-6616-41bd-a655-dda73d10f764
```

**Response**: Single job object with all details including affordability and suitability scores

---

### Live Jobs API (JSearch)

#### Get All Live Jobs
```
GET /api/live/jobs
```

**Query Parameters**:
- `query` (optional): Search query (e.g., "software developer")
- `city` (optional): Filter by city
- `company` (optional): Filter by company
- `page` (optional): Page number (default: 1)
- `num_pages` (optional): Number of pages (default: 1)

**Example**:
```
GET http://localhost:3001/api/live/jobs?query=software%20developer&page=1
```

---

#### Get Jobs by City (IT Sector)
```
GET /api/live/jobs/city/:city
```

**Path Parameters**:
- `city`: City name (e.g., "Bangalore", "Mumbai", "Pune")

**Query Parameters**:
- `role` (optional): Job role (default: "software developer")
- `page` (optional): Page number (default: 1)

**Example**:
```
GET http://localhost:3001/api/live/jobs/city/Bangalore?role=software%20developer&page=1
```

**Response**:
```json
{
  "success": true,
  "city": "Bangalore",
  "total": 25,
  "data": [
    {
      "id": "job_id_123",
      "title": "Senior Software Engineer",
      "company": "TCS",
      "company_logo": "https://...",
      "company_website": "https://...",
      "city": "Bangalore",
      "state": "Karnataka",
      "country": "India",
      "description": "...",
      "employment_type": "Full-time",
      "is_remote": false,
      "salary_min": 1200000,
      "salary_max": 1800000,
      "salary_period": "YEARLY",
      "posted_at": "2026-06-17T10:00:00Z",
      "apply_link": "https://...",
      "tech_stack": ["Java", "Spring Boot", "Kubernetes"],
      "qualifications": ["Bachelor's in CS", "5+ years experience"],
      "responsibilities": ["Design systems", "Lead team"],
      "benefits": ["Health insurance", "Stock options"],
      "seniority_level": "Senior",
      "experience_required": 5,
      "source": "jsearch"
    }
  ]
}
```

---

#### Get Jobs by Company
```
GET /api/live/jobs/company/:company
```

**Path Parameters**:
- `company`: Company name (e.g., "TCS", "Infosys", "Wipro")

**Query Parameters**:
- `city` (optional): Filter by city
- `page` (optional): Page number (default: 1)

**Example**:
```
GET http://localhost:3001/api/live/jobs/company/TCS?city=Bangalore&page=1
```

---

#### Get List of Companies
```
GET /api/live/companies
```

**Response**: List of Indian IT companies

---

#### Get List of Cities
```
GET /api/live/cities
```

**Response**: List of Indian metro cities

---

## 🏙️ Supported Cities for IT Jobs

The following cities are supported for IT sector job searches:

```
1. Bangalore
2. Mumbai
3. Delhi
4. Hyderabad
5. Pune
6. Chennai
7. Kolkata
8. Noida
9. Gurgaon
10. Ahmedabad
11. Jaipur
12. Chandigarh
13. Kochi
14. Indore
15. Lucknow
16. Coimbatore
17. Thiruvananthapuram
18. Nagpur
19. Visakhapatnam
20. Bhubaneswar
```

---

## 🏢 Supported IT Companies

The API supports jobs from major Indian IT companies:

```
TCS, Infosys, Wipro, HCL Technologies, Tech Mahindra,
Cognizant, Accenture, IBM, Capgemini, LTIMindtree,
Persistent Systems, Mphasis, L&T Infotech, Mindtree,
Hexaware, Cyient, Birlasoft, Zensar Technologies,
NIIT Technologies, Coforge, Sonata Software, KPIT Technologies,
Happiest Minds, Tata Elxsi, Oracle India, Microsoft India,
Google India, Amazon India, Flipkart, Paytm,
Razorpay, Freshworks, Zoho, Swiggy, Zomato,
PhonePe, CRED, Ola, Myntra, Zerodha
```

---

## 🎯 How to Use in Flutter App

### Fetch Jobs by City

```dart
// In JobsProvider
Future<void> fetchJobsByCity(String city) async {
  try {
    _isLoading = true;
    notifyListeners();
    
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/live/jobs/city/$city?role=software%20developer'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _jobs = (data['data'] as List)
          .map((job) => Job.fromJson(job))
          .toList();
      _error = null;
    } else {
      _error = 'Failed to fetch jobs';
    }
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### Fetch All Jobs with Filters

```dart
Future<void> fetchJobs({
  String? city,
  String? role,
  int limit = 20,
  int offset = 0,
}) async {
  try {
    _isLoading = true;
    notifyListeners();
    
    String url = '${ApiConfig.baseUrl}/api/jobs?limit=$limit&offset=$offset';
    if (city != null) url += '&city=$city';
    if (role != null) url += '&role=$role';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _jobs = (data['data'] as List)
          .map((job) => Job.fromJson(job))
          .toList();
      _totalJobs = data['pagination']['total'];
      _error = null;
    } else {
      _error = 'Failed to fetch jobs';
    }
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

---

## 📱 Using in App Screens

### Home Page - Show Jobs by City

```dart
// In landing_screen.dart
_buildJobsSection(BuildContext context) {
  return Consumer<JobsProvider>(
    builder: (context, jobsProvider, child) {
      // Load jobs for selected city
      jobsProvider.fetchJobsByCity('Bangalore');
      
      return Column(
        children: [
          Text('Available Jobs in Bangalore'),
          ...jobsProvider.jobs.map((job) {
            return JobCard(job: job);
          }).toList(),
        ],
      );
    },
  );
}
```

### Jobs Page - Filter by City

```dart
// In job_dashboard_screen.dart
void _loadJobsByCity(String city) {
  final jobsProvider = context.read<JobsProvider>();
  jobsProvider.fetchJobsByCity(city);
}

// Call when user selects a city
_loadJobsByCity('Bangalore');
```

---

## 🔑 API Configuration

### Backend Setup

The backend is configured at:
```
http://localhost:3001
```

### Environment Variables

For live jobs API (JSearch), you need:
```
RAPIDAPI_KEY=your_jsearch_api_key
```

Get a free API key from: https://rapidapi.com/letscrape-6bRBa3QguO5/api/jsearch

---

## 📊 Response Fields

### Job Object (Local Database)

| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique job ID |
| title | string | Job title |
| description | string | Job description |
| city | string | Job location city |
| annual_ctc_min | number | Minimum annual salary |
| annual_ctc_max | number | Maximum annual salary |
| tech_stack | array | Required technologies |
| ats_url | string | Application URL |
| posted_at | datetime | When job was posted |
| is_active | boolean | Is job active |
| company_id | string | Company ID |
| companies | object | Company details |
| suitabilityScore | object | Salary suitability score |
| affordability | object | Cost of living analysis |
| affordabilityBadge | string | Affordability label |

### Job Object (Live API)

| Field | Type | Description |
|-------|------|-------------|
| id | string | Job ID from JSearch |
| title | string | Job title |
| company | string | Company name |
| company_logo | string | Company logo URL |
| city | string | Job location |
| salary_min | number | Minimum salary |
| salary_max | number | Maximum salary |
| salary_period | string | Salary period (YEARLY, MONTHLY) |
| employment_type | string | Full-time, Part-time, etc. |
| is_remote | boolean | Is remote job |
| tech_stack | array | Required technologies |
| posted_at | datetime | Job posted date |
| apply_link | string | Application link |

---

## ✨ Key Features

✅ **Multiple Data Sources**
- Local database with affordability analysis
- Live jobs from JSearch API

✅ **City Filtering**
- Search jobs in 20+ Indian cities
- IT sector focused

✅ **Company Filtering**
- Filter by 40+ IT companies
- Get company-specific jobs

✅ **Rich Data**
- Salary information
- Tech stack requirements
- Company details
- Affordability analysis
- Suitability scores

✅ **Pagination**
- Limit and offset support
- Page-based navigation

---

## 🚀 Usage Examples

### Get all jobs in Bangalore
```
GET http://localhost:3001/api/live/jobs/city/Bangalore
```

### Get software developer jobs in Mumbai
```
GET http://localhost:3001/api/live/jobs/city/Mumbai?role=software%20developer
```

### Get TCS jobs in Pune
```
GET http://localhost:3001/api/live/jobs/company/TCS?city=Pune
```

### Get all jobs with affordability analysis
```
GET http://localhost:3001/api/jobs?city=Bangalore&limit=20
```

---

## 🎉 Summary

**Two powerful APIs for IT jobs in India:**

1. **Local Database API** - Detailed jobs with affordability and suitability scores
2. **Live Jobs API** - Real-time job listings from JSearch

Both support filtering by:
- ✅ City (20+ Indian cities)
- ✅ Company (40+ IT companies)
- ✅ Role (software developer, etc.)

**Ready to use in your Flutter app!** 🚀

---

*Jobs API Documentation - Complete*  
*June 17, 2026*  
*Status: Complete ✅*
