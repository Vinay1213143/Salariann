import { supabase } from '../config/supabase.js';

// Comprehensive list of Indian IT companies with details
const INDIAN_IT_COMPANIES_DATA = [
  {
    id: 'tcs',
    name: 'Tata Consultancy Services',
    shortName: 'TCS',
    city: 'Mumbai',
    country: 'India',
    website: 'https://www.tcs.com',
    logo_url: 'https://via.placeholder.com/100?text=TCS',
    employee_count: 500000,
    founded_year: 1968,
    description: 'India\'s largest IT services company providing IT, business and outsourcing services.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Mumbai', 'Pune', 'Hyderabad', 'Delhi', 'Chennai', 'Kolkata'],
  },
  {
    id: 'infosys',
    name: 'Infosys Limited',
    shortName: 'Infosys',
    city: 'Bangalore',
    country: 'India',
    website: 'https://www.infosys.com',
    logo_url: 'https://via.placeholder.com/100?text=Infosys',
    employee_count: 300000,
    founded_year: 1981,
    description: 'Global leader in next-generation digital services and consulting.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Pune', 'Hyderabad', 'Chennai', 'Mumbai'],
  },
  {
    id: 'wipro',
    name: 'Wipro Limited',
    shortName: 'Wipro',
    city: 'Bangalore',
    country: 'India',
    website: 'https://www.wipro.com',
    logo_url: 'https://via.placeholder.com/100?text=Wipro',
    employee_count: 250000,
    founded_year: 1980,
    description: 'Leading global information technology, consulting and business process services company.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Pune', 'Hyderabad', 'Chennai', 'Kolkata'],
  },
  {
    id: 'hcl',
    name: 'HCL Technologies',
    shortName: 'HCL',
    city: 'Noida',
    country: 'India',
    website: 'https://www.hcltech.com',
    logo_url: 'https://via.placeholder.com/100?text=HCL',
    employee_count: 220000,
    founded_year: 1976,
    description: 'Global IT services and consulting company.',
    industry: 'IT Services',
    locations: ['Noida', 'Bangalore', 'Pune', 'Hyderabad', 'Chennai'],
  },
  {
    id: 'tech-mahindra',
    name: 'Tech Mahindra',
    shortName: 'Tech Mahindra',
    city: 'Pune',
    country: 'India',
    website: 'https://www.techmahindra.com',
    logo_url: 'https://via.placeholder.com/100?text=TechM',
    employee_count: 150000,
    founded_year: 1986,
    description: 'Leading provider of digital transformation, consulting, and business reengineering services.',
    industry: 'IT Services',
    locations: ['Pune', 'Bangalore', 'Hyderabad', 'Mumbai', 'Chennai'],
  },
  {
    id: 'cognizant',
    name: 'Cognizant Technology Solutions',
    shortName: 'Cognizant',
    city: 'Bangalore',
    country: 'India',
    website: 'https://www.cognizant.com',
    logo_url: 'https://via.placeholder.com/100?text=Cognizant',
    employee_count: 300000,
    founded_year: 1994,
    description: 'Multinational IT services and consulting company.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Pune', 'Hyderabad', 'Chennai', 'Mumbai'],
  },
  {
    id: 'accenture',
    name: 'Accenture India',
    shortName: 'Accenture',
    city: 'Bangalore',
    country: 'India',
    website: 'https://www.accenture.com/in-en',
    logo_url: 'https://via.placeholder.com/100?text=Accenture',
    employee_count: 100000,
    founded_year: 2001,
    description: 'Global professional services company providing strategy, consulting, digital, technology and operations services.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Pune', 'Hyderabad', 'Mumbai', 'Delhi'],
  },
  {
    id: 'ibm-india',
    name: 'IBM India',
    shortName: 'IBM',
    city: 'Bangalore',
    country: 'India',
    website: 'https://www.ibm.com/in-en',
    logo_url: 'https://via.placeholder.com/100?text=IBM',
    employee_count: 50000,
    founded_year: 1992,
    description: 'Global technology and consulting company.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Pune', 'Hyderabad', 'Mumbai'],
  },
  {
    id: 'capgemini',
    name: 'Capgemini India',
    shortName: 'Capgemini',
    city: 'Bangalore',
    country: 'India',
    website: 'https://www.capgemini.com/in-en/',
    logo_url: 'https://via.placeholder.com/100?text=Capgemini',
    employee_count: 80000,
    founded_year: 1992,
    description: 'Global leader in consulting, technology services and digital transformation.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Pune', 'Hyderabad', 'Chennai'],
  },
  {
    id: 'lti-mindtree',
    name: 'LTI Mindtree',
    shortName: 'LTI Mindtree',
    city: 'Bangalore',
    country: 'India',
    website: 'https://www.ltimindtree.com',
    logo_url: 'https://via.placeholder.com/100?text=LTI',
    employee_count: 90000,
    founded_year: 2013,
    description: 'Global IT services and consulting company.',
    industry: 'IT Services',
    locations: ['Bangalore', 'Pune', 'Hyderabad', 'Chennai', 'Mumbai'],
  },
];

