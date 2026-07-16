import { supabase } from '../config/supabase.js';
import { getCostOfLiving } from '../utils/externalApis.js';

const INDIAN_METRO_CITIES = [
  'Bangalore',
  'Mumbai',
  'Delhi',
  'Hyderabad',
  'Pune',
  'Chennai',
  'Kolkata',
  'Noida',
  'Gurgaon',
  'Ahmedabad',
  'Jaipur',
  'Chandigarh',
  'Kochi',
  'Indore',
  'Lucknow',
  'Coimbatore',
  'Thiruvananthapuram',
  'Nagpur',
  'Visakhapatnam',
  'Bhubaneswar'
];

// Fallback hardcoded cost of living data for Indian metro cities (in INR)
// Used only if external APIs fail
const FALLBACK_COSTS = {
  'Bangalore': {
    city: 'Bangalore',
    rent_1br_center: 18000,
    rent_1br_outside: 12000,
    grocery_monthly: 4500,
    transportation: 2000,
    utilities: 1500,
    dining_out: 3000,
    entertainment: 2000,
    total_monthly: 43000,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Mumbai': {
    city: 'Mumbai',
    rent_1br_center: 25000,
    rent_1br_outside: 16000,
    grocery_monthly: 5000,
    transportation: 2500,
    utilities: 1800,
    dining_out: 3500,
    entertainment: 2500,
    total_monthly: 56800,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Delhi': {
    city: 'Delhi',
    rent_1br_center: 20000,
    rent_1br_outside: 13000,
    grocery_monthly: 4000,
    transportation: 2000,
    utilities: 1500,
    dining_out: 2800,
    entertainment: 1800,
    total_monthly: 45100,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Hyderabad': {
    city: 'Hyderabad',
    rent_1br_center: 15000,
    rent_1br_outside: 10000,
    grocery_monthly: 3500,
    transportation: 1500,
    utilities: 1200,
    dining_out: 2500,
    entertainment: 1500,
    total_monthly: 35200,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Pune': {
    city: 'Pune',
    rent_1br_center: 14000,
    rent_1br_outside: 9000,
    grocery_monthly: 3500,
    transportation: 1500,
    utilities: 1200,
    dining_out: 2500,
    entertainment: 1500,
    total_monthly: 33700,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Chennai': {
    city: 'Chennai',
    rent_1br_center: 12000,
    rent_1br_outside: 8000,
    grocery_monthly: 3000,
    transportation: 1200,
    utilities: 1000,
    dining_out: 2000,
    entertainment: 1200,
    total_monthly: 28400,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Kolkata': {
    city: 'Kolkata',
    rent_1br_center: 10000,
    rent_1br_outside: 6500,
    grocery_monthly: 2500,
    transportation: 1000,
    utilities: 800,
    dining_out: 1800,
    entertainment: 1000,
    total_monthly: 23600,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Noida': {
    city: 'Noida',
    rent_1br_center: 12000,
    rent_1br_outside: 8000,
    grocery_monthly: 3000,
    transportation: 1500,
    utilities: 1000,
    dining_out: 2200,
    entertainment: 1300,
    total_monthly: 29000,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Gurgaon': {
    city: 'Gurgaon',
    rent_1br_center: 16000,
    rent_1br_outside: 11000,
    grocery_monthly: 3500,
    transportation: 2000,
    utilities: 1200,
    dining_out: 2800,
    entertainment: 1800,
    total_monthly: 38300,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Ahmedabad': {
    city: 'Ahmedabad',
    rent_1br_center: 10000,
    rent_1br_outside: 6500,
    grocery_monthly: 2800,
    transportation: 1000,
    utilities: 900,
    dining_out: 1800,
    entertainment: 1000,
    total_monthly: 24000,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Jaipur': {
    city: 'Jaipur',
    rent_1br_center: 9000,
    rent_1br_outside: 5500,
    grocery_monthly: 2500,
    transportation: 800,
    utilities: 800,
    dining_out: 1500,
    entertainment: 800,
    total_monthly: 20900,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Chandigarh': {
    city: 'Chandigarh',
    rent_1br_center: 11000,
    rent_1br_outside: 7000,
    grocery_monthly: 3000,
    transportation: 1000,
    utilities: 900,
    dining_out: 2000,
    entertainment: 1200,
    total_monthly: 26100,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Kochi': {
    city: 'Kochi',
    rent_1br_center: 11000,
    rent_1br_outside: 7000,
    grocery_monthly: 3000,
    transportation: 1000,
    utilities: 900,
    dining_out: 2000,
    entertainment: 1200,
    total_monthly: 26100,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Indore': {
    city: 'Indore',
    rent_1br_center: 8000,
    rent_1br_outside: 5000,
    grocery_monthly: 2200,
    transportation: 700,
    utilities: 700,
    dining_out: 1300,
    entertainment: 700,
    total_monthly: 18600,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Lucknow': {
    city: 'Lucknow',
    rent_1br_center: 8000,
    rent_1br_outside: 5000,
    grocery_monthly: 2200,
    transportation: 700,
    utilities: 700,
    dining_out: 1300,
    entertainment: 700,
    total_monthly: 18600,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Coimbatore': {
    city: 'Coimbatore',
    rent_1br_center: 9000,
    rent_1br_outside: 5500,
    grocery_monthly: 2500,
    transportation: 800,
    utilities: 800,
    dining_out: 1500,
    entertainment: 800,
    total_monthly: 20900,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Thiruvananthapuram': {
    city: 'Thiruvananthapuram',
    rent_1br_center: 10000,
    rent_1br_outside: 6500,
    grocery_monthly: 2800,
    transportation: 1000,
    utilities: 900,
    dining_out: 1800,
    entertainment: 1000,
    total_monthly: 24000,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Nagpur': {
    city: 'Nagpur',
    rent_1br_center: 8000,
    rent_1br_outside: 5000,
    grocery_monthly: 2200,
    transportation: 700,
    utilities: 700,
    dining_out: 1300,
    entertainment: 700,
    total_monthly: 18600,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Visakhapatnam': {
    city: 'Visakhapatnam',
    rent_1br_center: 9000,
    rent_1br_outside: 5500,
    grocery_monthly: 2500,
    transportation: 800,
    utilities: 800,
    dining_out: 1500,
    entertainment: 800,
    total_monthly: 20900,
    currency: 'INR',
    last_updated: new Date().toISOString()
  },
  'Bhubaneswar': {
    city: 'Bhubaneswar',
    rent_1br_center: 8000,
    rent_1br_outside: 5000,
    grocery_monthly: 2200,
    transportation: 700,
    utilities: 700,
    dining_out: 1300,
    entertainment: 700,
    total_monthly: 18600,
    currency: 'INR',
    last_updated: new Date().toISOString()
  }
};

