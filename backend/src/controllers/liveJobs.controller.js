import { supabase } from '../config/supabase.js';

// --- API Configuration ---
const JSEARCH_API_URL = 'https://jsearch.p.rapidapi.com/search';
const RAPIDAPI_KEY = process.env.RAPIDAPI_KEY;
const ADZUNA_APP_ID = process.env.ADZUNA_APP_ID;
const ADZUNA_APP_KEY = process.env.ADZUNA_APP_KEY;

const REMOTEOK_API = 'https://remoteok.com/api';
const REMOTIVE_API = 'https://remotive.com/api/remote-jobs';
const ADZUNA_API = 'https://api.adzuna.com/v1/api/jobs/in/search';

const INDIAN_IT_COMPANIES = [
  'TCS', 'Infosys', 'Wipro', 'HCL Technologies', 'Tech Mahindra',
  'Cognizant', 'Accenture', 'IBM', 'Capgemini', 'LTIMindtree',
  'Persistent Systems', 'Mphasis', 'L&T Infotech', 'Mindtree',
  'Hexaware', 'Cyient', 'Birlasoft', 'Zensar Technologies',
  'NIIT Technologies', 'Coforge', 'Sonata Software', 'KPIT Technologies',
  'Happiest Minds', 'Tata Elxsi', 'Oracle India', 'Microsoft India',
  'Google India', 'Amazon India', 'Flipkart', 'Paytm',
  'Razorpay', 'Freshworks', 'Zoho', 'Swiggy', 'Zomato',
  'PhonePe', 'CRED', 'Ola', 'Myntra', 'Zerodha'
];

const INDIAN_METRO_CITIES = [
  'Bangalore', 'Mumbai', 'Delhi', 'Hyderabad', 'Pune',
  'Chennai', 'Kolkata', 'Noida', 'Gurgaon', 'Ahmedabad',
  'Jaipur', 'Chandigarh', 'Kochi', 'Indore', 'Lucknow',
  'Coimbatore', 'Thiruvananthapuram', 'Nagpur', 'Visakhapatnam', 'Bhubaneswar'
];

// In-memory cache
const jobCache = new Map();
const CACHE_TTL = parseInt(process.env.CACHE_TTL || '3600') * 1000;

function getCached(key) {
  const entry = jobCache.get(key);
  if (entry && Date.now() - entry.timestamp < CACHE_TTL) return entry.data;
  jobCache.delete(key);
  return null;
}

function setCache(key, data) {
  jobCache.set(key, { data, timestamp: Date.now() });
}

// --- Source: RemoteOK (Free, no key needed) ---
async function fetchFromRemoteOK(query) {
  try {
    const response = await fetch(REMOTEOK_API, {
      headers: { 'User-Agent': 'Salariann/1.0' }
    });
    if (!response.ok) return [];

    const data = await response.json();
    // First element is metadata, skip it
    const jobs = Array.isArray(data) ? data.slice(1) : [];

    return jobs
      .filter(job => {
        if (!query) return true;
        const q = query.toLowerCase();
        return (job.position || '').toLowerCase().includes(q) ||
               (job.company || '').toLowerCase().includes(q) ||
               (job.description || '').toLowerCase().includes(q) ||
               (job.tags || []).some(t => t.toLowerCase().includes(q));
      })
      .slice(0, 25)
      .map(job => ({
        id: `remoteok-${job.id}`,
        title: job.position || 'Unknown Role',
        company: job.company || 'Unknown',
        company_logo: job.company_logo || null,
        company_website: job.url ? `https://remoteok.com${job.url}` : null,
        city: 'Remote',
        state: null,
        country: job.location || 'Worldwide',
        description: (job.description || '').replace(/<[^>]*>/g, '').slice(0, 2000),
        employment_type: 'Full-time',
        is_remote: true,
        salary_min: job.salary_min || null,
        salary_max: job.salary_max || null,
        salary_period: 'YEAR',
        posted_at: job.date || new Date().toISOString(),
        apply_link: job.apply_url || (job.url ? `https://remoteok.com${job.url}` : null),
        tech_stack: job.tags || [],
        qualifications: [],
        responsibilities: [],
        benefits: [],
        source: 'remoteok'
      }));
  } catch (error) {
    console.error('RemoteOK fetch error:', error.message);
    return [];
  }
}

