# Salariann - Quick Start Guide

**Get Salariann running in 3 simple steps!**

---

## 📋 Prerequisites

- Node.js installed
- Backend API running (or start it)
- Port 3000 and 3001 available

---

## 🚀 Step 1: Start Backend API

```bash
cd /Users/bhaveshtayade/Desktop/salariann/backend
npm run dev
```

**Expected Output:**
```
Salariann backend running on port 3001
```

**Status**: ✅ Backend running on http://localhost:3001

---

## 🎨 Step 2: Start Web Frontend

Open a new terminal:

```bash
cd /Users/bhaveshtayade/Desktop/salariann/web-frontend
npm start
```

**Expected Output:**
```
Salariann Web Frontend running on http://localhost:3000
Backend API: http://localhost:3001
```

**Status**: ✅ Frontend running on http://localhost:3000

---

## 🌐 Step 3: Open in Browser

Visit: **http://localhost:3000**

---

## ✨ What You'll See

### Header
- Salariann logo
- Navigation (Jobs, Companies, Salary, Insights)
- Sign In / Join Now buttons

### Hero Section
- "Find Your Next Opportunity" headline
- Search bar
- Gradient blue background

### Main Content
- **Sidebar**: City, salary, job type filters
- **Feed**: Job listings with:
  - Company name
  - Job title
  - Location
  - Salary
  - Affordability badge
  - Save / Apply buttons

---

## 🔍 Try These Features

### 1. Search Jobs
- Type in search bar: "Engineer", "Bangalore", "Amazon"
- Press Enter or click Search
- Results update instantly

### 2. Filter by City
- Select city from sidebar
- Jobs filter automatically
- Try: Bangalore, Mumbai, Delhi

### 3. Filter by Salary
- Enter min salary: 50 (LPA)
- Enter max salary: 100 (LPA)
- Jobs filter by salary range

### 4. Check Affordability
- Each job shows affordability badge
- Green: Affordable
- Yellow: Moderate
- Red: Tight Budget

### 5. Apply for Job
- Click "Apply Now" button
- Or click "Save" to bookmark

---

## 📊 Live Data

### Cost of Living (Real-time from Numbeo)
- Bangalore: ₹46,678/month
- Mumbai: ₹83,926/month
- Delhi: ₹42,633/month
- And 17 more cities...

### Jobs
- All companies displayed
- Real-time listings
- Salary information
- Affordability calculated

---

## 🎯 Key Features

✅ **LinkedIn-Style UI** - Professional design  
✅ **All Companies** - Every company displayed  
✅ **Live Data** - Real-time from Numbeo  
✅ **Search** - Find jobs instantly  
✅ **Filters** - City, salary, job type  
✅ **Affordability** - Color-coded badges  
✅ **Responsive** - Works on all devices  
✅ **Zero Cost** - Completely free  

---

## 🔧 Troubleshooting

### Jobs Not Loading
**Problem**: "Loading jobs..." stays on screen

**Solution**:
1. Check backend is running: `http://localhost:3001/api/jobs`
2. Check browser console for errors (F12)
3. Restart frontend server

### Filters Not Working
**Problem**: Filters don't change results

**Solution**:
1. Wait for jobs to load first
2. Check filter values are correct
3. Clear browser cache (Ctrl+Shift+Delete)

### Port Already in Use
**Problem**: "Port 3000 already in use"

**Solution**:
```bash
# Kill process using port 3000
lsof -i :3000
kill -9 <PID>

# Or use different port
PORT=3002 npm start
```

---

## 📱 Responsive Design

### Desktop (1200px+)
- Two-column layout
- Sidebar visible
- Full navigation

### Tablet (768px - 1199px)
- Adjusted spacing
- Optimized cards

### Mobile (<768px)
- Single column
- Sidebar hidden
- Touch-friendly

---

## 🎨 Customization

### Change Logo Text
Edit `web-frontend/index.html`:
```html
<a href="#" class="logo">Salariann</a>
```

### Change Colors
Edit CSS in `index.html`:
```css
--primary-color: #0a66c2;  /* Change this */
```

### Add More Cities
Edit filter in `index.html`:
```html
<option value="NewCity">New City</option>
```

---

## 📊 API Endpoints

### Get All Jobs
```bash
curl http://localhost:3001/api/jobs
```

### Get Cost of Living
```bash
curl http://localhost:3001/api/cost-of-living/Bangalore
```

### Calculate Affordability
```bash
curl "http://localhost:3001/api/affordability?salary=1500000&city=Bangalore"
```

---

## 🚀 Production Deployment

### Deploy Backend
```bash
# Build
cd backend
npm install

# Deploy to Node.js host (Heroku, Railway, etc.)
git push heroku main
```

### Deploy Frontend
```bash
# Build
cd web-frontend
npm install

# Deploy to static host (Vercel, Netlify, etc.)
npm run build
```

---

## 📚 Documentation

- **SALARIANN_COMPLETE.md** - Full platform overview
- **web-frontend/README.md** - Frontend documentation
- **LIVE_API_INTEGRATION_COMPLETE.md** - Backend API docs
- **FINAL_STATUS_REPORT.md** - Complete status report

---

## 💡 Tips

### For Best Experience
1. Use Chrome or Firefox
2. Clear cache if styles look wrong
3. Keep both servers running
4. Check console (F12) for errors

### Performance
- First load: ~2 seconds
- Search: Instant
- Filter: Instant
- API calls: 200-500ms

### Data Freshness
- Cost of living: Updated daily from Numbeo
- Jobs: Real-time from JSearch
- Affordability: Calculated in real-time

---

## ✅ Checklist

- [ ] Backend running on port 3001
- [ ] Frontend running on port 3000
- [ ] Browser showing http://localhost:3000
- [ ] Jobs loading in feed
- [ ] Search working
- [ ] Filters working
- [ ] Affordability badges showing
- [ ] Responsive on mobile

---

## 🎉 You're All Set!

**Salariann** is now running and ready to use!

### What's Next?
1. Explore job listings
2. Test search and filters
3. Check affordability analysis
4. Try on mobile
5. Share with others

---

## 📞 Need Help?

1. Check troubleshooting section above
2. Review documentation files
3. Check browser console (F12)
4. Verify both servers are running
5. Check API endpoints directly

---

## 🎯 Summary

**Salariann** is a professional job platform with:
- ✅ LinkedIn-style UI
- ✅ All companies displayed
- ✅ Live job data
- ✅ Real-time affordability
- ✅ Advanced search & filters
- ✅ Responsive design
- ✅ Zero cost

**Status**: Ready to use! 🚀

---

*Salariann Quick Start - June 16, 2026*  
*Professional Job & Salary Platform*
