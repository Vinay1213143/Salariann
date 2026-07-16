import { supabase } from '../config/supabase.js';
import { calculateSuitabilityScore } from '../utils/suitabilityScore.js';
import { calculateAffordabilityScore, getAffordabilityBadge } from '../utils/affordabilityScore.js';

// API Configuration
const REMOTEOK_API = 'https://remoteok.com/api';
const REMOTIVE_API = 'https://remotive.com/api/remote-jobs';
const JSEARCH_API_URL = 'https://jsearch.p.rapidapi.com/search';
const RAPIDAPI_KEY = process.env.RAPIDAPI_KEY;

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

// Fetch from RemoteOK
async function fetchFromRemoteOK(query) {
  try {
    const response = await fetch(REMOTEOK_API, {
      headers: { 'User-Agent': 'Salariann/1.0' }
    });
    if (!response.ok) return [];

    const data = await response.json();
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
        city: 'Remote',
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
        source: 'remoteok'
      }));
  } catch (error) {
    console.error('RemoteOK fetch error:', error.message);
    return [];
  }
}

// Fetch from Remotive
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
      city: job.candidate_required_location || 'Remote',
      country: job.candidate_required_location || 'Worldwide',
      description: (job.description || '').replace(/<[^>]*>/g, '').slice(0, 2000),
      employment_type: job.job_type || 'Full-time',
      is_remote: true,
      salary_min: null,
      salary_max: null,
      salary_period: 'YEAR',
      posted_at: job.publication_date || new Date().toISOString(),
      apply_link: job.url || null,
      tech_stack: job.tags || [],
      source: 'remotive'
    }));
  } catch (error) {
    console.error('Remotive fetch error:', error.message);
    return [];
  }
}

// Fetch from JSearch
async function fetchFromJSearch(query) {
  if (!RAPIDAPI_KEY) return [];
  
  try {
    const params = new URLSearchParams({
      query: query || 'software engineer',
      page: '1',
      num_pages: '1'
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

    return jobs.slice(0, 25).map(job => ({
      id: `jsearch-${job.job_id}`,
      title: job.job_title || 'Unknown Role',
      company: job.employer_name || 'Unknown',
      company_logo: job.employer_logo || null,
      city: job.job_city || 'Remote',
      country: job.job_country || 'Worldwide',
      description: job.job_description || '',
      employment_type: job.job_employment_type || 'Full-time',
      is_remote: job.job_is_remote || false,
      salary_min: job.job_min_salary || null,
      salary_max: job.job_max_salary || null,
      salary_period: 'YEAR',
      posted_at: job.job_posted_at_datetime_utc || new Date().toISOString(),
      apply_link: job.job_apply_link || null,
      tech_stack: [],
      source: 'jsearch'
    }));
  } catch (error) {
    console.error('JSearch fetch error:', error.message);
    return [];
  }
}

export async function getJobs(req, res) {
  try {
    const { search = '', city = '', limit = 20, offset = 0 } = req.query;
    const cacheKey = `jobs-${search}-${city}-${limit}-${offset}`;
    
    // Check cache
    const cached = getCached(cacheKey);
    if (cached) {
      return res.json(cached);
    }

    // Fetch from all sources in parallel
    const [remoteokResult, remotiveResult, jsearchResult] = await Promise.allSettled([
      fetchFromRemoteOK(search),
      fetchFromRemotive(search),
      fetchFromJSearch(search)
    ]);

    let allJobs = [];
    if (remoteokResult.status === 'fulfilled') allJobs = allJobs.concat(remoteokResult.value);
    if (remotiveResult.status === 'fulfilled') allJobs = allJobs.concat(remotiveResult.value);
    if (jsearchResult.status === 'fulfilled') allJobs = allJobs.concat(jsearchResult.value);

    // Filter by city if provided
    if (city) {
      allJobs = allJobs.filter(job => 
        job.city.toLowerCase().includes(city.toLowerCase()) ||
        job.country.toLowerCase().includes(city.toLowerCase())
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

        let suitabilityScore = null;
        let affordability = null;
        let affordabilityBadge = null;

        if (avgCtc) {
          const { data: cityData } = await supabase
            .from('city_metrics')
            .select('*')
            .ilike('city_name', `%${job.city}%`)
            .eq('lifestyle', 'single')
            .single();

          if (cityData) {
            suitabilityScore = calculateSuitabilityScore(avgCtc, cityData);
            affordability = await calculateAffordabilityScore(avgCtc, job.city);
            affordabilityBadge = await getAffordabilityBadge(avgCtc, job.city);
          }
        }

        return {
          ...job,
          suitabilityScore,
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

export async function getJobById(req, res) {
  try {
    const { id } = req.params;

    // Search for job in all sources
    const [remoteokResult, remotiveResult, jsearchResult] = await Promise.allSettled([
      fetchFromRemoteOK(''),
      fetchFromRemotive(''),
      fetchFromJSearch('')
    ]);

    let allJobs = [];
    if (remoteokResult.status === 'fulfilled') allJobs = allJobs.concat(remoteokResult.value);
    if (remotiveResult.status === 'fulfilled') allJobs = allJobs.concat(remotiveResult.value);
    if (jsearchResult.status === 'fulfilled') allJobs = allJobs.concat(jsearchResult.value);

    const job = allJobs.find(j => j.id === id);

    if (!job) {
      return res.status(404).json({ error: 'Job not found' });
    }

    const avgCtc = job.salary_max
      ? (job.salary_min + job.salary_max) / 2
      : job.salary_min;

    let suitabilityScore = null;
    let affordability = null;
    let affordabilityBadge = null;
    let cityData = null;

    if (avgCtc) {
      const { data } = await supabase
        .from('city_metrics')
        .select('*')
        .ilike('city_name', `%${job.city}%`)
        .eq('lifestyle', 'single')
        .single();

      if (data) {
        cityData = data;
        suitabilityScore = calculateSuitabilityScore(avgCtc, data);
        affordability = await calculateAffordabilityScore(avgCtc, job.city);
        affordabilityBadge = await getAffordabilityBadge(avgCtc, job.city);
      }
    }

    return res.json({
      ...job,
      suitabilityScore,
      affordability,
      affordabilityBadge,
      cityMetrics: cityData,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

export async function logJobClick(req, res) {
  try {
    const { job_id } = req.body;
    const user_id = req.user?.sub || null;

    const { data, error } = await supabase.from('click_events').insert([
      {
        user_id,
        job_id,
      },
    ]);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.status(201).json({ success: true, data });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