// --- Source: Remotive (Free, no key needed) ---
async function fetchFromRemotive(query) {
  try {
    let url = REMOTIVE_API;
    const params = new URLSearchParams();
    if (query) params.set('search', query);
    params.set('limit', '25');
    if (params.toString()) url += `?${params.toString()}`;

    const response = await fetch(url);
    if (!response.ok) return [];

    const data = await response.json();
    const jobs = data.jobs || [];

    return jobs.slice(0, 25).map(job => ({
      id: `remotive-${job.id}`,
      title: job.title || 'Unknown Role',
      company: job.company_name || 'Unknown',
      company_logo: job.company_logo_url || null,
      company_website: job.url || null,
      city: job.candidate_required_location || 'Remote',
      state: null,
      country: job.candidate_required_location || 'Worldwide',
      description: (job.description || '').replace(/<[^>]*>/g, '').slice(0, 2000),
      employment_type: job.job_type || 'Full-time',
      is_remote: true,
      salary_min: extractSalary(job.salary, 'min'),
      salary_max: extractSalary(job.salary, 'max'),
      salary_period: 'YEAR',
      posted_at: job.publication_date || new Date().toISOString(),
      apply_link: job.url || null,
      tech_stack: job.tags || [],
      qualifications: [],
      responsibilities: [],
      benefits: [],
      source: 'remotive'
    }));
  } catch (error) {
    console.error('Remotive fetch error:', error.message);
    return [];
  }
}

// --- Source: Adzuna (Free tier, key required) ---
async function fetchFromAdzuna(query, city, page = 1) {
  if (!ADZUNA_APP_ID || !ADZUNA_APP_KEY) return [];

  try {
    const params = new URLSearchParams({
      app_id: ADZUNA_APP_ID,
      app_key: ADZUNA_APP_KEY,
      results_per_page: '25',
    });

    let searchWhat = query || 'software developer';
    params.set('what', searchWhat);

    if (city) {
      params.set('where', city);
    }

    const url = `${ADZUNA_API}/${page}?${params.toString()}`;
    const response = await fetch(url);
    if (!response.ok) return [];

    const data = await response.json();
    const jobs = data.results || [];

    return jobs.map(job => ({
      id: `adzuna-${job.id}`,
      title: job.title || 'Unknown Role',
      company: job.company?.display_name || 'Unknown',
      company_logo: null,
      company_website: null,
      city: job.location?.display_name || city || 'India',
      state: job.location?.area?.[1] || null,
      country: 'India',
      description: (job.description || '').slice(0, 2000),
      employment_type: job.contract_type || job.contract_time || 'Full-time',
      is_remote: (job.title || '').toLowerCase().includes('remote') || (job.description || '').toLowerCase().includes('remote'),
      salary_min: job.salary_min || null,
      salary_max: job.salary_max || null,
      salary_period: 'YEAR',
      posted_at: job.created || new Date().toISOString(),
      apply_link: job.redirect_url || null,
      tech_stack: extractTechStack(job.title, job.description),
      qualifications: [],
      responsibilities: [],
      benefits: [],
      source: 'adzuna'
    }));
  } catch (error) {
    console.error('Adzuna fetch error:', error.message);
    return [];
  }
}

// --- Source: JSearch/RapidAPI (Paid, fallback) ---
async function fetchFromJSearch(query, city, company, page = 1) {
  if (!RAPIDAPI_KEY) return [];

  try {
    const searchQuery = buildSearchQuery(query, city, company);
    const response = await fetch(
      `${JSEARCH_API_URL}?query=${encodeURIComponent(searchQuery)}&page=${page}&num_pages=1&country=in`,
      {
        method: 'GET',
        headers: {
          'x-rapidapi-key': RAPIDAPI_KEY,
          'x-rapidapi-host': 'jsearch.p.rapidapi.com'
        }
      }
    );

    if (!response.ok) return [];

    const data = await response.json();
    return (data.data || []).map(job => ({
      id: `jsearch-${job.job_id}`,
      title: job.job_title,
      company: job.employer_name,
      company_logo: job.employer_logo,
      company_website: job.employer_website,
      city: job.job_city || 'Remote',
      state: job.job_state,
      country: job.job_country,
      description: (job.job_description || '').slice(0, 2000),
      employment_type: job.job_employment_type,
      is_remote: job.job_is_remote,
      salary_min: job.job_min_salary,
      salary_max: job.job_max_salary,
      salary_period: job.job_salary_period,
      posted_at: job.job_posted_at_datetime_utc,
      apply_link: job.job_apply_link,
      tech_stack: job.required_technologies || [],
      qualifications: job.job_highlights?.Qualifications || [],
      responsibilities: job.job_highlights?.Responsibilities || [],
      benefits: job.job_highlights?.Benefits || [],
      source: 'jsearch'
    }));
  } catch (error) {
    console.error('JSearch fetch error:', error.message);
    return [];
  }
}

