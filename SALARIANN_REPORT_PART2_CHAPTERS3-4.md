# SALARIANN: INTELLIGENT JOB SEARCH AND CAREER ANALYSIS PLATFORM
## PART 2: CHAPTERS 3-4

---

## CHAPTER 3: PROPOSED SYSTEM

### 3.1 System Overview

Salariann is a full-stack web application designed to integrate job discovery, cost-of-living analysis, and personalized career insights into a unified platform. The system architecture comprises four primary layers:

1. **Frontend Layer**: A responsive Flutter web application providing an intuitive user interface for job search, filtering, and career analysis.

2. **Backend API Layer**: A Node.js/Express server implementing RESTful endpoints for job management, user authentication, and data aggregation.

3. **AI/ML Services Layer**: Integration points for external APIs (JSearch, Numbeo) and internal algorithms for affordability scoring and recommendation generation.

4. **Data Persistence Layer**: A Supabase PostgreSQL database storing user profiles, job listings, cost-of-living data, and user interactions.

**Figure 3.1: High-Level System Architecture Overview**

The system is organized in four distinct layers communicating through well-defined interfaces:

- **Frontend Layer** (Flutter Web): Provides user interface for job search, filtering, and career analysis. Communicates with backend via HTTP/REST and JSON.

- **Backend API Layer** (Node.js/Express): Implements RESTful endpoints for job management, user authentication, and data aggregation. Integrates with external APIs (JSearch, Numbeo) and internal algorithms.

- **AI/ML Services Layer**: Includes JSearch API for job data, Numbeo API for cost-of-living data, and internal affordability scoring algorithms.

- **Data Persistence Layer** (Supabase PostgreSQL): Stores user profiles, job listings, cost-of-living data, and user interactions.

**Data Exchanged at Each Boundary:**

- **Frontend ↔ Backend**: User input (search queries, filters, preferences) → Backend; Job listings, affordability scores, user profile data → Frontend.
- **Backend ↔ External APIs**: Search queries → JSearch API; City names → Numbeo; Job data, cost data → Backend.
- **Backend ↔ Database**: CRUD operations on users, jobs, cost-of-living records; User authentication tokens; Analytics events.

### 3.2 System Components

#### 3.2.1 Job Discovery Module

The Job Discovery Module aggregates real-time job listings from multiple sources, normalizes heterogeneous data formats, and exposes a unified job catalog through RESTful endpoints.

**Responsibilities:**
- Fetch live job listings from the JSearch API based on user search queries, location filters, and company preferences.
- Transform raw API responses into a standardized internal job schema, ensuring consistent field mapping across sources.
- Implement pagination and caching strategies to optimize API usage and reduce latency.
- Provide filtering and sorting capabilities on job attributes (role, company, salary range, tech stack, posting date).

#### 3.2.2 Affordability Analysis Module

The Affordability Analysis Module integrates real-time cost-of-living data with salary information to produce personalized affordability scores.

**Responsibilities:**
- Scrape current cost-of-living data from Numbeo for supported Indian cities, extracting rent, grocery, transportation, and utility costs.
- Implement an in-memory cache with configurable TTL (Time-To-Live) to minimize redundant API calls while maintaining data freshness.
- Calculate city-specific expense profiles based on user lifestyle preferences (single vs. family, urban vs. suburban).
- Compute affordability scores using a proprietary formula that correlates salary with cost of living.

**Affordability Score Formula:**

Let:
- S = Annual salary (in INR)
- C = Annual cost of living (in INR)
- D = Disposable income = S - C
- T = Target disposable income threshold (user-defined, default ₹10 lakhs/year)

**Affordability Score = min(100, (D / T) × 100)**

This formula yields a score from 0-100, where 100 represents excellent affordability (disposable income exceeds target) and 0 represents poor affordability (salary insufficient to cover living expenses). The score is capped at 100 to prevent unbounded values for exceptionally high salaries.

#### 3.2.3 Career Insights Module

The Career Insights Module correlates job offers with user preferences, salary trends, and company reputation to generate personalized recommendations and career trajectory projections.

**Responsibilities:**
- Aggregate salary data across roles, companies, and experience levels to identify market trends and growth trajectories.
- Implement a suitability scoring algorithm that ranks jobs based on user skills, experience, and career goals.
- Generate personalized job recommendations using collaborative filtering and content-based similarity metrics.
- Provide company analytics including average salaries, review ratings, growth rates, and tech stack preferences.

