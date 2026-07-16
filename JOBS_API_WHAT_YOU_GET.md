# Jobs API - What You Get

**Date**: June 17, 2026  
**Status**: ✅ **COMPLETE**

---

## 🎯 Your Request

"In this we want company information, each job description, and the date the job is posted"

---

## ✅ What You Get

### From Live Jobs API
```
GET /api/live/jobs/city/Bangalore
```

**Company Information** ✅
- Company name
- Company logo (URL)
- Company website

**Job Description** ✅
- Full job description
- Job title
- Required tech stack
- Qualifications
- Responsibilities
- Benefits
- Seniority level

**Posting Date** ✅
- Posted date and time (ISO format)

---

### From Local Database API
```
GET /api/jobs?city=Bangalore
```

**Company Information** ✅
- Company name
- Company logo (URL)
- Company website
- Employee count
- Company description

**Job Description** ✅
- Full job description
- Job title
- Required tech stack
- Salary range
- Affordability analysis

**Posting Date** ✅
- Posted date and time (ISO format)

---

## 📊 Complete Response Example

```json
{
  "success": true,
  "city": "Bangalore",
  "total": 25,
  "data": [
    {
      "id": "job_123",
      "title": "Senior Software Engineer",
      
      // COMPANY INFORMATION
      "company": "TCS",
      "company_logo": "https://example.com/tcs-logo.png",
      "company_website": "https://www.tcs.com",
      
      // JOB DESCRIPTION
      "description": "We are looking for a Senior Software Engineer with 5+ years of experience in Java and Spring Boot. You will be responsible for designing and implementing scalable microservices architecture, leading a team of developers, and mentoring junior engineers. The ideal candidate should have strong problem-solving skills and experience with cloud technologies like AWS or Azure.",
      
      // POSTING DATE
      "posted_at": "2026-06-17T10:30:00Z",
      
      // ADDITIONAL DETAILS
      "city": "Bangalore",
      "salary_min": 1200000,
      "salary_max": 1800000,
      "tech_stack": ["Java", "Spring Boot", "Kubernetes", "AWS"],
      "employment_type": "Full-time",
      "is_remote": false,
      "qualifications": [
        "Bachelor's degree in Computer Science",
        "5+ years of software development experience",
        "Strong knowledge of microservices architecture"
      ],
      "responsibilities": [
        "Design and implement scalable microservices",
        "Lead a team of 5-8 developers",
        "Mentor junior engineers",
        "Conduct code reviews"
      ],
      "benefits": [
        "Health insurance",
        "Stock options",
        "Flexible working hours"
      ],
      "apply_link": "https://careers.tcs.com/job/123"
    }
  ]
}
```

---

## 🎯 How to Display

### Job Card Layout

```
┌─────────────────────────────────────┐
│ [TCS Logo] TCS                      │
│            https://www.tcs.com      │
├─────────────────────────────────────┤
│ Senior Software Engineer             │
│ Posted: 2 days ago                  │
├─────────────────────────────────────┤
│ Description:                        │
│ We are looking for a Senior         │
│ Software Engineer with 5+ years...  │
├─────────────────────────────────────┤
│ Skills: Java, Spring Boot, AWS      │
│ Salary: ₹12-18 LPA                  │
│ [Apply Now]                         │
└─────────────────────────────────────┘
```

---

## 💻 Flutter Code

### Display Company Information

```dart
// Company Logo
Image.network(
  job['company_logo'],
  width: 50,
  height: 50,
)

// Company Name
Text(
  job['company'],
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
)

// Company Website
Text(
  job['company_website'],
  style: TextStyle(
    color: Colors.blue,
    fontSize: 12,
  ),
)
```

### Display Job Description

```dart
// Job Title
Text(
  job['title'],
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
)

// Job Description
Text(
  job['description'],
  style: TextStyle(
    fontSize: 14,
    color: Colors.grey[700],
  ),
)

// Tech Stack
Wrap(
  spacing: 8,
  children: (job['tech_stack'] as List)
      .map((tech) => Chip(label: Text(tech)))
      .toList(),
)
```

### Display Posting Date

```dart
// Posted Date
Text(
  'Posted: ${_formatDate(job['posted_at'])}',
  style: TextStyle(
    fontSize: 12,
    color: Colors.grey[600],
  ),
)

// Helper function to format date
String _formatDate(String dateString) {
  final date = DateTime.parse(dateString);
  final now = DateTime.now();
  final difference = now.difference(date);
  
  if (difference.inDays == 0) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return dateString.split('T')[0];
  }
}
```

---

## 📋 Field Checklist

### Company Information
- ✅ Company name
- ✅ Company logo
- ✅ Company website
- ✅ Employee count (Local DB)
- ✅ Company description (Local DB)

### Job Description
- ✅ Job title
- ✅ Full description
- ✅ Tech stack
- ✅ Qualifications
- ✅ Responsibilities
- ✅ Benefits
- ✅ Seniority level

### Posting Date
- ✅ Posted date and time
- ✅ Can format as relative time ("2 days ago")

---

## 🚀 API Endpoints

### Get Jobs by City (Live)
```
GET http://localhost:3001/api/live/jobs/city/Bangalore
```

### Get Jobs with Affordability (Local DB)
```
GET http://localhost:3001/api/jobs?city=Bangalore
```

### Get Jobs by Company
```
GET http://localhost:3001/api/live/jobs/company/TCS
```

---

## 📊 Comparison

| Information | Live API | Local DB |
|-------------|----------|----------|
| Company name | ✅ | ✅ |
| Company logo | ✅ | ✅ |
| Company website | ✅ | ✅ |
| Employee count | ❌ | ✅ |
| Job description | ✅ | ✅ |
| Tech stack | ✅ | ✅ |
| Qualifications | ✅ | ❌ |
| Responsibilities | ✅ | ❌ |
| Benefits | ✅ | ❌ |
| Posting date | ✅ | ✅ |
| Salary | ✅ | ✅ |
| Affordability | ❌ | ✅ |

---

## ✨ Summary

**You get EVERYTHING you need:**

✅ **Company Information**
- Name, logo, website
- Employee count, description

✅ **Job Description**
- Full description, title
- Tech stack, qualifications
- Responsibilities, benefits

✅ **Posting Date**
- Date and time posted
- Can format as relative time

**Ready to display in your app!** 🚀

---

*Jobs API - What You Get*  
*June 17, 2026*  
*Status: Complete ✅*
