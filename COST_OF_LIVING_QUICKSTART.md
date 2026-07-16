# Cost of Living Feature - Quick Start Guide

## What's New?

Your Salariann platform now includes a **Cost of Living** feature that shows users how affordable jobs are in different Indian cities. It's similar to LinkedIn and Naukri platforms!

---

## For Users

### What You'll See

1. **On Job Listings**
   - Green badge: ✓ Affordable in [City]
   - Yellow badge: ⚠ Moderate in [City]
   - Red badge: ✗ Tight budget in [City]
   - Shows affordability percentage (e.g., 66%)

2. **On Job Details**
   - Affordability badge in the header
   - Detailed cost breakdown:
     - Monthly expenses
     - Remaining amount after expenses
     - Percentage breakdown of each cost category
   - Visual progress bar showing affordability score

### How It Works

The system calculates:
```
Affordability Score = (Remaining Money / Monthly Salary) × 100

Example:
- Monthly Salary: ₹1,25,000
- Monthly Expenses: ₹43,000
- Remaining: ₹82,000
- Score: 66% → Green → "Affordable"
```

### Supported Cities

All 20 major Indian metros:
Bangalore, Mumbai, Delhi, Hyderabad, Pune, Chennai, Kolkata, Noida, Gurgaon, Ahmedabad, Jaipur, Chandigarh, Kochi, Indore, Lucknow, Coimbatore, Thiruvananthapuram, Nagpur, Visakhapatnam, Bhubaneswar

---

## For Developers

### Backend API Endpoints

#### 1. Get Cost of Living for a City
```bash
curl "http://localhost:3001/api/cost-of-living/Bangalore"
```

#### 2. Get All Supported Cities
```bash
curl "http://localhost:3001/api/cost-of-living/cities"
```

#### 3. Calculate Affordability
```bash
curl "http://localhost:3001/api/affordability?salary=1500000&city=Bangalore"
```

#### 4. Get Jobs with Affordability (Already Integrated)
```bash
curl "http://localhost:3001/api/jobs?city=Bangalore"
```

### Backend Files to Know

- **Controller**: `backend/src/controllers/costOfLiving.controller.js`
- **Utility**: `backend/src/utils/affordabilityScore.js`
- **Routes**: `backend/src/routes/index.js` (lines with `/cost-of-living`)

### Frontend Files to Know

- **Service**: `frontend/lib/services/cost_of_living_service.dart`
- **Provider**: `frontend/lib/providers/cost_of_living_provider.dart`
- **Widgets**:
  - `frontend/lib/widgets/affordability_badge.dart`
  - `frontend/lib/widgets/cost_of_living_card.dart`
  - `frontend/lib/widgets/affordability_breakdown.dart`
- **Modified Screens**:
  - `frontend/lib/screens/jobs/job_dashboard_screen.dart`
  - `frontend/lib/screens/jobs/job_detail_screen.dart`

---

## Testing the Feature

### Quick Test

1. **Start the backend** (if not running):
   ```bash
   cd /Users/bhaveshtayade/Desktop/salariann/backend
   npm run dev
   ```

2. **Test the API**:
   ```bash
   # Get cost of living for Bangalore
   curl "http://localhost:3001/api/cost-of-living/Bangalore"
   
   # Calculate affordability for a salary
   curl "http://localhost:3001/api/affordability?salary=1500000&city=Bangalore"
   
   # Get jobs with affordability badges
   curl "http://localhost:3001/api/jobs?city=Bangalore&limit=1"
   ```

3. **Check the Frontend**:
   - Open the app in Flutter
   - Go to Jobs section
   - See affordability badges on job cards
   - Click a job to see detailed cost breakdown

### Expected Results

**Job Card** should show:
- Job title and company
- Location
- Salary range
- **Affordability badge** (e.g., "✓ Affordable in Bangalore 66%")

**Job Details** should show:
- **Affordability badge** in header
- **Cost Breakdown** section with:
  - Monthly expenses: ₹43,000
  - Remaining: ₹82,000
  - Score: 66%
  - Detailed breakdown (Rent, Grocery, Transport, etc.)

---

## Cost Data by City

### Bangalore
- Total Monthly: ₹43,000
- Rent: ₹18,000 | Grocery: ₹4,500 | Transport: ₹2,000
- Utilities: ₹1,500 | Dining: ₹3,000 | Entertainment: ₹2,000