// Get cost of living for a specific city
export const getCostOfLivingHandler = async (req, res) => {
  try {
    const { city } = req.params;

    if (!city) {
      return res.status(400).json({ error: 'City parameter is required' });
    }

    // Check if city is in our supported list
    if (!INDIAN_METRO_CITIES.includes(city)) {
      return res.status(404).json({
        error: `City '${city}' not found. Supported cities: ${INDIAN_METRO_CITIES.join(', ')}`
      });
    }

    try {
      // Try to fetch from external API
      const costData = await getCostOfLiving(city);
      return res.json({
        success: true,
        data: costData,
        source: 'live'
      });
    } catch (apiError) {
      console.warn(`External API failed for ${city}, using fallback data`);
      // Use fallback data if external API fails
      if (FALLBACK_COSTS[city]) {
        return res.json({
          success: true,
          data: FALLBACK_COSTS[city],
          source: 'fallback',
          warning: 'Using cached data. Live API unavailable.'
        });
      }
      throw apiError;
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get all supported cities with cost of living
export const getAllCostOfLiving = async (req, res) => {
  try {
    const allCities = [];
    let failedCities = [];

    // Try to fetch live data for all cities
    for (const city of INDIAN_METRO_CITIES) {
      try {
        const costData = await getCostOfLiving(city);
        allCities.push(costData);
      } catch (error) {
        console.warn(`Failed to fetch live data for ${city}, using fallback`);
        if (FALLBACK_COSTS[city]) {
          allCities.push(FALLBACK_COSTS[city]);
          failedCities.push(city);
        }
      }
    }

    res.json({
      success: true,
      total: allCities.length,
      data: allCities,
      ...(failedCities.length > 0 && { warning: `Using fallback data for: ${failedCities.join(', ')}` })
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Calculate affordability score based on salary and city
export const calculateAffordability = async (req, res) => {
  try {
    const { salary, city } = req.query;

    if (!salary || !city) {
      return res.status(400).json({
        error: 'Both salary and city parameters are required'
      });
    }

    const monthlySalary = parseFloat(salary);
    if (isNaN(monthlySalary) || monthlySalary <= 0) {
      return res.status(400).json({ error: 'Salary must be a positive number' });
    }

    if (!INDIAN_METRO_CITIES.includes(city)) {
      return res.status(404).json({
        error: `City '${city}' not found`
      });
    }

    let costData;
    let source = 'live';

    try {
      // Try to fetch from external API
      costData = await getCostOfLiving(city);
    } catch (apiError) {
      console.warn(`External API failed for ${city}, using fallback data`);
      // Use fallback data if external API fails
      if (FALLBACK_COSTS[city]) {
        costData = FALLBACK_COSTS[city];
        source = 'fallback';
      } else {
        throw apiError;
      }
    }

    const monthlyExpenses = costData.total_monthly;
    const remainingAmount = monthlySalary - monthlyExpenses;
    const affordabilityScore = Math.max(0, Math.min(100, (remainingAmount / monthlySalary) * 100));

    // Determine affordability level
    let affordabilityLevel = 'Affordable';
    let colorCode = 'green';

    if (affordabilityScore < 10) {
      affordabilityLevel = 'Tight Budget';
      colorCode = 'red';
    } else if (affordabilityScore < 30) {
      affordabilityLevel = 'Moderate';
      colorCode = 'yellow';
    }

    res.json({
      success: true,
      data: {
        city,
        salary: monthlySalary,
        monthlyExpenses,
        remainingAmount: Math.max(0, remainingAmount),
        affordabilityScore: Math.round(affordabilityScore),
        affordabilityLevel,
        colorCode,
        breakdown: {
          rent: costData.rent_1br_center,
          grocery: costData.grocery_monthly,
          transportation: costData.transportation,
          utilities: costData.utilities,
          dining: costData.dining_out,
          entertainment: costData.entertainment
        }
      },
      source
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get list of supported cities
export const getSupportedCities = (req, res) => {
  try {
    const cities = INDIAN_METRO_CITIES.map(city => ({
      name: city,
      totalMonthlyExpense: FALLBACK_COSTS[city]?.total_monthly || 0
    }));

    res.json({
      success: true,
      total: cities.length,
      data: cities
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
