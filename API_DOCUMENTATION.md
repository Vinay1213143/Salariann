# Salariann API Documentation

Complete API reference for the Salariann backend.

## Base URL

```
http://localhost:3001/api
```

## Authentication

Most endpoints require JWT authentication via Supabase. Include the token in the Authorization header:

```
Authorization: Bearer <JWT_TOKEN>
```

## Response Format

All responses are JSON:

```json
{
  "data": {},
  "error": null,
  "pagination": {}
}
```

## Endpoints

### Health Check

#### `GET /health`

Check if the API is running.

**Response:**
```json
{
  "status": "ok"
}
```

---

## Jobs

### List Jobs

#### `GET /jobs`

List all active jobs with optional filters.

**Query Parameters:**
- `city` (string, optional) - Filter by city
- `role` (string, optional) - Filter by job title
- `limit` (number, default: 20) - Results per page
- `offset` (number, default: 0) - Pagination offset

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "title": "Senior Software Engineer",
      "description": "Job description...",
      "city": "Bangalore",
      "annual_ctc_min": 1500000,
      "annual_ctc_max": 2500000,
      "tech_stack": ["Python", "Django"],
      "ats_url": "https://company.com/apply",
      "posted_at": "2024-05-31T10:00:00Z",
      "is_active": true,
      "company_id": "uuid",
      "companies": {
        "id": "uuid",
        "name": "Tech Company",
        "logo_url": "https://...",
        "website": "https://..."
      },
      "suitabilityScore": {
        "annualCtc": 2000000,
        "netMonthly": 147333,
        "totalExpenses": 27500,
        "disposableIncome": 119833,
        "savingsPercentage": 81.3,
        "score": "GREEN",
        "status": "Comfortable",
        "breakdown": {
          "rent": 15000,
          "food": 8000,
          "commute": 2000,
          "utilities": 2500
        }
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

**Example:**
```bash
curl "http://localhost:3001/api/jobs?city=Bangalore&limit=10"
```

---

### Get Job Details

#### `GET /jobs/:id`

Get detailed information about a specific job including suitability score.

**Response:**
```json
{
  "id": "uuid",
  "title": "Senior Software Engineer",
  "description": "...",
  "city": "Bangalore",
  "annual_ctc_min": 1500000,
  "annual_ctc_max": 2500000,
  "tech_stack": ["Python", "Django"],
  "ats_url": "https://company.com/apply",
  "posted_at": "2024-05-31T10:00:00Z",
  "is_active": true,
  "company_id": "uuid",
  "companies": {
    "id": "uuid",
    "name": "Tech Company",
    "logo_url": "https://...",
    "website": "https://...",
    "employee_count": 5000,
    "description": "..."
  },
  "suitabilityScore": { ... },
  "cityMetrics": {
    "id": "uuid",
    "city_name": "Bangalore",
    "avg_rent": 15000,
    "avg_food": 8000,
    "avg_commute": 2000,
    "avg_utilities": 2500,
    "lifestyle": "single"
  }
}
```

**Example:**
```bash
curl "http://localhost:3001/api/jobs/550e8400-e29b-41d4-a716-446655440000"
```

---

### Create Job

#### `POST /jobs`

Create a new job listing. **Requires authentication.**

**Request Body:**
```json
{
  "company_id": "uuid",
  "title": "Senior Software Engineer",
  "description": "Job description...",
  "city": "Bangalore",
  "annual_ctc_min": 1500000,
  "annual_ctc_max": 2500000,
  "tech_stack": ["Python", "Django"],
  "ats_url": "https://company.com/apply"
}
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "company_id": "uuid",
      "title": "Senior Software Engineer",
      ...
    }
  ]
}
```

---

### Log Job Click

#### `POST /jobs/click`

Log when a user clicks "Apply" to track engagement.

**Request Body:**
```json
{
  "job_id": "uuid"
}
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "job_id": "uuid",
      "clicked_at": "2024-05-31T10:00:00Z"
    }
  ]
}
```

---

## Companies

### List Companies

#### `GET /companies`

List all companies with optional search.

**Query Parameters:**
- `search` (string, optional) - Search by company name
- `city` (string, optional) - Filter by city
- `limit` (number, default: 20) - Results per page
- `offset` (number, default: 0) - Pagination offset

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Tech Company",
      "logo_url": "https://...",
      "website": "https://...",
      "employee_count": 5000,
      "description": "...",
      "city": "Bangalore",
      "founded_year": 2010
    }
  ],
  "pagination": {
    "total": 50,
    "limit": 20,
    "offset": 0
  }
}
```

---

### Get Company Details

#### `GET /companies/:id`

Get detailed company information with stats and related data.

**Response:**
```json
{
  "id": "uuid",
  "name": "Tech Company",
  "logo_url": "https://...",
  "website": "https://...",
  "employee_count": 5000,
  "description": "...",
  "city": "Bangalore",
  "founded_year": 2010,
  "stats": {
    "jobCount": 15,
    "reviewCount": 42,
    "salaryDataCount": 28,
    "interviewCount": 35,
    "avgRating": "4.2"
  },
  "jobs": [...],
  "reviews": [...],
  "salaries": [...],
  "interviews": [...]
}
```

---

### Create Company

#### `POST /companies`

Create a new company. **Requires authentication.**

**Request Body:**
```json
{
  "name": "Tech Company",
  "logo_url": "https://...",
  "website": "https://...",
  "employee_count": 5000,
  "description": "...",
  "city": "Bangalore",
  "founded_year": 2010
}
```

---

## Reviews

### Get Company Reviews

#### `GET /companies/:company_id/reviews`

Get all reviews for a company.

**Query Parameters:**
- `limit` (number, default: 20)
- `offset` (number, default: 0)

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "company_id": "uuid",
      "overall_rating": 4.5,
      "work_life_balance": 4.0,
      "skill_development": 4.5,
      "management": 3.5,
      "pros": "Good learning opportunities...",
      "cons": "Long working hours...",
      "created_at": "2024-05-31T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 42,
    "limit": 20,
    "offset": 0
  }
}
```

