import { supabase } from '../config/supabase.js';

// API Configuration
const REMOTEOK_API = 'https://remoteok.com/api';
const REMOTIVE_API = 'https://remotive.com/api/remote-jobs';
const JSEARCH_API_URL = 'https://jsearch.p.rapidapi.com/search';
const RAPIDAPI_KEY = process.env.RAPIDAPI_KEY;

// In-memory cache
const companyCache = new Map();
const CACHE_TTL = parseInt(process.env.CACHE_TTL || '3600') * 1000;

function getCached(key) {
  const entry = companyCache.get(key);
  if (entry && Date.now() - entry.timestamp < CACHE_TTL) return entry.data;
  companyCache.delete(key);
  return null;
}

function setCache(key, data) {
  companyCache.set(key, { data, timestamp: Date.now() });
}

// Fetch jobs from all sources to extract companies
async function fetchAllJobs() {
  try {
    const [remoteokResult, remotiveResult, jsearchResult] = await Promise.allSettled([
      fetchFromRemoteOK(),
      fetchFromRemotive(),
      fetchFromJSearch()
    ]);

    let allJobs = [];
    if (remoteokResult.status === 'fulfilled') allJobs = allJobs.concat(remoteokResult.value);
    if (remotiveResult.status === 'fulfilled') allJobs = allJobs.concat(remotiveResult.value);
    if (jsearchResult.status === 'fulfilled') allJobs = allJobs.concat(jsearchResult.value);

    return allJobs;
  } catch (error) {
    console.error('Error fetching jobs:', error.message);
    return [];
  }
}

// Extract unique companies from jobs
function extractCompanies(jobs) {
  const companiesMap = new Map();

  jobs.forEach(job => {
    const companyName = job.company || 'Unknown';
    if (!companiesMap.has(companyName)) {
      companiesMap.set(companyName, {
        id: `company-${companyName.toLowerCase().replace(/\s+/g, '-')}`,
        name: companyName,
        logo_url: job.company_logo || null,
        website: job.company_website || null,
        city: job.city || 'Remote',
        country: job.country || 'Worldwide',
        description: `${companyName} - Hiring for ${job.title}`,
        employee_count: null,
        founded_year: null,
        industry: 'Technology',
        rating: null,
        total_reviews: 0,
        job_count: 0,
      });
    }

    const company = companiesMap.get(companyName);
    company.job_count += 1;
  });

  return Array.from(companiesMap.values());
}

async function fetchFromRemoteOK() {
  try {
    const response = await fetch(REMOTEOK_API, {
      headers: { 'User-Agent': 'Salariann/1.0' }
    });
    if (!response.ok) return [];

    const data = await response.json();
    const jobs = Array.isArray(data) ? data.slice(1) : [];

    return jobs.slice(0, 50).map(job => ({
      id: `remoteok-${job.id}`,
      title: job.position || 'Unknown Role',
      company: job.company || 'Unknown',
      company_logo: job.company_logo || null,
      city: 'Remote',
      country: job.location || 'Worldwide',
      description: (job.description || '').replace(/<[^>]*>/g, '').slice(0, 2000),
      source: 'remoteok'
    }));
  } catch (error) {
    console.error('RemoteOK fetch error:', error.message);
    return [];
  }
}

async function fetchFromRemotive() {
  try {
    const response = await fetch(REMOTIVE_API + '?limit=50');
    if (!response.ok) return [];

    const data = await response.json();
    const jobs = data.jobs || [];

    return jobs.slice(0, 50).map(job => ({
      id: `remotive-${job.id}`,
      title: job.title || 'Unknown Role',
      company: job.company_name || 'Unknown',
      company_logo: job.company_logo_url || null,
      city: job.candidate_required_location || 'Remote',
      country: job.candidate_required_location || 'Worldwide',
      description: (job.description || '').replace(/<[^>]*>/g, '').slice(0, 2000),
      source: 'remotive'
    }));
  } catch (error) {
    console.error('Remotive fetch error:', error.message);
    return [];
  }
}

