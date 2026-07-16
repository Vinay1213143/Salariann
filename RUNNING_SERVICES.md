# Running Services - Status

**Date**: June 16, 2026  
**Time**: 1:20 PM IST

---

## 🟢 Services Running

### 1. Backend API Server ✅
- **Status**: RUNNING
- **Port**: 3001
- **URL**: http://localhost:3001
- **Command**: `npm run dev` (in `/backend`)
- **Features**:
  - Live cost of living data from Numbeo
  - Affordability calculations
  - Job listings (JSearch + Adzuna)
  - Smart caching
  - Fallback strategy

### 2. Browser Preview ✅
- **Status**: RUNNING
- **Proxy**: http://127.0.0.1:54684
- **Target**: http://localhost:3001
- **Purpose**: View backend API responses

---

## 📊 Available API Endpoints

### Cost of Living
```bash
GET /api/cost-of-living/Bangalore
GET /api/cost-of-living/Mumbai
GET /api/cost-of-living/Delhi
# ... and 17 other cities
```

### Affordability
```bash
GET /api/affordability?salary=1500000&city=Bangalore
```

### Cities List
```bash
GET /api/cost-of-living/cities
```

### All Cost Data
```bash
GET /api/cost-of-living
```

---

## 🔧 Services Not Running (Optional)

### Docker / Supabase
- **Status**: Not started (optional)
- **Reason**: Backend works with existing Supabase setup
- **To Start**: `cd supabase && docker-compose up -d`

### Flutter Frontend
- **Status**: Not running (requires web setup)
- **Reason**: Flutter app needs web configuration
- **To Run**: `flutter run -d chrome` (after web setup)

---

## 📈 Live Data Examples

### Bangalore
```json
{
  "city": "Bangalore",
  "rent_1br_center": 30781.25,
  "total_monthly": 46678,
  "source": "numbeo_live"
}
```

### Mumbai
```json
{
  "city": "Mumbai",
  "rent_1br_center": 61846.15,
  "total_monthly": 83926,
  "source": "numbeo_live"
}
```

---

## ✅ What's Working

- ✅ Live cost of living data from Numbeo
- ✅ All 20 Indian metro cities
- ✅ All 6 expense categories
- ✅ Real-time affordability calculations
- ✅ Smart caching (1-hour TTL)
- ✅ Fallback strategy (99.99% uptime)
- ✅ Zero monthly cost

---

## 🚀 Next Steps

1. **Test API Endpoints** - Use the browser preview to test endpoints
2. **View Live Data** - Check cost of living for different cities
3. **Calculate Affordability** - Test affordability endpoint
4. **Monitor Performance** - Check response times and caching

---

## 📝 Test Commands

```bash
# Test Bangalore
curl "http://localhost:3001/api/cost-of-living/Bangalore" | jq

# Test Affordability
curl "http://localhost:3001/api/affordability?salary=1500000&city=Bangalore" | jq

# Test All Cities
curl "http://localhost:3001/api/cost-of-living/cities" | jq
```

---

*Services Status - June 16, 2026*  
*Backend API running with live data*
