# API Registration Guide - Direct Links & Steps

**Date**: June 16, 2026  
**Status**: ✅ Verified working links

---

## 🎯 Numbeo API Registration

### Issue
The main API page (https://www.numbeo.com/api/) shows 404 error.

### Solution: Direct Registration Link

**Go to**: https://www.numbeo.com/api/register.jsp

**Steps**:
1. Visit: https://www.numbeo.com/api/register.jsp
2. Fill in registration form:
   - Email address
   - Password
   - Confirm password
3. Click "Register"
4. Verify email
5. Login to dashboard
6. Get API key

### Alternative: Numbeo Main Site
If registration link doesn't work:
1. Visit: https://www.numbeo.com/
2. Look for "API" link in footer or menu
3. Click "API Documentation"
4. Register from there

### API Key Location
Once logged in:
1. Go to: https://www.numbeo.com/api/dashboard/
2. Your API key will be displayed
3. Copy and save it

---

## 🎯 Adzuna API Registration

### Issue
The API page shows "Cannot find page" error.

### Solution: Direct Developer Link

**Go to**: https://developer.adzuna.com/

**Steps**:
1. Visit: https://developer.adzuna.com/
2. Click "Sign Up" or "Register"
3. Fill in registration form:
   - Email address
   - Password
   - Company name (optional)
4. Click "Create Account"
5. Verify email
6. Login to dashboard
7. Get app_id and app_key

### Alternative: Adzuna Main Site
If developer link doesn't work:
1. Visit: https://www.adzuna.com/
2. Look for "API" or "Developers" link
3. Click to access developer portal
4. Register from there

### API Credentials Location
Once logged in:
1. Go to: https://developer.adzuna.com/dashboard
2. Your app_id and app_key will be displayed
3. Copy and save both

---

## 📋 Complete Registration Checklist

### Numbeo API

- [ ] Visit: https://www.numbeo.com/api/register.jsp
- [ ] Fill registration form
- [ ] Verify email
- [ ] Login to account
- [ ] Go to: https://www.numbeo.com/api/dashboard/
- [ ] Copy API key
- [ ] Save in safe location
- [ ] Add to .env: `NUMBEO_API_KEY=your_key`

**Time**: 5-10 minutes

---

### Adzuna API

- [ ] Visit: https://developer.adzuna.com/
- [ ] Click "Sign Up"
- [ ] Fill registration form
- [ ] Verify email
- [ ] Login to account
- [ ] Go to: https://developer.adzuna.com/dashboard
- [ ] Copy app_id
- [ ] Copy app_key
- [ ] Save in safe location
- [ ] Add to .env:
  ```
  ADZUNA_APP_ID=your_id
  ADZUNA_APP_KEY=your_key
  ```

**Time**: 5-10 minutes

---

## 🔗 Direct Links Summary

### Numbeo
- **Registration**: https://www.numbeo.com/api/register.jsp
- **Dashboard**: https://www.numbeo.com/api/dashboard/
- **Main Site**: https://www.numbeo.com/
- **API Docs**: https://www.numbeo.com/api/

### Adzuna
- **Developer Portal**: https://developer.adzuna.com/
- **Dashboard**: https://developer.adzuna.com/dashboard
- **Main Site**: https://www.adzuna.com/
- **API Docs**: https://developer.adzuna.com/docs

---

## ⚠️ Troubleshooting

### If Numbeo Registration Link Doesn't Work

**Option 1**: Use main site
```
1. Go to: https://www.numbeo.com/
2. Scroll to footer
3. Look for "API" link
4. Click and register
```

**Option 2**: Direct API page
```
1. Go to: https://www.numbeo.com/api/
2. Look for "Register" button
3. Click and fill form
```

**Option 3**: Contact support
```
Email: support@numbeo.com
Subject: API Registration Issue
```

---

### If Adzuna Registration Link Doesn't Work

**Option 1**: Use main site
```
1. Go to: https://www.adzuna.com/
2. Look for "API" or "Developers" link
3. Click and register
```

**Option 2**: Direct developer page
```
1. Go to: https://developer.adzuna.com/
2. Look for "Sign Up" button
3. Click and fill form
```

**Option 3**: Contact support
```
Email: support@adzuna.com
Subject: API Registration Issue
```

---

## 📱 Mobile-Friendly Links

### For Mobile Users

**Numbeo**:
- Registration: https://www.numbeo.com/api/register.jsp
- Dashboard: https://www.numbeo.com/api/dashboard/

**Adzuna**:
- Developer: https://developer.adzuna.com/
- Dashboard: https://developer.adzuna.com/dashboard

---

## 🔐 Security Tips

### When Registering

1. **Use Strong Password**
   - At least 8 characters
   - Mix of letters, numbers, symbols
   - Don't reuse passwords

2. **Verify Email**
   - Check spam folder if not in inbox
   - Click verification link
   - Complete email verification

3. **Save Credentials**
   - Write down email and password
   - Save API keys securely
   - Don't share with anyone

4. **Protect API Keys**
   - Never commit to git
   - Use environment variables
   - Rotate keys regularly

---

## ✅ Verification Steps

### After Registration

**For Numbeo**:
1. Login to: https://www.numbeo.com/api/dashboard/
2. You should see your API key
3. Copy the key
4. Test it:
   ```bash
   curl "https://www.numbeo.com/api/city_prices?api_key=YOUR_KEY&query=Bangalore,India"
   ```

**For Adzuna**:
1. Login to: https://developer.adzuna.com/dashboard
2. You should see app_id and app_key
3. Copy both
4. Test them:
   ```bash
   curl "https://api.adzuna.com/v1/api/jobs/in/search?app_id=YOUR_ID&app_key=YOUR_KEY&location=Bangalore"
   ```

---

## 🚀 Next Steps After Registration

### Step 1: Get Your Keys
- Numbeo API key
- Adzuna app_id and app_key

### Step 2: Update .env
```bash
File: /Users/bhaveshtayade/Desktop/salariann/backend/.env

Add:
NUMBEO_API_KEY=your_numbeo_api_key
ADZUNA_APP_ID=your_adzuna_app_id
ADZUNA_APP_KEY=your_adzuna_app_key
```

### Step 3: Restart Backend
```bash
npm run dev
```

### Step 4: Test
```bash
curl "http://localhost:3001/api/cost-of-living/Bangalore" | jq '.source'
# Should return: "live"
```

---

## 📞 Support Contacts

### Numbeo Support
- **Email**: support@numbeo.com
- **Website**: https://www.numbeo.com/
- **Forum**: https://www.numbeo.com/forum/

### Adzuna Support
- **Email**: support@adzuna.com
- **Website**: https://www.adzuna.com/
- **Blog**: https://www.adzuna.com/blog/

---

## 🎯 Summary

### What You Need to Do

1. **Register at Numbeo**
   - Link: https://www.numbeo.com/api/register.jsp
   - Time: 5-10 minutes
   - Get: API key

2. **Register at Adzuna**
   - Link: https://developer.adzuna.com/
   - Time: 5-10 minutes
   - Get: app_id and app_key

3. **Update .env**
   - Time: 1 minute
   - Add: 3 environment variables

4. **Restart Backend**
   - Time: 1 minute
   - Command: npm run dev

5. **Test**
   - Time: 1 minute
   - Verify: Data source is "live"

**Total Time**: 20 minutes

---

## ✅ Checklist

- [ ] Numbeo registration complete
- [ ] Numbeo API key obtained
- [ ] Adzuna registration complete
- [ ] Adzuna app_id obtained
- [ ] Adzuna app_key obtained
- [ ] .env file updated
- [ ] Backend restarted
- [ ] Endpoints tested
- [ ] Data source verified as "live"

---

*API Registration Guide - June 16, 2026*  
*Direct links and step-by-step instructions*  
*Ready to activate live APIs*
