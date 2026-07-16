import { supabase } from '../config/supabase.js';
import { calculateAffordabilityScore, getAffordabilityBadge } from '../utils/affordabilityScore.js';

// API Configuration for Indian Job Portals
const NAUKRI_API = 'https://api.naukri.com/v1/jobs'; // Placeholder - requires API key
const LINKEDIN_INDIA_API = 'https://api.linkedin.com/v2/jobs'; // Requires OAuth
const INDEED_INDIA_API = 'https://api.indeed.com/ads/apisearch'; // Requires Publisher ID

// Indian IT Companies List
const INDIAN_IT_COMPANIES = [
  'TCS', 'Infosys', 'Wipro', 'HCL Technologies', 'Tech Mahindra',
  'Cognizant', 'Accenture', 'IBM India', 'Capgemini', 'LTI Mindtree',
  'Persistent Systems', 'Mphasis', 'L&T Infotech', 'Hexaware', 'Cyient',
  'Birlasoft', 'Zensar Technologies', 'NIIT Technologies', 'Coforge', 'Sonata Software',
  'KPIT Technologies', 'Happiest Minds', 'Tata Elxsi', 'Oracle India', 'Microsoft India',
  'Google India', 'Amazon India', 'Flipkart', 'Paytm', 'Razorpay',
  'Freshworks', 'Zoho', 'Swiggy', 'Zomato', 'PhonePe',
  'CRED', 'Ola', 'Myntra', 'Zerodha', 'Unacademy'
];

const INDIAN_METRO_CITIES = [
  'Bangalore', 'Mumbai', 'Delhi', 'Hyderabad', 'Pune',
  'Chennai', 'Kolkata', 'Noida', 'Gurgaon', 'Ahmedabad',
  'Jaipur', 'Chandigarh', 'Kochi', 'Indore', 'Lucknow',
  'Coimbatore', 'Thiruvananthapuram', 'Nagpur', 'Visakhapatnam', 'Bhubaneswar'
];

// In-memory cache for Indian jobs
const indianJobCache = new Map();
const CACHE_TTL = parseInt(process.env.CACHE_TTL || '14400') * 1000; // 4 hours default

function getCached(key) {
  const entry = indianJobCache.get(key);
  if (entry && Date.now() - entry.timestamp < CACHE_TTL) return entry.data;
  indianJobCache.delete(key);
  return null;
}

function setCache(key, data) {
  indianJobCache.set(key, { data, timestamp: Date.now() });
}

// Mock Indian Jobs Data (until APIs are available)
function getMockIndianJobs() {
  const mockJobs = [];
  const roles = [
    'Senior Software Engineer', 'Full Stack Developer', 'DevOps Engineer',
    'Data Scientist', 'Product Manager', 'Solutions Architect',
    'Cloud Engineer', 'Machine Learning Engineer', 'Frontend Developer',
    'Backend Developer', 'QA Engineer', 'Business Analyst'
  ];

  const techStacks = [
    ['Java', 'Spring Boot', 'Microservices', 'Docker', 'Kubernetes'],
    ['React', 'Node.js', 'MongoDB', 'AWS'],
    ['Python', 'Django', 'PostgreSQL', 'Docker'],
    ['AWS', 'Terraform', 'Jenkins', 'Kubernetes'],
    ['Python', 'TensorFlow', 'Pandas', 'Scikit-learn'],
    ['Java', 'Kafka', 'Spark', 'Hadoop'],
  ];

  let jobId = 1;
  for (const company of INDIAN_IT_COMPANIES.slice(0, 20)) {
    for (let i = 0; i < 2; i++) {
      const role = roles[Math.floor(Math.random() * roles.length)];
      const city = INDIAN_METRO_CITIES[Math.floor(Math.random() * INDIAN_METRO_CITIES.length)];
      const techStack = techStacks[Math.floor(Math.random() * techStacks.length)];
      
      mockJobs.push({
        id: `india-job-${jobId++}`,
        title: role,
        company: company,
        company_logo: `https://via.placeholder.com/100?text=${company.substring(0, 3)}`,
        city: city,
        country: 'India',
        description: `${role} position at ${company}. We are looking for experienced professionals to join our team.`,
        employment_type: 'Full-time',
        is_remote: false,
        salary_min: 800000 + Math.random() * 1000000,
        salary_max: 1800000 + Math.random() * 1000000,
        salary_period: 'YEAR',
        experience_required: Math.floor(Math.random() * 8) + 1,
        posted_at: new Date(Date.now() - Math.random() * 30 * 24 * 60 * 60 * 1000).toISOString(),
        apply_link: `https://www.naukri.com/job-listings-${company}-${role}`,
        tech_stack: techStack,
        source: 'india-mock',
        job_type: 'Full-time',
        benefits: ['Health Insurance', 'Flexible Hours', 'Work from Home', 'Learning Budget'],
      });
    }
  }

  return mockJobs;
}

// Fetch from Naukri API (placeholder - requires API key)
async function fetchFromNaukri(query, city) {
  try {
    // Placeholder implementation - actual Naukri API requires authentication
    console.log('Naukri API integration pending - using mock data');
    return [];
  } catch (error) {
    console.error('Naukri fetch error:', error.message);
    return [];
  }
}

// Fetch from LinkedIn India API (placeholder - requires OAuth)
async function fetchFromLinkedInIndia(query, city) {
  try {
    // Placeholder implementation - actual LinkedIn API requires OAuth
    console.log('LinkedIn India API integration pending - using mock data');
    return [];
  } catch (error) {
    console.error('LinkedIn India fetch error:', error.message);
    return [];
  }
}

