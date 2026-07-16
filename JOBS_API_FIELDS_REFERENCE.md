# Jobs API - Fields Quick Reference

**Get Company Info, Job Description, and Posting Date**

---

## 🎯 What You Want

```
✅ Company Information
✅ Job Description
✅ Posting Date
```

---

## ✅ What You Get

### Live Jobs API Response

```json
{
  "company": "TCS",
  "company_logo": "https://example.com/logo.png",
  "company_website": "https://www.tcs.com",
  "title": "Senior Software Engineer",
  "description": "We are looking for a Senior Software Engineer with 5+ years of experience...",
  "posted_at": "2026-06-17T10:30:00Z",
  "tech_stack": ["Java", "Spring Boot", "Kubernetes"],
  "salary_min": 1200000,
  "salary_max": 1800000
}
```

### Local Database API Response

```json
{
  "companies": {
    "name": "TCS",
    "logo_url": "https://example.com/logo.png",
    "website": "https://www.tcs.com",
    "employee_count": 500000,
    "description": "Tata Consultancy Services is a global IT services company..."
  },
  "title": "Senior Software Engineer",
  "description": "We are seeking a Senior Software Engineer to join our team...",
  "posted_at": "2026-06-17T10:30:00Z",
  "tech_stack": ["Java", "Spring Boot", "Kubernetes"],
  "annual_ctc_min": 1200000,
  "annual_ctc_max": 1800000
}
```

---

## 📊 Field Mapping

### Company Information

| What You Want | Live API Field | Local DB Field |
|---------------|----------------|----------------|
| Company Name | `company` | `companies.name` |
| Company Logo | `company_logo` | `companies.logo_url` |
| Company Website | `company_website` | `companies.website` |
| Employee Count | ❌ Not available | `companies.employee_count` |
| Company Description | ❌ Not available | `companies.description` |

### Job Information

| What You Want | Live API Field | Local DB Field |
|---------------|----------------|----------------|
| Job Title | `title` | `title` |
| Job Description | `description` | `description` |
| Tech Stack | `tech_stack` | `tech_stack` |
| Qualifications | `qualifications` | ❌ Not available |
| Responsibilities | `responsibilities` | ❌ Not available |
| Benefits | `benefits` | ❌ Not available |

### Posting Date

| What You Want | Live API Field | Local DB Field |
|---------------|----------------|----------------|
| Posted Date | `posted_at` | `posted_at` |

---

## 🚀 How to Access in Flutter

### From Live API

```dart
// Company Information
String companyName = job['company'];
String companyLogo = job['company_logo'];
String companyWebsite = job['company_website'];

// Job Description
String jobTitle = job['title'];
String jobDescription = job['description'];
List<String> techStack = List<String>.from(job['tech_stack']);

// Posting Date
String postedAt = job['posted_at'];
```

### From Local Database API

```dart
// Company Information
String companyName = job['companies']['name'];
String companyLogo = job['companies']['logo_url'];
String companyWebsite = job['companies']['website'];
int employeeCount = job['companies']['employee_count'];
String companyDescription = job['companies']['description'];

// Job Description
String jobTitle = job['title'];
String jobDescription = job['description'];
List<String> techStack = List<String>.from(job['tech_stack']);

// Posting Date
String postedAt = job['posted_at'];
```

---

## 📱 Display Example

```dart
// Company Logo
Image.network(job['company_logo'], width: 50, height: 50)

// Company Name
Text(job['company'])

// Company Website
Text(job['company_website'])

// Job Title
Text(job['title'])

// Job Description
Text(job['description'])

// Posted Date
Text('Posted: ${job['posted_at']}')

// Tech Stack
Wrap(
  children: job['tech_stack']
      .map((tech) => Chip(label: Text(tech)))
      .toList(),
)
```

---

## ✨ Complete Example

```json
{
  "id": "job_123",
  "title": "Senior Software Engineer",
  "company": "TCS",
  "company_logo": "https://example.com/tcs-logo.png",
  "company_website": "https://www.tcs.com",
  "city": "Bangalore",
  "description": "We are looking for a Senior Software Engineer with 5+ years of experience in Java and Spring Boot. You will be responsible for designing and implementing scalable microservices architecture, leading a team of developers, and mentoring junior engineers.",
  "posted_at": "2026-06-17T10:30:00Z",
  "tech_stack": ["Java", "Spring Boot", "Kubernetes", "AWS"],
  "salary_min": 1200000,
  "salary_max": 1800000,
  "apply_link": "https://careers.tcs.com/job/123"
}
```

---

## 🎯 API Endpoints

### Get Jobs by City (with all details)
```
GET http://localhost:3001/api/live/jobs/city/Bangalore
```

### Get Jobs with Affordability (with all details)
```
GET http://localhost:3001/api/jobs?city=Bangalore
```

---

## ✅ You Get

✅ **Company Information**
- Name
- Logo
- Website
- Employee count (Local DB only)
- Description (Local DB only)

✅ **Job Description**
- Full description
- Title
- Tech stack
- Qualifications (Live API only)
- Responsibilities (Live API only)
- Benefits (Live API only)

✅ **Posting Date**
- Date and time posted
- Can format as "2 days ago", "Today", etc.

---

*Jobs API - Fields Quick Reference*  
*June 17, 2026*  
*Status: Complete ✅*
