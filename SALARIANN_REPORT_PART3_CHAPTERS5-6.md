# SALARIANN: INTELLIGENT JOB SEARCH AND CAREER ANALYSIS PLATFORM
## PART 3: CHAPTERS 5-6

---

## CHAPTER 5: TECHNOLOGY AND TOOLS OVERVIEW

### 5.1 Programming Languages

**Flutter (Dart)**

Dart is the programming language for the Flutter framework, chosen for the frontend because it enables rapid development of responsive, visually appealing interfaces with a single codebase deployable across web, iOS, and Android. Dart's strong typing system, null safety features, and hot-reload capability significantly accelerate development cycles. The language's async/await syntax simplifies asynchronous API calls, critical for maintaining responsive UI while fetching job data and cost-of-living information.

**Node.js (JavaScript/TypeScript)**

Node.js was selected for the backend because of its non-blocking I/O model, which is ideal for handling concurrent API requests from multiple users. JavaScript's event-driven architecture enables efficient management of simultaneous connections to external APIs (JSearch, Numbeo) and the database. The vast npm ecosystem provides mature libraries for authentication (jsonwebtoken), HTTP requests (axios), and database interaction (supabase-js).

**SQL (PostgreSQL)**

PostgreSQL was chosen as the primary database because of its robust support for complex queries, ACID compliance, and excellent performance on relational data. The platform's job listings, user profiles, and cost-of-living data fit naturally into a relational schema with clear foreign key relationships. PostgreSQL's JSON support enables flexible storage of user preferences and job metadata without sacrificing query performance.

### 5.2 AI/ML Libraries and APIs

**Table 5.1: AI/ML Libraries and APIs Used**

| Library/API | Version | Purpose |
|-------------|---------|---------|
| JSearch API (RapidAPI) | v1.0 | Fetches live job listings from multiple job boards. Provides job title, company, salary, location, and job description. Enables real-time job discovery without maintaining proprietary job database. |
| Numbeo API | Web Scraping | Provides current cost-of-living data for 300+ cities worldwide. Extracts rent, grocery, transportation, and utility costs. Enables affordability scoring by correlating salary with local expenses. |
| Supabase Auth | v2.0 | Manages user authentication, JWT token generation, and email verification. Provides secure user session management and password reset functionality. |
| cheerio | v1.0.0-rc.12 | HTML parsing library for web scraping Numbeo. Extracts cost-of-living tables from HTML responses. Enables cost data collection without official API access. |
| axios | v1.4.0 | HTTP client for making requests to JSearch API and Numbeo. Handles request/response serialization and error handling. |
| jsonwebtoken | v9.0.0 | JWT token generation and verification for user authentication. Enables stateless authentication without server-side session storage. |

### 5.3 Backend Framework

**Express.js**

Express.js is a lightweight, unopinionated Node.js framework that provides routing, middleware, and request/response handling. It was chosen for its simplicity, performance, and extensive ecosystem. Express enables rapid development of RESTful APIs with clean separation of concerns through middleware and route handlers. The framework's middleware system allows easy integration of authentication, CORS, error handling, and logging.

**Supabase**

Supabase is a Backend-as-a-Service (BaaS) platform providing PostgreSQL database, authentication, and real-time subscriptions. It was chosen to eliminate the need for separate database administration and authentication infrastructure. Supabase's JavaScript client library integrates seamlessly with Node.js, enabling type-safe database queries through the Supabase client API.

### 5.4 Frontend Framework

**Flutter Web**

Flutter Web enables development of responsive web applications using the Dart language and Flutter's widget-based architecture. The framework provides a rich set of Material Design components, enabling rapid UI development without writing HTML/CSS. Flutter's hot-reload feature accelerates development cycles, allowing developers to see changes instantly without rebuilding.

**Provider (State Management)**

Provider is a lightweight state management solution for Flutter that uses the InheritedWidget pattern. It enables efficient propagation of state changes through the widget tree, ensuring UI updates only when relevant data changes. Provider was chosen over more complex solutions (Redux, Bloc) because Salariann's state management needs are relatively straightforward: user authentication, job list state, and user preferences.

**GoRouter (Navigation)**

GoRouter is a declarative routing solution for Flutter that provides type-safe navigation with deep linking support. It enables clean separation of navigation logic from UI code and supports complex navigation scenarios (nested routes, guards, redirects) required for Salariann's multi-screen interface.

### 5.5 Database and Cloud Services

**Supabase PostgreSQL**