#### 3.2.4 User Management and Authentication Module

The User Management Module handles user registration, authentication, profile management, and personalization preferences.

**Responsibilities:**
- Implement JWT-based authentication with secure token generation and validation.
- Store user profiles including personal information, career preferences, lifestyle choices, and saved jobs.
- Manage user sessions and provide logout functionality with token revocation.
- Track user interactions (job views, applications, saves) for analytics and recommendation personalization.

### 3.3 AI Integration and Data Flow

Salariann integrates AI and machine learning at three critical points in the pipeline:

**3.3.1 Automated Data Alignment**

The system automatically aligns heterogeneous job data from multiple sources (JSearch API, internal database) into a unified schema. This involves:
- Mapping API field names to internal field names using predefined transformation rules.
- Handling missing or null values through intelligent defaults (e.g., if salary_max is missing, estimate from salary_min and typical market ranges).
- Detecting and merging duplicate job listings from multiple sources using fuzzy string matching on job title, company, and location.

**3.3.2 Affordability-Driven Ranking**

Rather than ranking jobs by recency or popularity (as traditional job boards do), Salariann ranks results by affordability score, ensuring that the most financially viable opportunities appear first. This is a fundamental departure from existing platforms and directly addresses the research gap identified in Chapter 2.

**3.3.3 Iterative Recommendation Refinement**

The system implements a feedback loop where user interactions (job views, applications, saves) are collected and used to refine recommendation models. Over time, the system learns user preferences and improves recommendation relevance without requiring explicit feedback.

### 3.4 Detailed Workflow of the System

The following numbered steps trace a complete user journey from initial login through job discovery and application:

1. **User Authentication**: The user navigates to the Salariann home page and signs in using email and password. The frontend sends credentials to the backend `/auth/login` endpoint. The backend validates credentials against the Supabase auth service and returns a JWT token if authentication succeeds.

2. **Profile Setup**: On first login, the user completes a profile questionnaire specifying lifestyle preferences (single vs. family), desired salary range, preferred cities, and tech stack expertise. This information is stored in the users table and used for personalization.

3. **Job Search Initiation**: The user enters a search query (e.g., "Senior Software Engineer") and selects one or more cities. The frontend sends a GET request to `/api/live/jobs/city/{city}?query={query}` with the user's JWT token.

4. **Real-Time Job Aggregation**: The backend receives the request and calls the JSearch API with the search query and city filter. JSearch returns up to 100 matching job listings with detailed metadata (title, company, salary, description, tech stack).

5. **Data Transformation**: The backend transforms raw JSearch responses into the internal job schema, mapping API fields to database fields and extracting key attributes (salary_min, salary_max, tech_stack, posting_date).

6. **Cost-of-Living Lookup**: For each job's city, the backend checks the in-memory cache for current cost-of-living data. If cached data is fresh (within TTL), it is used; otherwise, the system scrapes Numbeo to fetch updated data and refreshes the cache.

7. **Affordability Scoring**: The backend computes an affordability score for each job using the user's salary preferences and the city's cost-of-living profile. Jobs are sorted by affordability score in descending order.

8. **Response Formatting**: The backend returns a JSON response containing the sorted job list, each job including title, company, salary range, affordability score, and a link to the full job details. The frontend receives this response and renders job cards in the UI.

9. **Job Selection and Details**: The user clicks on a job card to view full details. The frontend navigates to `/jobs/{jobId}` and fetches detailed information including full job description, company profile, salary breakdown, and user reviews. The system logs this interaction for analytics and recommendation refinement.

10. **Application or Save**: The user either applies for the job (if the platform supports direct applications) or saves the job for later review. The frontend sends a POST request to `/api/jobs/{jobId}/save` or `/api/jobs/{jobId}/apply`, and the backend records this interaction in the user_job_interactions table.

---

## CHAPTER 4: SYSTEM DESIGN

### 4.1 System Architecture Diagram

**Figure 4.1: Detailed System Architecture Diagram**

The detailed system architecture comprises:

- **Frontend Layer** (Flutter Web Framework): Includes Provider for state management, GoRouter for navigation, Material Design components, and HTTP client for API communication.

- **Backend API Layer** (Node.js/Express Server, Port 3001): Includes Express.js framework with route handlers, middleware for authentication and error handling, controllers implementing business logic, and utility functions for data transformation and caching.

