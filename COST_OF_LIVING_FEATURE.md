# Cost of Living Integration - Salariann Platform

## Overview

The Salariann platform now includes a comprehensive **Cost of Living** feature that helps users make informed career decisions by comparing job salaries with the cost of living in different Indian metro cities. This feature is inspired by LinkedIn and Naukri platforms, providing affordability analysis for job opportunities.

---

## Features

### 1. **Affordability Score**
- Calculates how affordable a job is in a specific city
- Score ranges from 0-100%
- **Green (≥30%)**: Affordable - Salary covers expenses with good savings
- **Yellow (10-30%)**: Moderate - Salary covers expenses with minimal savings
- **Red (<10%)**: Tight Budget - Limited savings after expenses

### 2. **Cost Breakdown**
For each city, the system tracks:
- **Rent** (1-bedroom apartment in city center)
- **Grocery** (monthly food costs)
- **Transportation** (public transit/commute)
- **Utilities** (electricity, water, internet)
- **Dining Out** (restaurant meals)
- **Entertainment** (movies, activities, hobbies)

### 3. **Supported Cities (20 Indian Metros)**
Bangalore, Mumbai, Delhi, Hyderabad, Pune, Chennai, Kolkata, Noida, Gurgaon, Ahmedabad, Jaipur, Chandigarh, Kochi, Indore, Lucknow, Coimbatore, Thiruvananthapuram, Nagpur, Visakhapatnam, Bhubaneswar

---

## Backend Implementation

### API Endpoints

#### 1. Get Cost of Living for a City
```bash
GET /api/cost-of-living/:city
```
**Response:**
```json
{
  "success": true,
  "data": {
    "city": "Bangalore",
    "rent_1br_center": 18000,
    "rent_1br_outside": 12000,
    "grocery_monthly": 4500,
    "transportation": 2000,
    "utilities": 1500,
    "dining_out": 3000,
    "entertainment": 2000,
    "total_monthly": 43000,
    "currency": "INR"
  }
}
```

#### 2. Get All Supported Cities
```bash
GET /api/cost-of-living/cities
```
**Response:**
```json
{
  "success": true,
  "total": 20,
  "data": [
    { "name": "Bangalore", "totalMonthlyExpense": 43000 },
    { "name": "Mumbai", "totalMonthlyExpense": 56800 },
    ...
  ]
}
```

#### 3. Calculate Affordability
```bash
GET /api/affordability?salary=1500000&city=Bangalore
```
**Response:**
```json
{
  "success": true,
  "data": {
    "city": "Bangalore",
    "salary": 1500000,
    "monthlyExpenses": 43000,
    "remainingAmount": 82000,
    "affordabilityScore": 66,
    "affordabilityLevel": "Affordable",
    "colorCode": "green",
    "breakdown": {
      "rent": 18000,
      "grocery": 4500,
      "transportation": 2000,
      "utilities": 1500,
      "dining": 3000,
      "entertainment": 2000
    }
  }
}
```

#### 4. Get Jobs with Affordability
```bash
GET /api/jobs?city=Bangalore&limit=10
```
**Response includes:**
```json
{
  "id": "job-123",
  "title": "Senior Software Engineer",
  "city": "Bangalore",
  "annual_ctc_min": 1200000,
  "annual_ctc_max": 1800000,
  "affordability": {
    "score": 66,
    "level": "Affordable",
    "colorCode": "green",
    "monthlyExpenses": 43000,
    "remainingMonthly": 82000,
    "breakdown": { ... }
  },
  "affordabilityBadge": "✓ Affordable in Bangalore"
}
```

### Backend Files

- **Controller**: `/backend/src/controllers/costOfLiving.controller.js`
  - `getCostOfLiving(city)` - Get cost data for a city
  - `getAllCostOfLiving()` - Get all cities' cost data
  - `calculateAffordability(salary, city)` - Calculate affordability score
  - `getSupportedCities()` - List supported cities

- **Utility**: `/backend/src/utils/affordabilityScore.js`
  - `calculateAffordabilityScore(salary, city)` - Calculate score and breakdown
  - `getAffordabilityBadge(salary, city)` - Get badge text

- **Routes**: `/backend/src/routes/index.js`
  - `GET /cost-of-living/cities`
  - `GET /cost-of-living/:city`
  - `GET /cost-of-living`
  - `GET /affordability`

---

## Frontend Implementation

### Flutter Widgets

#### 1. **AffordabilityBadge**
Displays a colored badge showing affordability status
```dart
AffordabilityBadge(
  badge: "✓ Affordable in Bangalore",
  score: 66,
  colorCode: "green",
)
```