Supabase provides a managed PostgreSQL database with automatic backups, point-in-time recovery, and high availability. The platform's built-in authentication system eliminates the need for custom auth implementation. Supabase's real-time subscriptions enable live updates when new jobs are posted or cost-of-living data is updated.

**JWT Authentication**

JWT (JSON Web Tokens) were chosen for stateless authentication, eliminating the need for server-side session storage. Each request includes a JWT token in the Authorization header, which the backend verifies using the secret key. This approach enables horizontal scaling of the backend without session synchronization overhead.

### 5.6 Development and Deployment Tools

**Table 5.2: Development Tools**

| Tool | Purpose |
|------|---------|
| Git & GitHub | Version control and collaborative development. Enables branching, code review, and deployment automation. |
| Visual Studio Code | Integrated development environment with Dart, JavaScript, and SQL extensions. Provides debugging, linting, and code formatting. |
| Postman | API testing and documentation. Enables manual testing of backend endpoints before frontend integration. |
| Docker & Docker Compose | Containerization of backend services and Supabase. Enables consistent development and production environments. |
| Jupyter Notebook | Data exploration and analysis. Used for prototyping affordability scoring algorithms and analyzing job market trends. |
| Swagger/OpenAPI | API documentation. Provides interactive API documentation for backend endpoints. |

### 5.7 Hardware Requirements

**Table 5.3: Hardware Requirements**

| Component | Minimum Specification & Rationale |
|-----------|-----------------------------------|
| Processor | Intel i5 / AMD Ryzen 5 (4+ cores). Sufficient for running backend server, database, and development tools simultaneously. Multi-core support enables parallel processing of API requests. |
| RAM | 8 GB minimum, 16 GB recommended. Backend server, database, and IDE require ~2-3 GB each. Additional RAM enables smooth development experience with multiple tools open. |
| Storage | 256 GB SSD minimum. Operating system (~30 GB), development tools (~20 GB), project files (~5 GB), Docker images (~50 GB), database (~50 GB). SSD provides fast I/O for database queries and file operations. |
| Network | 10 Mbps minimum, 50 Mbps recommended. Required for API calls to JSearch and Numbeo, database synchronization, and deployment to cloud services. Higher bandwidth enables faster data transfer. |

### 5.8 Software Requirements

**Table 5.4: Software Requirements**

| Software | Version/Notes |
|----------|--------------|
| Operating System | macOS 12+, Ubuntu 20.04+, or Windows 10+ with WSL2. Cross-platform support enables development on any major OS. |
| Node.js | v18.0.0 or higher. LTS version recommended for stability. Provides JavaScript runtime for backend server. |
| Flutter | v3.10.0 or higher. Required for frontend development and web compilation. |
| PostgreSQL | v14.0 or higher. Supabase uses PostgreSQL 14+. Local development can use Docker image. |
| Docker | v20.10+ and Docker Compose v2.0+. Enables containerization of services for consistent development environment. |

---

## CHAPTER 6: SYSTEM IMPLEMENTATION

### 6.1 Module-wise Implementation

The implementation follows a modular architecture with clear separation of concerns. Each module is independently testable and deployable. The backend implements business logic in controllers, which are invoked by route handlers. The frontend implements UI in screens and widgets, which consume data from providers. This architecture enables parallel development of frontend and backend components.

### 6.2 Job Discovery Module Implementation

The Job Discovery Module fetches live job listings from the JSearch API, transforms the data into a standardized schema, and exposes it through RESTful endpoints. The module implements caching to minimize API calls and improve response latency.

**Technical Approach:**

The module uses the axios HTTP client to call the JSearch API with user-provided search parameters. Raw API responses are transformed using a mapping function that extracts relevant fields and normalizes data types. The transformed jobs are cached in-memory with a configurable TTL. Subsequent requests for the same search parameters return cached results if available, reducing API calls and improving response time.

**Listing 6.1: Job Discovery Controller using JSearch API**