- **External Services**: JSearch API (RapidAPI) for job search and details, Numbeo API for cost-of-living data via web scraping, Supabase Auth for user authentication and JWT token verification.

- **Data Persistence Layer** (Supabase PostgreSQL Database): Includes users table, jobs table, companies table, cost_of_living table, user_job_interactions table, and reviews table.

**Protocol Specifications at Each Boundary:**

- **Frontend ↔ Backend**: HTTP/REST with JSON payloads. All requests include JWT token in Authorization header. Responses include standard HTTP status codes (200, 201, 400, 401, 404, 500).
- **Backend ↔ JSearch API**: HTTP/REST with JSON payloads. Requests include RapidAPI key in x-rapidapi-key header. Rate-limited to 100 requests/day.
- **Backend ↔ Numbeo**: HTTP GET requests with User-Agent header (to bypass bot detection). Responses are HTML, parsed using cheerio library.
- **Backend ↔ Supabase**: Supabase client library (JavaScript) handles SQL query construction and execution. Requests are authenticated using service key.

### 4.2 Data Flow Diagram

#### 4.2.1 Level 0 Context Diagram

**Figure 4.2: Context Diagram (Level 0 DFD)**

The context diagram shows:
- **External Entity 1**: IT Professional (End User) providing search queries, job filters, and user profile preferences.
- **Central Process**: SALARIANN System processing user input and returning job listings, affordability scores, and recommendations.
- **External Entity 2**: JSearch API and Numbeo API providing job data and cost-of-living information respectively.

#### 4.2.2 Level 1 Detailed Data Flow Diagram

**Figure 4.3: Detailed Data Flow Diagram (Level 1 DFD)**

The detailed DFD comprises five main processes:

1. **User Input Processing**: Validates search query and filters, extracts city, role, salary range, and tech stack, outputs normalized search parameters.

2. **Job Aggregation**: Calls JSearch API with parameters, fetches live job listings, outputs raw job data from JSearch.

3. **Data Transformation**: Maps JSearch fields to internal schema, extracts salary_min, salary_max, tech_stack, normalizes company names and locations, outputs standardized job records.

4. **Cost-of-Living Lookup**: Checks in-memory cache for cost data, queries Numbeo if cache miss, outputs cost profile for each city.

5. **Affordability Scoring**: Computes affordability score for each job, applies user preferences, sorts jobs by affordability score, outputs ranked job list.

**Data Stores:**
- **D1: Job Database**: Stores job records indexed by city and role.
- **D2: User Preferences**: Stores lifestyle choices, salary targets, and saved jobs.

### 4.3 UML Diagrams

#### 4.3.1 Use Case Diagram

**Figure 4.4: Use Case Diagram**

The use case diagram includes:
- **System Boundary**: SALARIANN System
- **Primary Actor**: IT Professional
- **Secondary Actor**: External APIs (JSearch, Numbeo)
- **Use Cases**:
  - UC1: Search Jobs
  - UC2: View Job Details
  - UC3: Calculate Affordability
  - UC4: Save Job
  - UC5: View Career Insights

#### 4.3.2 Class Diagram

**Figure 4.5: Class Diagram**

The class diagram includes five main classes:

1. **User Class**: Attributes (id, email, displayName, lifestyle, preferences), Methods (signUp, login, updateProfile, getPreferences)

2. **Job Class**: Attributes (id, title, company, salaryMin, salaryMax, city, techStack, description, postingDate), Methods (getDetails, calculateScore, getCompanyInfo, applyNow)

3. **Company Class**: Attributes (id, name, logoUrl, website, description, avgRating), Methods (getProfile, getReviews, getSalaryData, getJobs)

4. **CostOfLiving Class**: Attributes (id, city, rent, grocery, transport, utilities, total, lastUpdated), Methods (getProfile, updateData, calculateExpense, getBreakdown)

5. **AffordabilityScore Class**: Attributes (jobId, userId, score, disposableIncome, breakdown), Methods (calculate, getBreakdown, compare, getRank)

**Relationships**: User has-a Job, Job references Company, Job references CostOfLiving, AffordabilityScore correlates User and Job.

**Table 4.1: Key Classes and Their Responsibilities**

