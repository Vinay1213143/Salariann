import axios from 'axios';

// Numbeo public pages URL (no API key needed)
const NUMBEO_BASE_URL = 'https://www.numbeo.com/cost-of-living/in';

// City name mapping for Numbeo URL slugs
const CITY_URL_MAP = {
  'Bangalore': 'Bangalore',
  'Mumbai': 'Mumbai',
  'Delhi': 'Delhi',
  'Hyderabad': 'Hyderabad',
  'Pune': 'Pune',
  'Chennai': 'Chennai',
  'Kolkata': 'Kolkata',
  'Noida': 'Noida',
  'Gurgaon': 'Gurgaon',
  'Ahmedabad': 'Ahmedabad',
  'Jaipur': 'Jaipur',
  'Chandigarh': 'Chandigarh',
  'Kochi': 'Kochi',
  'Indore': 'Indore',
  'Lucknow': 'Lucknow',
  'Coimbatore': 'Coimbatore',
  'Thiruvananthapuram': 'Thiruvananthapuram',
  'Nagpur': 'Nagpur',
  'Visakhapatnam': 'Visakhapatnam',
  'Bhubaneswar': 'Bhubaneswar'
};

// In-memory cache
const cache = new Map();
const CACHE_TTL = parseInt(process.env.CACHE_TTL || '3600') * 1000;

function getCachedValue(key) {
  const cached = cache.get(key);
  if (!cached) return null;
  if (Date.now() - cached.timestamp > CACHE_TTL) {
    cache.delete(key);
    return null;
  }
  return cached.value;
}

function setCachedValue(key, value) {
  cache.set(key, { value, timestamp: Date.now() });
}

/**
 * Parse a price string like "30,781.25" into a number
 */
function parsePrice(text) {
  if (!text) return 0;
  const cleaned = text.replace(/,/g, '').replace(/[^\d.]/g, '').trim();
  const val = parseFloat(cleaned);
  return isNaN(val) ? 0 : val;
}

/**
 * Scrape live cost of living data from Numbeo public pages.
 * NO API KEY REQUIRED — completely free.
 */
export async function getCostOfLiving(city) {
  const cacheKey = `numbeo_live_${city}`;
  const cached = getCachedValue(cacheKey);
  if (cached) {
    console.log(`[Cache HIT] Cost of living for ${city}`);
    return cached;
  }

  const slug = CITY_URL_MAP[city];
  if (!slug) {
    throw new Error(`City '${city}' is not supported`);
  }

  const url = `${NUMBEO_BASE_URL}/${slug}`;
  console.log(`[Live Fetch] Scraping Numbeo for ${city}: ${url}`);

  try {
    const response = await axios.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml',
        'Accept-Language': 'en-US,en;q=0.9'
      },
      timeout: 15000
    });

    const html = response.data;
    const costData = parseNumbeoHtml(city, html);

    if (costData.total_monthly > 0) {
      setCachedValue(cacheKey, costData);
      console.log(`[Live Fetch] Success for ${city}: ₹${costData.total_monthly}/month`);
      return costData;
    }

    throw new Error('Failed to parse price data from page');
  } catch (error) {
    console.error(`[Live Fetch] Failed for ${city}:`, error.message);
    throw error;
  }
}

/**
 * Parse Numbeo HTML page and extract cost of living data
 */
function parseNumbeoHtml(city, html) {
  const costData = {
    city,
    rent_1br_center: 0,
    rent_1br_outside: 0,
    grocery_monthly: 0,
    transportation: 0,
    utilities: 0,
    dining_out: 0,
    entertainment: 0,
    total_monthly: 0,
    currency: 'INR',
    source: 'numbeo_live',
    last_updated: new Date().toISOString()
  };

  // Extract prices: <tr><td>Item Name</td> <td class="priceValue"> <span class="first_currency">₹Price</span>
  // Item names may contain <sup> tags (e.g., m<sup>2</sup>)
  const itemPriceRegex = /<tr><td[^>]*>([^<]+(?:<sup>\d+<\/sup>[^<]*)?)\s*<\/td>\s*<td[^>]*class="priceValue[^"]*"[^>]*>\s*<span[^>]*class="first_currency"[^>]*>&#x20b9;([\d,.]+)<\/span>/g;
  let match;

  const prices = {};
  while ((match = itemPriceRegex.exec(html)) !== null) {
    const itemName = match[1].replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim();
    const value = parsePrice(match[2]);
    if (itemName && value > 0) {
      prices[itemName] = value;
    }
  }
  console.log(`[Parser] Extracted ${Object.keys(prices).length} price items for ${city}`);

  // Rent
  costData.rent_1br_center = prices['1 Bedroom Apartment in City Centre'] || 0;
  costData.rent_1br_outside = prices['1 Bedroom Apartment Outside of City Centre'] || 0;

  // Grocery — sum individual items then multiply to estimate monthly
  const groceryItems = [
    prices['Milk (Regular, 1 Liter)'] || 0,
    prices['Fresh White Bread (500 g Loaf)'] || 0,
    prices['White Rice (1 kg)'] || 0,
    prices['Eggs (12, Large Size)'] || 0,
    prices['Chicken Fillets (1 kg)'] || 0,
  ];
  // Estimate: a person buys each ~4 times/month
  costData.grocery_monthly = Math.round(groceryItems.reduce((a, b) => a + b, 0) * 4);

  // Transportation — monthly pass + some taxi usage
  const monthlyPass = prices['Monthly Public Transport Pass (Regular Price)'] || 0;
  const taxiPerKm = prices['Taxi 1 km (Standard Tariff)'] || 0;
  // Estimate: monthly pass + ~40km taxi per month
  costData.transportation = Math.round(monthlyPass + (taxiPerKm * 40));

  // Utilities — key becomes "Basic Utilities for 85 m2 Apartment ..." after stripping <sup>
  const utilitiesKey = Object.keys(prices).find(k => k.includes('Basic Utilities')) || '';
  const basicUtilities = prices[utilitiesKey] || 0;
  const internet = prices['Broadband Internet (Unlimited Data, 60 Mbps or Higher)'] || 0;
  costData.utilities = Math.round(basicUtilities + internet);

  // Dining out — estimate 8 inexpensive meals + 2 mid-range meals per month
  const cheapMeal = prices['Meal at an Inexpensive Restaurant'] || 0;
  const midMeal = prices['Meal for Two at a Mid-Range Restaurant (Three Courses, Without Drinks)'] || 0;
  costData.dining_out = Math.round((cheapMeal * 8) + (midMeal * 2));

  // Entertainment — 2 cinema + 1 fitness membership
  const cinema = prices['Cinema Ticket (International Release)'] || 0;
  const fitness = prices['Monthly Fitness Club Membership'] || 0;
  costData.entertainment = Math.round((cinema * 2) + fitness);

  // Total
  const rent = costData.rent_1br_center || costData.rent_1br_outside;
  costData.total_monthly = Math.round(
    rent + costData.grocery_monthly + costData.transportation +
    costData.utilities + costData.dining_out + costData.entertainment
  );

  return costData;
}

/**
 * Clear cache
 */
export function clearCache() {
  cache.clear();
}

/**
 * Get cache stats
 */
export function getCacheStats() {
  return {
    size: cache.size,
    ttl: CACHE_TTL / 1000
  };
}