```javascript
import axios from 'axios';
import { supabase } from '../config/supabase.js';

const JSEARCH_API_URL = 'https://jsearch.p.rapidapi.com/search';
const JSEARCH_API_KEY = process.env.RAPIDAPI_KEY;
const CACHE_TTL = 3600; // 1 hour in seconds
const jobCache = new Map(); // In-memory cache

// Transform JSearch response to internal schema
function transformJobData(rawJob) {
  return {
    id: rawJob.job_id,
    title: rawJob.job_title,
    company: rawJob.employer_name,
    description: rawJob.job_description,
    salary_min: rawJob.job_min_salary || null,
    salary_max: rawJob.job_max_salary || null,
    salary_currency: rawJob.job_salary_currency || 'INR',
    city: rawJob.job_city,
    country: rawJob.job_country,
    posting_date: rawJob.job_posted_at_datetime_utc,
    job_type: rawJob.job_employment_type,
    required_experience: rawJob.job_required_experience?.required_experience_in_months || null,
    source: 'jsearch',
    is_active: true
  };
}

// Fetch jobs from JSearch API with caching
export async function fetchLiveJobs(req, res) {
  try {
    const { query, location, page = 1, limit = 10 } = req.query;

    // Validate input
    if (!query) {
      return res.status(400).json({ error: 'Search query is required' });
    }

    // Check cache
    const cacheKey = `${query}-${location}-${page}`;
    const cachedData = jobCache.get(cacheKey);
    
    if (cachedData && Date.now() - cachedData.timestamp < CACHE_TTL * 1000) {
      return res.json({
        success: true,
        data: cachedData.jobs,
        source: 'cache',
        cached_at: new Date(cachedData.timestamp)
      });
    }

    // Call JSearch API
    const response = await axios.get(JSEARCH_API_URL, {
      params: {
        query: query,
        location: location || 'India',
        page: page,
        num_pages: 1
      },
      headers: {
        'x-rapidapi-key': JSEARCH_API_KEY,
        'x-rapidapi-host': 'jsearch.p.rapidapi.com'
      }
    });

    // Transform and cache results
    const transformedJobs = response.data.data.map(transformJobData);
    
    jobCache.set(cacheKey, {
      jobs: transformedJobs,
      timestamp: Date.now()
    });

    // Limit cache size to prevent memory overflow
    if (jobCache.size > 100) {
      const firstKey = jobCache.keys().next().value;
      jobCache.delete(firstKey);
    }

    return res.json({
      success: true,
      data: transformedJobs,
      source: 'jsearch',
      pagination: {
        page: page,
        limit: limit,
        total: response.data.data.length
      }
    });
  } catch (error) {
    console.error('Error fetching jobs:', error);
    return res.status(500).json({ error: 'Failed to fetch jobs from JSearch API' });
  }
}

// Get job details by ID
export async function getJobById(req, res) {
  try {
    const { jobId } = req.params;

    // First check local database for cached job details
    const { data: localJob, error: localError } = await supabase
      .from('jobs')
      .select('*')
      .eq('id', jobId)
      .single();

    if (localJob && !localError) {
      return res.json({
        success: true,
        data: localJob,
        source: 'database'
      });
    }

    // If not in database, fetch from JSearch API
    const response = await axios.get(`${JSEARCH_API_URL}/${jobId}`, {
      headers: {
        'x-rapidapi-key': JSEARCH_API_KEY,
        'x-rapidapi-host': 'jsearch.p.rapidapi.com'
      }
    });

    const transformedJob = transformJobData(response.data);

    // Cache in database for future requests
    await supabase
      .from('jobs')
      .insert([transformedJob])
      .select();

    return res.json({
      success: true,
      data: transformedJob,
      source: 'jsearch'
    });
  } catch (error) {
    console.error('Error fetching job details:', error);
    return res.status(500).json({ error: 'Failed to fetch job details' });
  }
}
```

### 6.3 Affordability Analysis Module Implementation

The Affordability Analysis Module scrapes cost-of-living data from Numbeo, calculates city-specific expense profiles, and computes affordability scores for jobs.

**Technical Approach:**

The module uses cheerio to parse HTML responses from Numbeo, extracting cost-of-living tables. Data is cached in-memory with a configurable TTL. The affordability scoring algorithm computes disposable income by subtracting annual living expenses from salary, then normalizes the result against a user-defined target disposable income threshold.

**Listing 6.2: Affordability Analysis Module using Numbeo Scraping**