// --- Aggregated endpoint: Fetch from all sources ---
export const fetchLiveJobs = async (req, res) => {
  try {
    const { query, city, company, page = 1, sources } = req.query;

    const cacheKey = `live-${query || ''}-${city || ''}-${company || ''}-${page}-${sources || 'all'}`;
    const cached = getCached(cacheKey);
    if (cached) return res.json(cached);

    const requestedSources = sources ? sources.split(',') : ['remoteok', 'remotive', 'adzuna', 'jsearch'];

    const fetchPromises = [];

    if (requestedSources.includes('remoteok')) {
      fetchPromises.push(fetchFromRemoteOK(query || company));
    }
    if (requestedSources.includes('remotive')) {
      fetchPromises.push(fetchFromRemotive(query || company));
    }
    if (requestedSources.includes('adzuna')) {
      fetchPromises.push(fetchFromAdzuna(query, city, parseInt(page)));
    }
    if (requestedSources.includes('jsearch')) {
      fetchPromises.push(fetchFromJSearch(query, city, company, parseInt(page)));
    }

    const results = await Promise.allSettled(fetchPromises);
    let allJobs = [];

    for (const result of results) {
      if (result.status === 'fulfilled' && Array.isArray(result.value)) {
        allJobs = allJobs.concat(result.value);
      }
    }

    // Sort by posted date (newest first)
    allJobs.sort((a, b) => new Date(b.posted_at || 0) - new Date(a.posted_at || 0));

    // Collect source stats
    const sourceStats = {};
    for (const job of allJobs) {
      sourceStats[job.source] = (sourceStats[job.source] || 0) + 1;
    }

    const response = {
      success: true,
      total: allJobs.length,
      page: parseInt(page),
      query: query || null,
      city: city || null,
      sources: sourceStats,
      data: allJobs
    };

    setCache(cacheKey, response);
    res.json(response);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Fetch live jobs for a specific city
export const fetchJobsByCity = async (req, res) => {
  try {
    const { city } = req.params;
    const { role = 'software developer', page = 1 } = req.query;

    const cacheKey = `city-${city}-${role}-${page}`;
    const cached = getCached(cacheKey);
    if (cached) return res.json(cached);

    const [adzunaJobs, jsearchJobs] = await Promise.allSettled([
      fetchFromAdzuna(role, city, parseInt(page)),
      fetchFromJSearch(role, city, null, parseInt(page)),
    ]);

    let allJobs = [];
    if (adzunaJobs.status === 'fulfilled') allJobs = allJobs.concat(adzunaJobs.value);
    if (jsearchJobs.status === 'fulfilled') allJobs = allJobs.concat(jsearchJobs.value);

    allJobs.sort((a, b) => new Date(b.posted_at || 0) - new Date(a.posted_at || 0));

    const response = {
      success: true,
      city,
      total: allJobs.length,
      data: allJobs
    };

    setCache(cacheKey, response);
    res.json(response);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Fetch live jobs for a specific company
export const fetchJobsByCompany = async (req, res) => {
  try {
    const { company } = req.params;
    const { city, page = 1 } = req.query;

    const cacheKey = `company-${company}-${city || ''}-${page}`;
    const cached = getCached(cacheKey);
    if (cached) return res.json(cached);

    const [remoteokJobs, remotiveJobs, adzunaJobs, jsearchJobs] = await Promise.allSettled([
      fetchFromRemoteOK(company),
      fetchFromRemotive(company),
      fetchFromAdzuna(company, city, parseInt(page)),
      fetchFromJSearch(null, city, company, parseInt(page)),
    ]);

    let allJobs = [];
    for (const result of [remoteokJobs, remotiveJobs, adzunaJobs, jsearchJobs]) {
      if (result.status === 'fulfilled') allJobs = allJobs.concat(result.value);
    }

    allJobs.sort((a, b) => new Date(b.posted_at || 0) - new Date(a.posted_at || 0));

    const response = {
      success: true,
      company,
      total: allJobs.length,
      data: allJobs
    };

    setCache(cacheKey, response);
    res.json(response);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get list of supported Indian IT companies
export const getCompanyList = (req, res) => {
  res.json({
    success: true,
    total: INDIAN_IT_COMPANIES.length,
    data: INDIAN_IT_COMPANIES.map(name => ({ name }))
  });
};

// Get list of supported Indian metro cities
export const getCityList = (req, res) => {
  res.json({
    success: true,
    total: INDIAN_METRO_CITIES.length,
    data: INDIAN_METRO_CITIES.map(name => ({ name }))
  });
};

// Get available API sources and their status
export const getSourceStatus = (req, res) => {
  res.json({
    success: true,
    sources: [
      { name: 'remoteok', status: 'active', key_required: false, description: 'Remote jobs from RemoteOK.com' },
      { name: 'remotive', status: 'active', key_required: false, description: 'Remote jobs from Remotive.com' },
      { name: 'adzuna', status: ADZUNA_APP_ID && ADZUNA_APP_KEY ? 'active' : 'needs_key', key_required: true, description: 'India job listings from Adzuna (free tier)' },
      { name: 'jsearch', status: RAPIDAPI_KEY ? 'configured' : 'needs_key', key_required: true, description: 'JSearch via RapidAPI' },
    ]
  });
};

// Fetch and store jobs into database from all sources
export const syncLiveJobs = async (req, res) => {
  try {
    const { query = 'IT jobs', city, company } = req.body;

    // Fetch from all available sources
    const [remoteokJobs, remotiveJobs, adzunaJobs, jsearchJobs] = await Promise.allSettled([
      fetchFromRemoteOK(query),
      fetchFromRemotive(query),
      fetchFromAdzuna(query, city),
      fetchFromJSearch(query, city, company),
    ]);

    let allJobs = [];
    for (const result of [remoteokJobs, remotiveJobs, adzunaJobs, jsearchJobs]) {
      if (result.status === 'fulfilled') allJobs = allJobs.concat(result.value);
    }

    let synced = 0;
    let skipped = 0;

    for (const job of allJobs) {
      const companyName = job.company;
      if (!companyName || companyName === 'Unknown') { skipped++; continue; }

      // Find or create company
      let { data: existingCompany } = await supabase
        .from('companies')
        .select('id')
        .eq('name', companyName)
        .single();

      let companyId;
      if (existingCompany) {
        companyId = existingCompany.id;
      } else {
        const { data: newCompany, error: compErr } = await supabase
          .from('companies')
          .insert({
            name: companyName,
            logo_url: job.company_logo || 'https://via.placeholder.com/100',
            website: job.company_website || '',
            city: job.city || 'India',
            description: `${companyName} - IT company`
          })
          .select()
          .single();

        if (compErr) { skipped++; continue; }
        companyId = newCompany.id;
      }

      // Normalize salary to annual INR
      let salaryMin = job.salary_min;
      let salaryMax = job.salary_max;
      if (salaryMin && job.salary_period !== 'YEAR') {
        salaryMin = salaryMin * 12;
      }
      if (salaryMax && job.salary_period !== 'YEAR') {
        salaryMax = salaryMax * 12;
      }

      const { error: jobErr } = await supabase
        .from('jobs')
        .insert({
          company_id: companyId,
          title: job.title,
          description: (job.description || '').slice(0, 5000),
          city: job.city || 'Remote',
          annual_ctc_min: salaryMin,
          annual_ctc_max: salaryMax,
          tech_stack: job.tech_stack || [],
          ats_url: job.apply_link || 'https://example.com',
          is_active: true
        });

      if (jobErr) { skipped++; } else { synced++; }
    }

    res.json({
      success: true,
      message: `Synced ${synced} jobs, skipped ${skipped}`,
      total_fetched: allJobs.length,
      synced,
      skipped
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// --- Utility functions ---
function buildSearchQuery(query, city, company) {
  let searchQuery = query || 'software developer';
  if (company) searchQuery = `${company} ${searchQuery}`;
  if (city) searchQuery += ` in ${city}, India`;
  else searchQuery += ' in India';
  return searchQuery;
}

function extractSalary(salaryStr, type) {
  if (!salaryStr) return null;
  const numbers = salaryStr.match(/[\d,]+/g);
  if (!numbers) return null;
  const parsed = numbers.map(n => parseInt(n.replace(/,/g, '')));
  if (type === 'min') return parsed[0] || null;
  if (type === 'max') return parsed[parsed.length - 1] || null;
  return null;
}

function extractTechStack(title, description) {
  const techKeywords = [
    'JavaScript', 'Python', 'Java', 'React', 'Node.js', 'Angular', 'Vue',
    'TypeScript', 'Go', 'Rust', 'C++', 'C#', '.NET', 'Ruby', 'PHP',
    'AWS', 'Azure', 'GCP', 'Docker', 'Kubernetes', 'Terraform',
    'MongoDB', 'PostgreSQL', 'MySQL', 'Redis', 'Elasticsearch',
    'Spring Boot', 'Django', 'Flask', 'Express', 'Next.js',
    'Flutter', 'React Native', 'Swift', 'Kotlin',
    'Machine Learning', 'AI', 'Deep Learning', 'NLP',
    'GraphQL', 'REST', 'Microservices', 'CI/CD', 'DevOps',
    'Spark', 'Hadoop', 'Kafka', 'RabbitMQ', 'Tableau', 'Power BI',
  ];
  const text = `${title || ''} ${description || ''}`.toLowerCase();
  return techKeywords.filter(tech => text.includes(tech.toLowerCase()));
}
