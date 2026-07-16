# Jobs API - Complete Summary

**Date**: June 17, 2026  
**Status**: ✅ **FOUND AND DOCUMENTED**

---

## 🎯 What You Asked

"Find the API which will help us get all the jobs in the following cities in our app for IT sector"

## ✅ What We Found

**TWO powerful APIs** to fetch IT jobs by city:

---

## 1️⃣ Live Jobs API (Real-time)

### Endpoint
```
GET /api/live/jobs/city/{city}
```

### Usage
```
http://localhost:3001/api/live/jobs/city/Bangalore
http://localhost:3001/api/live/jobs/city/Mumbai
http://localhost:3001/api/live/jobs/city/Pune
```

### Features
- ✅ Real-time job listings
- ✅ From JSearch API
- ✅ 20+ Indian cities supported
- ✅ Salary information
- ✅ Tech stack details
- ✅ Company information
- ✅ Application links

### Response
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
      "salary_min": 1200000,
      "salary_max": 1800000,
      "tech_stack": ["Java", "Spring Boot"],
      "apply_link": "https://..."
    }
  ]
}
```

---

## 2️⃣ Local Database API (With Analysis)

### Endpoint
```
GET /api/jobs?city={city}&limit=20
```

### Usage
```
http://localhost:3001/api/jobs?city=Bangalore&limit=20
http://localhost:3001/api/jobs?city=Mumbai&limit=20
```

### Features
- ✅ Jobs from local database
- ✅ Affordability analysis
- ✅ Suitability scores
- ✅ Cost of living breakdown
- ✅ Pagination support
- ✅ Filter by role

### Response
```json
{
  "data": [
    {
      "id": "job-id",
      "title": "Senior Software Engineer",
      "city": "Bangalore",
      "annual_ctc_min": 1200000,
      "annual_ctc_max": 1800000,
      "suitabilityScore": {
        "score": 85,
        "level": "Excellent"
      },
      "affordability": {
        "score": 75,
        "monthlyExpenses": 45000,
        "remainingMonthly": 55000
      }
    }
  ],
  "pagination": {
    "total": 150,
    "limit": 20
  }
}
```

---

## 🏙️ Supported Cities (20+)

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

## 🏢 Supported IT Companies (40+)

```
TCS, Infosys, Wipro, HCL Technologies, Tech Mahindra,
Cognizant, Accenture, IBM, Capgemini, LTIMindtree,
Persistent Systems, Mphasis, L&T Infotech, Mindtree,
Hexaware, Cyient, Birlasoft, Zensar Technologies,
NIIT Technologies, Coforge, Sonata Software, KPIT,
Happiest Minds, Tata Elxsi, Oracle India, Microsoft,
Google India, Amazon India, Flipkart, Paytm,
Razorpay, Freshworks, Zoho, Swiggy, Zomato,
PhonePe, CRED, Ola, Myntra, Zerodha
```

---

## 📍 How to Use in Your App

### In Flutter - Fetch Jobs by City

```dart
// In JobsProvider
Future<void> fetchJobsByCity(String city) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3001/api/live/jobs/city/$city'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      jobs = (data['data'] as List)
          .map((job) => Job.fromJson(job))
          .toList();
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

### In Home Page

```dart
// Show jobs for selected city
_buildJobsSection(BuildContext context) {
  return Consumer<JobsProvider>(
    builder: (context, jobsProvider, child) {
      jobsProvider.fetchJobsByCity('Bangalore');
      
      return Column(
        children: [
          ...jobsProvider.jobs.map((job) {
            return JobCard(job: job);
          }).toList(),
        ],
      );
    },
  );
}
```

---

## 🎯 API Comparison

| Feature | Live API | Local DB API |
|---------|----------|--------------|
| Real-time data | ✅ Yes | ❌ No |
| Affordability | ❌ No | ✅ Yes |
| Suitability | ❌ No | ✅ Yes |
| Cost breakdown | ❌ No | ✅ Yes |
| Filter by city | ✅ Yes | ✅ Yes |
| Filter by role | ✅ Yes | ✅ Yes |
| Pagination | ✅ Yes | ✅ Yes |
| Company info | ✅ Yes | ✅ Yes |

---

## 🚀 Quick Start

### 1. Get Jobs in Bangalore
```
GET http://localhost:3001/api/live/jobs/city/Bangalore
```

### 2. Get Jobs in Mumbai
```
GET http://localhost:3001/api/live/jobs/city/Mumbai
```

### 3. Get Jobs with Affordability
```
GET http://localhost:3001/api/jobs?city=Bangalore
```

### 4. Get Jobs by Company
```
GET http://localhost:3001/api/live/jobs/company/TCS
```

---

## 📊 Response Fields

### Job Object

| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique job ID |
| title | string | Job title |
| company | string | Company name |
| city | string | Job location |
| salary_min | number | Minimum salary |
| salary_max | number | Maximum salary |
| tech_stack | array | Required technologies |
| employment_type | string | Full-time, Part-time |
| is_remote | boolean | Remote job? |
| posted_at | datetime | Posted date |
| apply_link | string | Application URL |
| suitabilityScore | object | (Local DB only) |
| affordability | object | (Local DB only) |

---

## ✨ Key Advantages

✅ **Multiple Data Sources**
- Real-time jobs from JSearch
- Detailed analysis from local DB

✅ **Comprehensive Filtering**
- By city (20+ cities)
- By company (40+ companies)
- By role (software developer, etc.)

✅ **Rich Information**
- Salary ranges
- Tech stack requirements
- Company details
- Affordability analysis
- Suitability scores

✅ **Easy Integration**
- Simple REST API
- JSON responses
- Pagination support
- Error handling

---

## 🎉 Summary

**You now have TWO powerful APIs to fetch IT jobs:**

1. **Live Jobs API** - Real-time job listings by city
   - Endpoint: `/api/live/jobs/city/{city}`
   - Supports 20+ cities
   - Real-time data from JSearch

2. **Local Database API** - Jobs with affordability analysis
   - Endpoint: `/api/jobs?city={city}`
   - Includes cost-of-living breakdown
   - Suitability scores

**Both support filtering by:**
- ✅ City (Bangalore, Mumbai, Pune, etc.)
- ✅ Company (TCS, Infosys, Wipro, etc.)
- ✅ Role (Software Developer, etc.)

**Ready to integrate into your Flutter app!** 🚀

---

*Jobs API - Complete Summary*  
*June 17, 2026*  
*Status: Found and Documented ✅*