async function fetchFromJSearch() {
  if (!RAPIDAPI_KEY) return [];
  
  try {
    const params = new URLSearchParams({
      query: 'software engineer',
      page: '1',
      num_pages: '2'
    });

    const response = await fetch(`${JSEARCH_API_URL}?${params}`, {
      method: 'GET',
      headers: {
        'x-rapidapi-key': RAPIDAPI_KEY,
        'x-rapidapi-host': 'jsearch.p.rapidapi.com'
      }
    });

    if (!response.ok) return [];

    const data = await response.json();
    const jobs = data.data || [];

    return jobs.slice(0, 50).map(job => ({
      id: `jsearch-${job.job_id}`,
      title: job.job_title || 'Unknown Role',
      company: job.employer_name || 'Unknown',
      company_logo: job.employer_logo || null,
      city: job.job_city || 'Remote',
      country: job.job_country || 'Worldwide',
      description: job.job_description || '',
      source: 'jsearch'
    }));
  } catch (error) {
    console.error('JSearch fetch error:', error.message);
    return [];
  }
}

export async function getCompanies(req, res) {
  try {
    const { search = '', city = '', limit = 20, offset = 0 } = req.query;
    const cacheKey = `companies-${search}-${city}-${limit}-${offset}`;

    // Check cache
    const cached = getCached(cacheKey);
    if (cached) {
      return res.json(cached);
    }

    // Fetch all jobs and extract companies
    const allJobs = await fetchAllJobs();
    let companies = extractCompanies(allJobs);

    // Filter by search
    if (search) {
      companies = companies.filter(company =>
        company.name.toLowerCase().includes(search.toLowerCase()) ||
        company.description.toLowerCase().includes(search.toLowerCase())
      );
    }

    // Filter by city
    if (city) {
      companies = companies.filter(company =>
        company.city.toLowerCase().includes(city.toLowerCase()) ||
        company.country.toLowerCase().includes(city.toLowerCase())
      );
    }

    // Sort by name
    companies.sort((a, b) => a.name.localeCompare(b.name));

    // Apply pagination
    const total = companies.length;
    const paginatedCompanies = companies.slice(parseInt(offset), parseInt(offset) + parseInt(limit));

    // Get reviews and ratings from database
    const companiesWithRatings = await Promise.all(
      paginatedCompanies.map(async (company) => {
        const { data: reviews } = await supabase
          .from('reviews')
          .select('overall_rating')
          .ilike('company_name', `%${company.name}%`);

        const avgRating = reviews && reviews.length > 0
          ? (reviews.reduce((sum, r) => sum + (r.overall_rating || 0), 0) / reviews.length).toFixed(2)
          : null;

        return {
          ...company,
          rating: avgRating,
          total_reviews: reviews?.length || 0,
        };
      })
    );

    const response = {
      data: companiesWithRatings,
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

export async function getCompanyById(req, res) {
  try {
    const { id } = req.params;

    // Fetch all jobs and extract companies
    const allJobs = await fetchAllJobs();
    const companies = extractCompanies(allJobs);

    // Find company by ID
    const company = companies.find(c => c.id === id);

    if (!company) {
      return res.status(404).json({ error: 'Company not found' });
    }

    // Get jobs for this company from APIs
    const companyJobs = allJobs.filter(job => 
      job.company.toLowerCase() === company.name.toLowerCase()
    );

    // Get reviews, salaries, interviews from database
    const { data: reviews } = await supabase
      .from('reviews')
      .select('*')
      .ilike('company_name', `%${company.name}%`);

    const { data: salaries } = await supabase
      .from('salaries')
      .select('*')
      .ilike('company_name', `%${company.name}%`);

    const { data: interviews } = await supabase
      .from('interviews')
      .select('*')
      .ilike('company_name', `%${company.name}%`);

    const avgRating =
      reviews && reviews.length > 0
        ? (
            reviews.reduce((sum, r) => sum + (r.overall_rating || 0), 0) /
            reviews.length
          ).toFixed(2)
        : null;

    return res.json({
      ...company,
      stats: {
        jobCount: companyJobs?.length || 0,
        reviewCount: reviews?.length || 0,
        salaryDataCount: salaries?.length || 0,
        interviewCount: interviews?.length || 0,
        avgRating,
      },
      jobs: companyJobs,
      reviews,
      salaries,
      interviews,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