---

### Create Review

#### `POST /reviews`

Submit a review for a company. **Requires authentication.**

**Request Body:**
```json
{
  "company_id": "uuid",
  "overall_rating": 4.5,
  "work_life_balance": 4.0,
  "skill_development": 4.5,
  "management": 3.5,
  "pros": "Good learning opportunities...",
  "cons": "Long working hours..."
}
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "company_id": "uuid",
      "overall_rating": 4.5,
      ...
    }
  ]
}
```

---

### Update Review

#### `PUT /reviews/:id`

Update your own review. **Requires authentication.**

**Request Body:**
```json
{
  "overall_rating": 4.0,
  "work_life_balance": 3.5,
  "skill_development": 4.5,
  "management": 3.5,
  "pros": "Updated pros...",
  "cons": "Updated cons..."
}
```

---

## Salaries

### Get Company Salaries

#### `GET /companies/:company_id/salaries`

Get salary data for a company.

**Query Parameters:**
- `role` (string, optional) - Filter by role
- `limit` (number, default: 20)
- `offset` (number, default: 0)

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "company_id": "uuid",
      "role": "Senior Software Engineer",
      "annual_ctc": 2000000,
      "experience_years": 5,
      "is_anonymous": true,
      "created_at": "2024-05-31T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 28,
    "limit": 20,
    "offset": 0
  }
}
```

---

### Contribute Salary

#### `POST /salaries`

Submit anonymous salary data. **Requires authentication.**

**Request Body:**
```json
{
  "company_id": "uuid",
  "role": "Senior Software Engineer",
  "annual_ctc": 2000000,
  "experience_years": 5,
  "is_anonymous": true
}
```

---

### Get Salary Statistics

#### `GET /salaries/stats`

Get salary statistics for a company and role.

**Query Parameters:**
- `company_id` (string, optional)
- `role` (string, optional)

**Response:**
```json
{
  "count": 28,
  "avg": 1850000,
  "min": 1200000,
  "max": 2800000
}
```

---

## Interviews

### Get Company Interviews

#### `GET /companies/:company_id/interviews`

Get interview experiences for a company.

**Query Parameters:**
- `role` (string, optional) - Filter by role
- `limit` (number, default: 20)
- `offset` (number, default: 0)

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user_id": "uuid",
      "company_id": "uuid",
      "role": "Senior Software Engineer",
      "difficulty": 4,
      "questions": {
        "round1": ["Question 1", "Question 2"],
        "round2": ["Question 3"]
      },
      "experience_text": "The interview was challenging...",
      "result": "selected",
      "created_at": "2024-05-31T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 35,
    "limit": 20,
    "offset": 0
  }
}
```