// In-memory cache
const companyCache = new Map();
const CACHE_TTL = parseInt(process.env.CACHE_TTL || '14400') * 1000; // 4 hours

function getCached(key) {
  const entry = companyCache.get(key);
  if (entry && Date.now() - entry.timestamp < CACHE_TTL) return entry.data;
  companyCache.delete(key);
  return null;
}

function setCache(key, data) {
  companyCache.set(key, { data, timestamp: Date.now() });
}

// Get all Indian IT companies
export async function getIndianITCompanies(req, res) {
  try {
    const { search = '', city = '', limit = 20, offset = 0 } = req.query;
    const cacheKey = `india-companies-${search}-${city}-${limit}-${offset}`;

    // Check cache
    const cached = getCached(cacheKey);
    if (cached) {
      return res.json(cached);
    }

    let companies = INDIAN_IT_COMPANIES_DATA;

    // Filter by search
    if (search) {
      companies = companies.filter(company =>
        company.name.toLowerCase().includes(search.toLowerCase()) ||
        company.shortName.toLowerCase().includes(search.toLowerCase()) ||
        company.description.toLowerCase().includes(search.toLowerCase())
      );
    }

    // Filter by city
    if (city) {
      companies = companies.filter(company =>
        company.city.toLowerCase().includes(city.toLowerCase()) ||
        company.locations.some(loc => loc.toLowerCase().includes(city.toLowerCase()))
      );
    }

    // Sort by name
    companies.sort((a, b) => a.name.localeCompare(b.name));

    // Apply pagination
    const total = companies.length;
    const paginatedCompanies = companies.slice(parseInt(offset), parseInt(offset) + parseInt(limit));

    // Get ratings and reviews from database
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

// Get single company details
export async function getIndianCompanyById(req, res) {
  try {
    const { id } = req.params;

    const company = INDIAN_IT_COMPANIES_DATA.find(c => c.id === id);

    if (!company) {
      return res.status(404).json({ error: 'Company not found' });
    }

    // Get reviews from database
    const { data: reviews } = await supabase
      .from('reviews')
      .select('*')
      .ilike('company_name', `%${company.name}%`);

    // Get salaries from database
    const { data: salaries } = await supabase
      .from('salaries')
      .select('*')
      .ilike('company_name', `%${company.name}%`);

    // Get interviews from database
    const { data: interviews } = await supabase
      .from('interviews')
      .select('*')
      .ilike('company_name', `%${company.name}%`);

    const avgRating = reviews && reviews.length > 0
      ? (reviews.reduce((sum, r) => sum + (r.overall_rating || 0), 0) / reviews.length).toFixed(2)
      : null;

    return res.json({
      ...company,
      stats: {
        reviewCount: reviews?.length || 0,
        salaryDataCount: salaries?.length || 0,
        interviewCount: interviews?.length || 0,
        avgRating,
      },
      reviews,
      salaries,
      interviews,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Get companies by city
export async function getIndianCompaniesByCity(req, res) {
  try {
    const { city } = req.params;
    const { limit = 20, offset = 0 } = req.query;

    let companies = INDIAN_IT_COMPANIES_DATA.filter(company =>
      company.city.toLowerCase() === city.toLowerCase() ||
      company.locations.some(loc => loc.toLowerCase() === city.toLowerCase())
    );

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

// Get Indian cities with companies
export async function getIndianCitiesWithCompanies(req, res) {
  try {
    const citiesSet = new Set();
    
    INDIAN_IT_COMPANIES_DATA.forEach(company => {
      citiesSet.add(company.city);
      company.locations.forEach(loc => citiesSet.add(loc));
    });

    const cities = Array.from(citiesSet).sort();

    return res.json({
      data: cities,
      count: cities.length,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
