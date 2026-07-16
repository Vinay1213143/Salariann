import { getCostOfLiving } from './externalApis.js';

// Fallback cost of living data (used only if live scraping fails)
const FALLBACK_COSTS = {
  'Bangalore': { total: 43000, rent: 18000, grocery: 4500, transport: 2000, utilities: 1500, dining: 3000, entertainment: 2000 },
  'Mumbai': { total: 56800, rent: 25000, grocery: 5000, transport: 2500, utilities: 1800, dining: 3500, entertainment: 2500 },
  'Delhi': { total: 45100, rent: 20000, grocery: 4000, transport: 2000, utilities: 1500, dining: 2800, entertainment: 1800 },
  'Hyderabad': { total: 35200, rent: 15000, grocery: 3500, transport: 1500, utilities: 1200, dining: 2500, entertainment: 1500 },
  'Pune': { total: 33700, rent: 14000, grocery: 3500, transport: 1500, utilities: 1200, dining: 2500, entertainment: 1500 },
  'Chennai': { total: 28400, rent: 12000, grocery: 3000, transport: 1200, utilities: 1000, dining: 2000, entertainment: 1200 },
  'Kolkata': { total: 23600, rent: 10000, grocery: 2500, transport: 1000, utilities: 800, dining: 1800, entertainment: 1000 },
  'Noida': { total: 29000, rent: 12000, grocery: 3000, transport: 1500, utilities: 1000, dining: 2200, entertainment: 1300 },
  'Gurgaon': { total: 38300, rent: 16000, grocery: 3500, transport: 2000, utilities: 1200, dining: 2800, entertainment: 1800 },
  'Ahmedabad': { total: 24000, rent: 10000, grocery: 2800, transport: 1000, utilities: 900, dining: 1800, entertainment: 1000 },
  'Jaipur': { total: 20900, rent: 9000, grocery: 2500, transport: 800, utilities: 800, dining: 1500, entertainment: 800 },
  'Chandigarh': { total: 26100, rent: 11000, grocery: 3000, transport: 1000, utilities: 900, dining: 2000, entertainment: 1200 },
  'Kochi': { total: 26100, rent: 11000, grocery: 3000, transport: 1000, utilities: 900, dining: 2000, entertainment: 1200 },
  'Indore': { total: 18600, rent: 8000, grocery: 2200, transport: 700, utilities: 700, dining: 1300, entertainment: 700 },
  'Lucknow': { total: 18600, rent: 8000, grocery: 2200, transport: 700, utilities: 700, dining: 1300, entertainment: 700 },
  'Coimbatore': { total: 20900, rent: 9000, grocery: 2500, transport: 800, utilities: 800, dining: 1500, entertainment: 800 },
  'Thiruvananthapuram': { total: 24000, rent: 10000, grocery: 2800, transport: 1000, utilities: 900, dining: 1800, entertainment: 1000 },
  'Nagpur': { total: 18600, rent: 8000, grocery: 2200, transport: 700, utilities: 700, dining: 1300, entertainment: 700 },
  'Visakhapatnam': { total: 20900, rent: 9000, grocery: 2500, transport: 800, utilities: 800, dining: 1500, entertainment: 800 },
  'Bhubaneswar': { total: 18600, rent: 8000, grocery: 2200, transport: 700, utilities: 700, dining: 1300, entertainment: 700 }
};

/**
 * Map live API data to the breakdown format used by affordability calculations
 */
function mapLiveToBreakdown(liveData) {
  return {
    total: liveData.total_monthly,
    rent: liveData.rent_1br_center || liveData.rent_1br_outside,
    grocery: liveData.grocery_monthly,
    transport: liveData.transportation,
    utilities: liveData.utilities,
    dining: liveData.dining_out,
    entertainment: liveData.entertainment
  };
}

export async function calculateAffordabilityScore(salary, city) {
  if (!salary || salary <= 0) return null;

  let costData;
  let source = 'live';

  try {
    const liveData = await getCostOfLiving(city);
    costData = mapLiveToBreakdown(liveData);
  } catch (error) {
    costData = FALLBACK_COSTS[city];
    source = 'fallback';
  }

  if (!costData) return null;

  const monthlySalary = salary / 12; // Convert annual to monthly
  const monthlyExpenses = costData.total;
  const remainingAmount = monthlySalary - monthlyExpenses;
  const affordabilityScore = Math.max(0, Math.min(100, (remainingAmount / monthlySalary) * 100));

  let affordabilityLevel = 'Affordable';
  let colorCode = 'green';

  if (affordabilityScore < 10) {
    affordabilityLevel = 'Tight Budget';
    colorCode = 'red';
  } else if (affordabilityScore < 30) {
    affordabilityLevel = 'Moderate';
    colorCode = 'yellow';
  }

  return {
    score: Math.round(affordabilityScore),
    level: affordabilityLevel,
    colorCode,
    monthlyExpenses,
    remainingMonthly: Math.max(0, remainingAmount),
    breakdown: costData,
    source
  };
}

export async function getAffordabilityBadge(salary, city) {
  const affordability = await calculateAffordabilityScore(salary, city);
  if (!affordability) return null;

  const { score } = affordability;
  
  if (score >= 30) {
    return `✓ Affordable in ${city}`;
  } else if (score >= 10) {
    return `⚠ Moderate in ${city}`;
  } else {
    return `✗ Tight budget in ${city}`;
  }
}