---

### Share Interview Experience

#### `POST /interviews`

Submit interview experience. **Requires authentication.**

**Request Body:**
```json
{
  "company_id": "uuid",
  "role": "Senior Software Engineer",
  "difficulty": 4,
  "questions": {
    "round1": ["Question 1", "Question 2"],
    "round2": ["Question 3"]
  },
  "experience_text": "The interview was challenging...",
  "result": "selected"
}
```

---

### Update Interview

#### `PUT /interviews/:id`

Update your interview experience. **Requires authentication.**

**Request Body:**
```json
{
  "difficulty": 3,
  "questions": {...},
  "experience_text": "Updated experience...",
  "result": "selected"
}
```

---

## Error Handling

All errors return appropriate HTTP status codes:

```json
{
  "error": "Error message describing what went wrong"
}
```

**Common Status Codes:**
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

---

## Rate Limiting

Currently no rate limiting is implemented. This should be added for production.

---

## Pagination

List endpoints support pagination:

```
GET /api/jobs?limit=20&offset=0
```

- `limit` - Number of results (default: 20, max: 100)
- `offset` - Number of results to skip (default: 0)

Response includes pagination metadata:
```json
{
  "pagination": {
    "total": 150,
    "limit": 20,
    "offset": 0
  }
}
```

---

## Suitability Score Calculation

The suitability score is calculated based on:

1. **Annual CTC** - Job salary
2. **Net Monthly Income** - (Annual CTC / 12) × 0.88 (after 12% tax/EPF)
3. **City Expenses** - Rent + Food + Commute + Utilities
4. **Disposable Income** - Net Monthly - Expenses
5. **Savings %** - (Disposable / Net Monthly) × 100

**Score Levels:**
- **GREEN** - Savings > 30% (Comfortable)
- **YELLOW** - Savings 10-30% (Manageable)
- **RED** - Savings < 10% (High stress)

---

## Example Requests

### Get Jobs in Bangalore

```bash
curl "http://localhost:3001/api/jobs?city=Bangalore&limit=10"
```

### Get Company Details

```bash
curl "http://localhost:3001/api/companies/550e8400-e29b-41d4-a716-446655440000"
```

### Submit a Review (with auth)

```bash
curl -X POST "http://localhost:3001/api/reviews" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "company_id": "uuid",
    "overall_rating": 4.5,
    "work_life_balance": 4.0,
    "skill_development": 4.5,
    "management": 3.5,
    "pros": "Good learning",
    "cons": "Long hours"
  }'
```

### Get Salary Statistics

```bash
curl "http://localhost:3001/api/salaries/stats?company_id=uuid&role=Senior%20Software%20Engineer"
```

---

## Testing

Use Postman, Insomnia, or curl to test endpoints:

```bash
# Test health
curl http://localhost:3001/api/health

# Get jobs
curl http://localhost:3001/api/jobs

# Get companies
curl http://localhost:3001/api/companies
```

---

## Support

For API issues, check:
1. Backend logs: `npm run dev`
2. Supabase logs: `docker compose logs`
3. Network connectivity: `curl http://localhost:3001/api/health`
