# Jobs API - Detailed Fields Guide

**Date**: June 17, 2026  
**Status**: ✅ **COMPLETE**

---

## 🎯 What You Want

Company information, job description, and posting date for each job

---

## ✅ What You Get

Both APIs provide **ALL** the information you need:

---

## 1️⃣ Live Jobs API - Complete Response

### Endpoint
```
GET /api/live/jobs/city/{city}
```

### Full Response Example

```json
{
  "success": true,
  "city": "Bangalore",
  "total": 25,
  "data": [
    {
      "id": "job_123456",
      "title": "Senior Software Engineer",
      "company": "TCS",
      "company_logo": "https://example.com/tcs-logo.png",
      "company_website": "https://www.tcs.com",
      "city": "Bangalore",
      "state": "Karnataka",
      "country": "India",
      "description": "We are looking for a Senior Software Engineer with 5+ years of experience in Java and Spring Boot. You will be responsible for designing and implementing scalable microservices architecture, leading a team of developers, and mentoring junior engineers. The ideal candidate should have strong problem-solving skills and experience with cloud technologies like AWS or Azure.",
      "employment_type": "Full-time",
      "is_remote": false,
      "salary_min": 1200000,
      "salary_max": 1800000,
      "salary_period": "YEARLY",
      "posted_at": "2026-06-17T10:30:00Z",
      "apply_link": "https://careers.tcs.com/job/123456",
      "tech_stack": [
        "Java",
        "Spring Boot",
        "Kubernetes",
        "AWS",
        "PostgreSQL"
      ],
      "qualifications": [
        "Bachelor's degree in Computer Science",
        "5+ years of software development experience",
        "Strong knowledge of microservices architecture",
        "Experience with cloud platforms"
      ],
      "responsibilities": [
        "Design and implement scalable microservices",
        "Lead a team of 5-8 developers",
        "Mentor junior engineers",
        "Conduct code reviews",
        "Participate in architectural decisions"
      ],
      "benefits": [
        "Health insurance",
        "Stock options",
        "Flexible working hours",
        "Professional development budget",
        "Gym membership"
      ],
      "seniority_level": "Senior",
      "experience_required": 5,
      "source": "jsearch"
    },
    {
      "id": "job_123457",
      "title": "Frontend Developer",
      "company": "Infosys",
      "company_logo": "https://example.com/infosys-logo.png",
      "company_website": "https://www.infosys.com",
      "city": "Bangalore",
      "state": "Karnataka",
      "country": "India",
      "description": "Join our dynamic frontend team and work on cutting-edge web applications. We are looking for a Frontend Developer with expertise in React.js and modern web technologies. You will collaborate with UX designers and backend engineers to build responsive and user-friendly interfaces.",
      "employment_type": "Full-time",
      "is_remote": true,
      "salary_min": 800000,
      "salary_max": 1200000,
      "salary_period": "YEARLY",
      "posted_at": "2026-06-16T14:15:00Z",
      "apply_link": "https://careers.infosys.com/job/123457",
      "tech_stack": [
        "React.js",
        "JavaScript",
        "TypeScript",
        "CSS",
        "Redux"
      ],
      "qualifications": [
        "Bachelor's degree in Computer Science",
        "3+ years of frontend development experience",
        "Strong knowledge of React.js",
        "Understanding of responsive design"
      ],
      "responsibilities": [
        "Develop responsive web interfaces",
        "Optimize application performance",
        "Collaborate with designers and backend team",
        "Write clean and maintainable code"
      ],
      "benefits": [
        "Health insurance",
        "Remote work flexibility",
        "Learning opportunities",
        "Team outings"
      ],
      "seniority_level": "Mid-level",
      "experience_required": 3,
      "source": "jsearch"
    }
  ]
}
```

---

## 2️⃣ Local Database API - Complete Response

### Endpoint
```
GET /api/jobs?city={city}&limit=20
```

### Full Response Example