```javascript
import axios from 'axios';
import cheerio from 'cheerio';
import { supabase } from '../config/supabase.js';

const NUMBEO_BASE_URL = 'https://www.numbeo.com/cost-of-living/in';
const CACHE_TTL = 3600; // 1 hour
const costCache = new Map();

// Scrape cost-of-living data from Numbeo
async function scrapeCostOfLiving(city) {
  try {
    const url = `${NUMBEO_BASE_URL}/${city.replace(/\s+/g, '_')}`;
    
    const response = await axios.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });

    const $ = cheerio.load(response.data);
    
    // Extract cost data from Numbeo tables
    const costData = {
      city: city,
      rent_1br_center: parseFloat($('td:contains("Apartment (1 bedroom) in City Centre")').next().text()) || 0,
      rent_1br_outside: parseFloat($('td:contains("Apartment (1 bedroom) Outside of Centre")').next().text()) || 0,
      grocery_monthly: parseFloat($('td:contains("Groceries")').next().text()) || 0,
      transport_monthly: parseFloat($('td:contains("Local Transport")').next().text()) || 0,
      utilities_monthly: parseFloat($('td:contains("Utilities")').next().text()) || 0,
      dining_out: parseFloat($('td:contains("Meal, Inexpensive Restaurant")').next().text()) || 0,
      entertainment: parseFloat($('td:contains("Cinema, International Release")').next().text()) || 0,
      last_updated: new Date().toISOString()
    };

    // Calculate total monthly cost (conservative estimate)
    costData.total_monthly = (
      costData.rent_1br_center +
      costData.grocery_monthly +
      costData.transport_monthly +
      costData.utilities_monthly
    );

    return costData;
  } catch (error) {
    console.error(`Error scraping cost data for ${city}:`, error);
    return null;
  }
}

// Get cost-of-living data with caching
export async function getCostOfLiving(req, res) {
  try {
    const { city } = req.params;

    if (!city) {
      return res.status(400).json({ error: 'City parameter is required' });
    }

    // Check in-memory cache
    const cacheKey = city.toLowerCase();
    const cachedData = costCache.get(cacheKey);
    
    if (cachedData && Date.now() - cachedData.timestamp < CACHE_TTL * 1000) {
      return res.json({
        success: true,
        data: cachedData.data,
        source: 'cache'
      });
    }

    // Check database cache
    const { data: dbData } = await supabase
      .from('cost_of_living')
      .select('*')
      .eq('city', city)
      .single();

    if (dbData && Date.now() - new Date(dbData.last_updated).getTime() < CACHE_TTL * 1000) {
      costCache.set(cacheKey, {
        data: dbData,
        timestamp: Date.now()
      });
      
      return res.json({
        success: true,
        data: dbData,
        source: 'database'
      });
    }

    // Scrape fresh data from Numbeo
    const scrapedData = await scrapeCostOfLiving(city);

    if (!scrapedData) {
      return res.status(404).json({ error: `Cost-of-living data not found for ${city}` });
    }

    // Store in database
    await supabase
      .from('cost_of_living')
      .upsert([scrapedData], { onConflict: 'city' });

    // Cache in memory
    costCache.set(cacheKey, {
      data: scrapedData,
      timestamp: Date.now()
    });

    return res.json({
      success: true,
      data: scrapedData,
      source: 'numbeo'
    });
  } catch (error) {
    console.error('Error getting cost of living:', error);
    return res.status(500).json({ error: 'Failed to fetch cost-of-living data' });
  }
}

// Calculate affordability score for a job
export async function calculateAffordabilityScore(salary, city, userPreferences = {}) {
  try {
    // Get cost-of-living data
    const costData = await getCostOfLivingData(city);
    
    if (!costData) {
      throw new Error(`Cost data not available for ${city}`);
    }

    // Calculate annual cost based on user preferences
    const monthlyExpense = costData.total_monthly;
    const annualExpense = monthlyExpense * 12;

    // Calculate disposable income
    const annualSalary = salary;
    const disposableIncome = annualSalary - annualExpense;

    // Get user's target disposable income (default: 10 lakhs/year)
    const targetDisposable = userPreferences.targetDisposable || 1000000;

    // Calculate affordability score (0-100)
    const affordabilityScore = Math.min(100, (disposableIncome / targetDisposable) * 100);

    return {
      score: Math.round(affordabilityScore),
      disposableIncome: Math.round(disposableIncome),
      monthlyExpense: Math.round(monthlyExpense),
      breakdown: {
        salary: annualSalary,
        annualExpense: Math.round(annualExpense),
        disposableIncome: Math.round(disposableIncome),
        targetDisposable: targetDisposable
      }
    };
  } catch (error) {
    console.error('Error calculating affordability score:', error);
    return null;
  }
}

async function getCostOfLivingData(city) {
  const cacheKey = city.toLowerCase();
  const cached = costCache.get(cacheKey);
  
  if (cached && Date.now() - cached.timestamp < CACHE_TTL * 1000) {
    return cached.data;
  }

  const { data } = await supabase
    .from('cost_of_living')
    .select('*')
    .eq('city', city)
    .single();

  if (data) {
    costCache.set(cacheKey, {
      data: data,
      timestamp: Date.now()
    });
    return data;
  }

  return null;
}
```