| Class | Attributes | Methods | Responsibility |
|-------|-----------|---------|-----------------|
| User | id, email, displayName, lifestyle, preferences | signUp(), login(), updateProfile(), getPreferences() | Manage user identity, authentication, and personalization settings |
| Job | id, title, company, salaryMin, salaryMax, city, techStack, description, postingDate | getDetails(), calculateScore(), getCompanyInfo(), applyNow() | Represent job listings with complete metadata and enable job discovery |
| Company | id, name, logoUrl, website, description, avgRating | getProfile(), getReviews(), getSalaryData(), getJobs() | Store company information and provide company-level analytics |
| CostOfLiving | id, city, rent, grocery, transport, utilities, total, lastUpdated | getProfile(), updateData(), calculateExpense(), getBreakdown() | Maintain current cost-of-living data and enable affordability calculations |
| AffordabilityScore | jobId, userId, score, disposableIncome, breakdown | calculate(), getBreakdown(), compare(), getRank() | Compute and manage affordability scores for personalized job ranking |

#### 4.3.3 Sequence Diagram

**Figure 4.6: Sequence Diagram**

The sequence diagram traces a complete user interaction:

1. User submits search query to Frontend
2. Frontend sends HTTP GET request to Backend (/api/jobs)
3. Backend validates query and extracts parameters
4. Backend calls JSearch API with search parameters
5. JSearch API returns job data
6. Backend extracts city information from jobs
7. Backend checks cache for cost-of-living data
8. If cache miss, Backend scrapes Numbeo API
9. Numbeo returns cost-of-living data
10. Backend calculates affordability scores for each job
11. Backend sorts jobs by affordability score
12. Backend formats JSON response
13. Frontend receives and displays results to User

#### 4.3.4 Activity Diagram

**Figure 4.7: Activity Diagram**

The activity diagram shows the workflow:

1. **Start Session**
2. **User Enters Search Query**
3. **Validate Input** → Decision: Valid Input?
   - If No: Show Error Message → Return to Search
   - If Yes: Continue
4. **Call JSearch API**
5. **Transform Data**
6. **Extract Cities**
7. **Fetch Cost Data**
8. **Decision: Data Available?**
   - If No: Use Fallback Cost Data
   - If Yes: Continue
9. **Calculate Affordability Scores**
10. **Sort Jobs by Affordability**
11. **Decision: User Selects Job?**
    - Option A: View Details → Fetch Full Job Details
    - Option B: Save Job → Save to Database
12. **Return to Search Results**
13. **End Session**

### 4.4 Database and Storage Design

**Table 4.2: Database Schema and Storage Strategy**

| Collection/Table | Data Paradigm | Description & Key Fields |
|------------------|---------------|--------------------------|
| users | Relational (PostgreSQL) | Stores user profiles and authentication data. Key fields: id (UUID, PK), email (unique), password_hash, display_name, lifestyle (enum: single/family), preferences (JSON), created_at, updated_at. |
| jobs | Relational (PostgreSQL) | Stores job listings aggregated from JSearch and local postings. Key fields: id (UUID, PK), title, company_id (FK), description, salary_min, salary_max, city, tech_stack (array), posting_date, source (jsearch/local), is_active. |
| companies | Relational (PostgreSQL) | Stores company information. Key fields: id (UUID, PK), name (unique), logo_url, website, description, avg_rating, employee_count, founded_year. |
| cost_of_living | Relational (PostgreSQL) | Stores cost-of-living data per city. Key fields: id (UUID, PK), city (unique), rent_1br_center, rent_1br_outside, grocery_monthly, transport_monthly, utilities, dining_out, entertainment, total_monthly, currency, last_updated. |
| user_job_interactions | Relational (PostgreSQL) | Tracks user interactions with jobs for analytics. Key fields: id (UUID, PK), user_id (FK), job_id (FK), action (view/save/apply), timestamp. |
| reviews | Relational (PostgreSQL) | Stores user-submitted company reviews. Key fields: id (UUID, PK), company_id (FK), user_id (FK), rating (1-5), content, helpful_count, created_at. |

**Figure 4.8: Entity Relationship Diagram**

The ERD shows:
- **users** table with 1:N relationship to user_job_interactions and reviews
- **jobs** table with N:1 relationship to companies and cost_of_living
- **companies** table with 1:N relationship to jobs and reviews
- **cost_of_living** table with 1:N relationship to jobs
- **user_job_interactions** table with N:1 relationships to users and jobs
- **reviews** table with N:1 relationships to users and companies

---

**END OF PART 2**

*This document contains Chapters 3-4 of the Salariann Project Report.*  
*Continue with Part 3 for Chapters 5-6.*