```json
{
  "data": [
    {
      "id": "4c89bd64-6616-41bd-a655-dda73d10f764",
      "title": "Senior Software Engineer",
      "description": "We are seeking a Senior Software Engineer to join our team. You will work on building scalable backend systems using Java and Spring Boot. The role involves designing microservices, optimizing database queries, and mentoring junior developers. You should have strong problem-solving skills and experience with distributed systems.",
      "city": "Bangalore",
      "annual_ctc_min": 1200000,
      "annual_ctc_max": 1800000,
      "tech_stack": [
        "Java",
        "Spring Boot",
        "Kubernetes",
        "AWS",
        "PostgreSQL"
      ],
      "ats_url": "https://careers.tcs.com/apply/4c89bd64",
      "posted_at": "2026-06-17T10:30:00Z",
      "is_active": true,
      "company_id": "0f363520-7ac2-4dab-87aa-9f13979f75a5",
      "companies": {
        "id": "0f363520-7ac2-4dab-87aa-9f13979f75a5",
        "name": "TCS",
        "logo_url": "https://example.com/tcs-logo.png",
        "website": "https://www.tcs.com",
        "employee_count": 500000,
        "description": "Tata Consultancy Services is a global IT services company providing a wide range of services and solutions to clients across the globe."
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
    },
    {
      "id": "5d90ce75-7727-52ce-b766-eeb84e21g875",
      "title": "Frontend Developer",
      "description": "We are looking for a talented Frontend Developer to create beautiful and responsive user interfaces. You will work with React.js and modern web technologies. The ideal candidate should have experience with state management, API integration, and responsive design principles.",
      "city": "Bangalore",
      "annual_ctc_min": 800000,
      "annual_ctc_max": 1200000,
      "tech_stack": [
        "React.js",
        "JavaScript",
        "TypeScript",
        "CSS",
        "Redux"
      ],
      "ats_url": "https://careers.infosys.com/apply/5d90ce75",
      "posted_at": "2026-06-16T14:15:00Z",
      "is_active": true,
      "company_id": "1g474631-8bd3-5eac-98bb-0g24080g86b6",
      "companies": {
        "id": "1g474631-8bd3-5eac-98bb-0g24080g86b6",
        "name": "Infosys",
        "logo_url": "https://example.com/infosys-logo.png",
        "website": "https://www.infosys.com",
        "employee_count": 300000,
        "description": "Infosys is a global leader in next-generation digital services and consulting."
      },
      "suitabilityScore": {
        "score": 78,
        "level": "Very Good",
        "colorCode": "green"
      },
      "affordability": {
        "score": 82,
        "level": "Very Affordable",
        "colorCode": "green",
        "monthlyExpenses": 38000,
        "remainingMonthly": 62000,
        "breakdown": {
          "rent": 12000,
          "food": 10000,
          "transport": 4000,
          "utilities": 2500,
          "entertainment": 9500
        }
      },
      "affordabilityBadge": "Very Affordable"
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

## 📊 Field Breakdown

### Company Information Fields

| Field | Type | Description | API |
|-------|------|-------------|-----|
| company | string | Company name | Live ✅ |
| company_logo | string | Company logo URL | Live ✅ |
| company_website | string | Company website | Live ✅ |
| companies | object | Full company details | Local DB ✅ |
| companies.name | string | Company name | Local DB ✅ |
| companies.logo_url | string | Company logo URL | Local DB ✅ |
| companies.website | string | Company website | Local DB ✅ |
| companies.employee_count | number | Number of employees | Local DB ✅ |
| companies.description | string | Company description | Local DB ✅ |

### Job Description Fields

| Field | Type | Description | API |
|-------|------|-------------|-----|
| title | string | Job title | Both ✅ |
| description | string | Full job description | Both ✅ |
| qualifications | array | Required qualifications | Live ✅ |
| responsibilities | array | Job responsibilities | Live ✅ |
| tech_stack | array | Required technologies | Both ✅ |
| benefits | array | Job benefits | Live ✅ |
| seniority_level | string | Job level (Junior, Mid, Senior) | Live ✅ |
| experience_required | number | Years of experience needed | Live ✅ |

### Posting Date Fields

| Field | Type | Description | API |
|-------|------|-------------|-----|
| posted_at | datetime | When job was posted | Both ✅ |

---

## 🎯 How to Use in Flutter

### Display Company Information

```dart
class JobCard extends StatelessWidget {
  final Job job;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo and Name
            Row(
              children: [
                // Company Logo
                if (job.companies?.logoUrl != null)
                  Image.network(
                    job.companies!.logoUrl!,
                    width: 50,
                    height: 50,
                  ),
                const SizedBox(width: 12),
                // Company Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.companies?.name ?? 'Unknown Company',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (job.companies?.website != null)
                      Text(
                        job.companies!.website!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Job Title
            Text(
              job.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Job Description
            Text(
              job.description ?? 'No description available',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            
            // Posted Date
            Text(
              'Posted: ${_formatDate(job.postedAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return date.toString().split(' ')[0];
    }
  }
}
```

---

## 📱 Display in Job Detail Page

```dart
class JobDetailScreen extends StatelessWidget {
  final Job job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                children: [
                  // Company Logo
                  if (job.companies?.logoUrl != null)
                    Image.network(
                      job.companies!.logoUrl!,
                      width: 80,
                      height: 80,
                    ),
                  const SizedBox(width: 16),
                  // Company Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.companies?.name ?? 'Company',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (job.companies?.description != null)
                          Text(
                            job.companies!.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        if (job.companies?.employeeCount != null)
                          Text(
                            '${job.companies!.employeeCount} employees',
                            style: TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Job Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Posted Date
                  Text(
                    'Posted: ${_formatDate(job.postedAt)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Job Description
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.description ?? 'No description available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tech Stack
            if (job.techStack != null && job.techStack!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Required Skills',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: job.techStack!
                          .map((tech) => Chip(label: Text(tech)))
                          .toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return date.toString().split(' ')[0];
  }
}
```

---

## 🔄 API Call Example

### Fetch Jobs with All Details

```dart
Future<void> fetchJobsByCity(String city) async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:3001/api/live/jobs/city/$city'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Extract jobs with all details
      List<dynamic> jobsList = data['data'];
      
      for (var jobData in jobsList) {
        print('Company: ${jobData['company']}');
        print('Logo: ${jobData['company_logo']}');
        print('Website: ${jobData['company_website']}');
        print('Job Title: ${jobData['title']}');
        print('Description: ${jobData['description']}');
        print('Posted: ${jobData['posted_at']}');
        print('---');
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## ✨ Summary

### You Get:

**Company Information** ✅
- Company name
- Company logo
- Company website
- Employee count
- Company description

**Job Description** ✅
- Full job description
- Job title
- Required qualifications
- Responsibilities
- Tech stack
- Benefits
- Seniority level

**Posting Date** ✅
- Posted date and time
- Can format as "2 days ago", "Today", etc.

### Both APIs Provide:
✅ Company information  
✅ Job description  
✅ Posting date  
✅ Tech stack  
✅ Salary information  
✅ Location details  

---

*Jobs API - Detailed Fields*  
*June 17, 2026*  
*Status: Complete ✅*