### Mumbai
- Total Monthly: ₹56,800
- Rent: ₹25,000 | Grocery: ₹5,000 | Transport: ₹2,500
- Utilities: ₹1,800 | Dining: ₹3,500 | Entertainment: ₹2,500

### Delhi
- Total Monthly: ₹45,100
- Rent: ₹20,000 | Grocery: ₹4,000 | Transport: ₹2,000
- Utilities: ₹1,500 | Dining: ₹2,800 | Entertainment: ₹1,800

### Hyderabad
- Total Monthly: ₹35,200
- Rent: ₹15,000 | Grocery: ₹3,500 | Transport: ₹1,500
- Utilities: ₹1,200 | Dining: ₹2,500 | Entertainment: ₹1,500

### Pune
- Total Monthly: ₹33,700
- Rent: ₹14,000 | Grocery: ₹3,500 | Transport: ₹1,500
- Utilities: ₹1,200 | Dining: ₹2,500 | Entertainment: ₹1,500

[See COST_OF_LIVING_FEATURE.md for all 20 cities]

---

## Color Meanings

| Color | Score | Meaning | Icon |
|-------|-------|---------|------|
| 🟢 Green | ≥30% | Affordable | ✓ |
| 🟡 Yellow | 10-30% | Moderate | ⚠ |
| 🔴 Red | <10% | Tight Budget | ✗ |

---

## Common Questions

### Q: How is affordability calculated?
**A**: `(Monthly Salary - Monthly Expenses) / Monthly Salary × 100`

### Q: Can I change the cost data?
**A**: Currently hardcoded for reliability. To use dynamic data:
1. Create `cost_of_living` table in Supabase
2. Update `costOfLiving.controller.js` to fetch from database
3. Add admin panel to update costs

### Q: Why only 20 cities?
**A**: These are the major IT hubs in India. Can be expanded by adding more cities to the data.

### Q: Can I customize expense categories?
**A**: Currently fixed (Rent, Grocery, Transport, Utilities, Dining, Entertainment). Can be made customizable in future versions.

### Q: Is this data accurate?
**A**: Based on 2024-2025 market research. Costs vary by neighborhood. Use as a reference, not exact figures.

---

## Next Steps

### To Enhance the Feature

1. **Add Database Storage**
   - Store cost data in Supabase
   - Allow admin updates

2. **Integrate Real API**
   - Use Numbeo API for live data
   - Auto-update monthly

3. **Add Filtering**
   - Filter jobs by affordability score
   - Show only "Affordable" jobs

4. **Add Comparison**
   - Compare affordability across cities
   - Show salary adjustment needed

5. **Add Notifications**
   - Alert on affordable job matches
   - Cost change notifications

---

## Support

### If Something Doesn't Work

1. **Check Backend is Running**
   ```bash
   curl "http://localhost:3001/api/health"
   ```

2. **Check Cost Endpoint**
   ```bash
   curl "http://localhost:3001/api/cost-of-living/cities"
   ```

3. **Check Job Endpoint**
   ```bash
   curl "http://localhost:3001/api/jobs?limit=1"
   ```

4. **Check Logs**
   - Backend: Check terminal where `npm run dev` is running
   - Frontend: Check Flutter console

### Common Issues

**Issue**: No affordability badge showing
- **Fix**: Ensure backend is returning `affordabilityBadge` field

**Issue**: Wrong affordability score
- **Fix**: Check salary is in annual format (not monthly)

**Issue**: Cost data not found
- **Fix**: Verify city name matches exactly (case-sensitive)

---

## Documentation

For detailed information, see:
- `COST_OF_LIVING_FEATURE.md` - Complete feature documentation
- `IMPLEMENTATION_SUMMARY.md` - Technical implementation details
- API endpoint responses in this file

---

## Summary

✅ **Cost of Living feature is live!**

Users can now:
- See affordability badges on job listings
- View detailed cost breakdowns on job details
- Make informed career decisions based on salary vs expenses
- Compare affordability across 20 Indian metro cities

Developers can:
- Use API endpoints to get cost data
- Customize the feature for specific needs
- Integrate with other systems
- Extend with additional cities or categories

**Happy job hunting! 🚀**