### 6.4 System Workflow Algorithm

**Algorithm 1: Job Search and Affordability Scoring Workflow**

```
Algorithm: SearchJobsWithAffordabilityScoring
Input: 
  - searchQuery: string (job title/role)
  - location: string (city name)
  - userPreferences: object (salary target, lifestyle)
  - userId: UUID (authenticated user)

Output:
  - rankedJobs: array of jobs sorted by affordability score

Procedure:
  1. VALIDATE searchQuery and location
  2. IF searchQuery is empty THEN
       RETURN error "Search query required"
     END IF
  
  3. checkCache(searchQuery, location)
  4. IF cache hit AND cache fresh THEN
       RETURN cached results
     END IF
  
  5. CALL JSearch API with (searchQuery, location)
  6. rawJobs ← API response
  
  7. transformedJobs ← []
  8. FOR EACH job IN rawJobs DO
       transformedJob ← TransformJobSchema(job)
       transformedJobs.append(transformedJob)
     END FOR
  
  9. uniqueCities ← ExtractUniqueCities(transformedJobs)
  
  10. WHILE uniqueCities is not empty DO
        city ← uniqueCities.pop()
        costData ← GetCostOfLiving(city)
        
        IF costData is null THEN
          costData ← ScrapeCostOfLiving(city)
          CacheInDatabase(costData)
        END IF
        
        CacheInMemory(costData)
      END WHILE
  
  11. scoredJobs ← []
  12. FOR EACH job IN transformedJobs DO
        affordabilityScore ← CalculateAffordabilityScore(
          job.salary_max,
          job.city,
          userPreferences
        )
        job.affordabilityScore ← affordabilityScore.score
        job.disposableIncome ← affordabilityScore.disposableIncome
        scoredJobs.append(job)
      END FOR
  
  13. rankedJobs ← SortByAffordabilityScore(scoredJobs, descending)
  
  14. LogUserInteraction(userId, "search", searchQuery, location)
  
  15. CacheResults(searchQuery, location, rankedJobs)
  
  16. RETURN rankedJobs
End Algorithm
```

### 6.5 User Management and Authentication Service

The User Management Module implements JWT-based authentication, user profile management, and personalization.

**Listing 6.3: Authentication Middleware and User Management**

```javascript
import jwt from 'jsonwebtoken';
import { supabase } from '../config/supabase.js';

const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRY = '7d';

// Middleware to verify JWT token
export async function verifyToken(req, res, next) {
  try {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}

// User registration
export async function registerUser(req, res) {
  try {
    const { email, password, displayName } = req.body;

    // Validate input
    if (!email || !password || !displayName) {
      return res.status(400).json({ error: 'Email, password, and display name are required' });
    }

    // Create user in Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email: email,
      password: password
    });

    if (authError) {
      return res.status(400).json({ error: authError.message });
    }

    // Create user profile in database
    const { data: userData, error: userError } = await supabase
      .from('users')
      .insert([{
        id: authData.user.id,
        email: email,
        display_name: displayName,
        preferences: {}
      }])
      .select()
      .single();

    if (userError) {
      return res.status(400).json({ error: userError.message });
    }

    return res.status(201).json({
      success: true,
      message: 'User registered successfully',
      user: userData
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// User login
export async function loginUser(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    // Authenticate with Supabase
    const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
      email: email,
      password: password
    });

    if (authError) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: authData.user.id, email: authData.user.email },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRY }
    );

    // Fetch user profile
    const { data: userData } = await supabase
      .from('users')
      .select('*')
      .eq('id', authData.user.id)
      .single();

    return res.json({
      success: true,
      token: token,
      user: userData
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Update user preferences
export async function updateUserPreferences(req, res) {
  try {
    const userId = req.user.id;
    const { preferences } = req.body;

    const { data, error } = await supabase
      .from('users')
      .update({ preferences: preferences })
      .eq('id', userId)
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({
      success: true,
      user: data
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
```

---

**END OF PART 3**

*This document contains Chapters 5-6 of the Salariann Project Report.*  
*Continue with Part 4 for Chapters 7-8 and Appendices.*