#### 2. **CostOfLivingCard**
Shows detailed cost breakdown for a city
```dart
CostOfLivingCard(costData: costOfLivingData)
```

#### 3. **AffordabilityBreakdown**
Shows salary vs expenses analysis with visual breakdown
```dart
AffordabilityBreakdown(affordability: affordabilityData)
```

### Services

- **CostOfLivingService** (`lib/services/cost_of_living_service.dart`)
  - Handles API calls to cost of living endpoints
  - Caches cost data locally
  - Provides data models: `CostOfLivingData`, `AffordabilityData`

### Providers

- **CostOfLivingProvider** (`lib/providers/cost_of_living_provider.dart`)
  - State management for cost of living data
  - Caching mechanism
  - Error handling

### UI Integration

#### Job List Screen
- Shows affordability badge on each job card
- Color-coded indicators (green/yellow/red)
- Quick affordability status at a glance

#### Job Details Screen
- Displays affordability badge in header
- Shows detailed cost breakdown
- Calculates remaining amount after expenses
- Percentage breakdown of each expense category

---

## Data Structure

### Cost of Living Data (INR - Monthly)

```
Bangalore:
├── Rent (1BR Center): ₹18,000
├── Rent (1BR Outside): ₹12,000
├── Grocery: ₹4,500
├── Transportation: ₹2,000
├── Utilities: ₹1,500
├── Dining Out: ₹3,000
├── Entertainment: ₹2,000
└── Total: ₹43,000

Mumbai:
├── Rent (1BR Center): ₹25,000
├── Rent (1BR Outside): ₹16,000
├── Grocery: ₹5,000
├── Transportation: ₹2,500
├── Utilities: ₹1,800
├── Dining Out: ₹3,500
├── Entertainment: ₹2,500
└── Total: ₹56,800

[Similar structure for other 18 cities...]
```

---

## Affordability Calculation

### Formula
```
Monthly Salary = Annual CTC / 12
Monthly Expenses = Sum of all cost categories
Remaining Amount = Monthly Salary - Monthly Expenses
Affordability Score = (Remaining Amount / Monthly Salary) × 100
```

### Example
```
Job: Senior Software Engineer in Bangalore
Annual CTC: ₹15,00,000
Monthly Salary: ₹1,25,000

Monthly Expenses: ₹43,000
Remaining Amount: ₹82,000

Affordability Score: (82,000 / 125,000) × 100 = 65.6% ≈ 66%
Status: ✓ Affordable (Green)
```

---

## Testing

### Test Endpoints

```bash
# Get cost of living for Bangalore
curl "http://localhost:3001/api/cost-of-living/Bangalore"

# Get all supported cities
curl "http://localhost:3001/api/cost-of-living/cities"

# Calculate affordability for a salary
curl "http://localhost:3001/api/affordability?salary=1500000&city=Bangalore"

# Get jobs with affordability data
curl "http://localhost:3001/api/jobs?city=Bangalore&limit=5"
```

---

## Future Enhancements

1. **Dynamic API Integration**
   - Integrate with Numbeo API for real-time cost data
   - Auto-update costs monthly

2. **User Preferences**
   - Allow users to customize expense categories
   - Save preferred cities

3. **Comparison Tool**
   - Compare affordability across multiple cities
   - Show salary adjustment needed for different cities

4. **Historical Data**
   - Track cost of living trends
   - Show year-over-year changes

5. **Advanced Filtering**
   - Filter jobs by affordability score
   - Show only "Affordable" jobs in selected cities

6. **Notifications**
   - Alert users when affordable jobs match their criteria
   - Notify when costs change significantly

---

## Configuration

### Environment Variables
No additional environment variables required. Cost data is hardcoded for reliability.

### Database
Currently uses hardcoded data. To integrate with database:
1. Create `cost_of_living` table in Supabase
2. Update `costOfLiving.controller.js` to fetch from database
3. Add periodic sync job to update costs

---

## Performance

- **Caching**: Cost data is cached on the frontend
- **Calculation**: Affordability calculated in real-time
- **API Response**: < 100ms for cost lookups
- **Job List**: Affordability added to existing job queries (no extra API calls)

---

## Accessibility

- Color-blind friendly: Uses icons + text, not just colors
- Clear labels and descriptions
- Responsive design for mobile and desktop
- High contrast affordability badges

---

## Support

For issues or questions about the cost of living feature:
1. Check the API endpoints documentation above
2. Review the Flutter widget implementations
3. Check backend controller logic
4. Verify cost data for your city

---

## Version History

- **v1.0** (June 2026): Initial implementation
  - 20 Indian metro cities supported
  - Affordability scoring system
  - Flutter UI integration
  - Backend API endpoints
