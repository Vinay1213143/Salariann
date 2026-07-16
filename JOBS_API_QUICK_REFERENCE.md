# Jobs API - Quick Reference

**Get all IT jobs in any city with one API call!**

---

## 🎯 Main API Endpoints

### Get Jobs by City (LIVE JOBS)
```
GET /api/live/jobs/city/{city}
```

**Example**:
```
http://localhost:3001/api/live/jobs/city/Bangalore
http://localhost:3001/api/live/jobs/city/Mumbai
http://localhost:3001/api/live/jobs/city/Pune
```

**Response**: List of IT jobs in that city with salary, company, tech stack, etc.

---

### Get All Jobs (WITH AFFORDABILITY)
```
GET /api/jobs?city={city}&limit=20
```

**Example**:
```
http://localhost:3001/api/jobs?city=Bangalore&limit=20
```

**Response**: Jobs with affordability analysis and suitability scores

---

### Get Jobs by Company
```
GET /api/live/jobs/company/{company}
```

**Example**:
```
http://localhost:3001/api/live/jobs/company/TCS
http://localhost:3001/api/live/jobs/company/Infosys
http://localhost:3001/api/live/jobs/company/Wipro
```

---

## 🏙️ Supported Cities

```
Bangalore, Mumbai, Delhi, Hyderabad, Pune,
Chennai, Kolkata, Noida, Gurgaon, Ahmedabad,
Jaipur, Chandigarh, Kochi, Indore, Lucknow,
Coimbatore, Thiruvananthapuram, Nagpur, 
Visakhapatnam, Bhubaneswar
```

---

## 🏢 Supported Companies

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

## 📊 Response Example

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
      "city": "Bangalore",
      "salary_min": 1200000,
      "salary_max": 1800000,
      "salary_period": "YEARLY",
      "employment_type": "Full-time",
      "tech_stack": ["Java", "Spring Boot", "Kubernetes"],
      "posted_at": "2026-06-17T10:00:00Z",
      "apply_link": "https://..."
    }
  ]
}
```

---

## 🚀 Usage in Flutter

```dart
// Fetch jobs for a city
final response = await http.get(
  Uri.parse('http://localhost:3001/api/live/jobs/city/Bangalore'),
);

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  List jobs = data['data'];
  // Use jobs in your app
}
```

---

## ✨ Key Features

✅ Real-time job listings  
✅ Filter by city (20+ cities)  
✅ Filter by company (40+ companies)  
✅ Salary information  
✅ Tech stack requirements  
✅ Company details  
✅ Application links  
✅ Affordability analysis (local DB)  
✅ Suitability scores (local DB)  

---

## 🎯 Use Cases

1. **Home Page**: Show jobs in user's city
2. **Jobs Page**: Filter by city and company
3. **City Selection**: Browse jobs in different cities
4. **Company Search**: Find jobs at specific company
5. **Job Details**: View full job information

---

**Ready to use! Start fetching IT jobs for your app!** 🚀