// Fetch from Indeed India API (placeholder - requires Publisher ID)
async function fetchFromIndeedIndia(query, city) {
  try {
    // Placeholder implementation - actual Indeed API requires Publisher ID
    console.log('Indeed India API integration pending - using mock data');
    return [];
  } catch (error) {
    console.error('Indeed India fetch error:', error.message);
    return [];
  }
}

// Get all Indian jobs
export async function getIndianJobs(req, res) {
  try {
    const { search = '', city = '', limit = 20, offset = 0, company = '' } = req.query;
    const cacheKey = `india-jobs-${search}-${city}-${company}-${limit}-${offset}`;

    // Check cache
    const cached = getCached(cacheKey);
    if (cached) {
      return res.json(cached);
    }

    // Fetch from all sources in parallel
    const [naukriResult, linkedinResult, indeedResult] = await Promise.allSettled([
      fetchFromNaukri(search, city),
      fetchFromLinkedInIndia(search, city),
      fetchFromIndeedIndia(search, city),
    ]);

    let allJobs = [];
    
    // Add mock data (until real APIs are available)
    allJobs = allJobs.concat(getMockIndianJobs());

    // Add real API results if available
    if (naukriResult.status === 'fulfilled') allJobs = allJobs.concat(naukriResult.value);
    if (linkedinResult.status === 'fulfilled') allJobs = allJobs.concat(linkedinResult.value);
    if (indeedResult.status === 'fulfilled') allJobs = allJobs.concat(indeedResult.value);

    // Filter by search query
    if (search) {
      allJobs = allJobs.filter(job =>
        job.title.toLowerCase().includes(search.toLowerCase()) ||
        job.company.toLowerCase().includes(search.toLowerCase()) ||
        job.description.toLowerCase().includes(search.toLowerCase())
      );
    }

    // Filter by city
    if (city) {
      allJobs = allJobs.filter(job =>
        job.city.toLowerCase().includes(city.toLowerCase())
      );
    }

    // Filter by company
    if (company) {
      allJobs = allJobs.filter(job =>
        job.company.toLowerCase().includes(company.toLowerCase())
      );
    }

    // Sort by posted date
    allJobs.sort((a, b) => new Date(b.posted_at) - new Date(a.posted_at));

    // Apply pagination
    const total = allJobs.length;
    const paginatedJobs = allJobs.slice(parseInt(offset), parseInt(offset) + parseInt(limit));

    // Add affordability scores
    const jobsWithScores = await Promise.all(
      paginatedJobs.map(async (job) => {
        const avgCtc = job.salary_max
          ? (job.salary_min + job.salary_max) / 2
          : job.salary_min;

        let affordability = null;
        let affordabilityBadge = null;

        if (avgCtc) {
          affordability = await calculateAffordabilityScore(avgCtc, job.city);
          affordabilityBadge = await getAffordabilityBadge(avgCtc, job.city);
        }

        return {
          ...job,
          affordability,
          affordabilityBadge,
        };
      })
    );

    const response = {
      data: jobsWithScores,
      pagination: {
        total,
        limit: parseInt(limit),
        offset: parseInt(offset),
      },
    };

    setCache(cacheKey, response);
    return res.json(response);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Get single Indian job by ID
export async function getIndianJobById(req, res) {
  try {
    const { id } = req.params;

    // Get all jobs and find the one with matching ID
    const allJobs = getMockIndianJobs();
    const job = allJobs.find(j => j.id === id);

    if (!job) {
      return res.status(404).json({ error: 'Job not found' });
    }

    const avgCtc = job.salary_max
      ? (job.salary_min + job.salary_max) / 2
      : job.salary_min;

    let affordability = null;
    let affordabilityBadge = null;

    if (avgCtc) {
      affordability = await calculateAffordabilityScore(avgCtc, job.city);
      affordabilityBadge = await getAffordabilityBadge(avgCtc, job.city);
    }

    return res.json({
      ...job,
      affordability,
      affordabilityBadge,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Get Indian jobs by company
export async function getIndianJobsByCompany(req, res) {
  try {
    const { company } = req.params;
    const { limit = 20, offset = 0 } = req.query;

    const allJobs = getMockIndianJobs();
    const companyJobs = allJobs.filter(job =>
      job.company.toLowerCase() === company.toLowerCase()
    );

    const total = companyJobs.length;
    const paginatedJobs = companyJobs.slice(parseInt(offset), parseInt(offset) + parseInt(limit));

    return res.json({
      data: paginatedJobs,
      pagination: {
        total,
        limit: parseInt(limit),
        offset: parseInt(offset),
      },
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Get list of Indian IT companies
export async function getIndianITCompanies(req, res) {
  try {
    const { limit = 20, offset = 0 } = req.query;

    const companies = INDIAN_IT_COMPANIES.map((company, index) => ({
      id: `company-${company.toLowerCase().replace(/\s+/g, '-')}`,
      name: company,
      city: INDIAN_METRO_CITIES[index % INDIAN_METRO_CITIES.length],
      country: 'India',
      logo_url: `https://via.placeholder.com/100?text=${company.substring(0, 3)}`,
      industry: 'IT Services',
      job_count: Math.floor(Math.random() * 50) + 10,
    }));

    const total = companies.length;
    const paginatedCompanies = companies.slice(parseInt(offset), parseInt(offset) + parseInt(limit));

    return res.json({
      data: paginatedCompanies,
      pagination: {
        total,
        limit: parseInt(limit),
        offset: parseInt(offset),
      },
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Get Indian cities
export async function getIndianCities(req, res) {
  try {
    return res.json({
      data: INDIAN_METRO_CITIES,
      count: INDIAN_METRO_CITIES.length,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
