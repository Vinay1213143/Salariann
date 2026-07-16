# Salariann Deployment Guide

Complete guide to deploy Salariann to production.

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    CDN / Hosting                         │
│              (Firebase, Netlify, Vercel)                 │
│                   Flutter Web App                        │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│                  API Gateway                             │
│            (Heroku, Railway, AWS)                        │
│              Node.js Express Backend                     │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│              Supabase Cloud / Self-Hosted                │
│         PostgreSQL + Auth + Storage + Realtime          │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

- Production Supabase instance (Cloud or Self-Hosted)
- Backend hosting (Heroku, Railway, AWS, DigitalOcean)
- Frontend hosting (Firebase, Netlify, Vercel)
- Domain name
- SSL certificates

## Phase 1: Supabase Deployment

### Option A: Supabase Cloud (Recommended for Production)

1. **Create Supabase Project**
   - Go to https://supabase.com
   - Click "New Project"
   - Select region (closest to your users)
   - Create project

2. **Get Credentials**
   - Project Settings → API
   - Copy `Project URL` and `anon key`
   - Copy `service_role key`

3. **Run Migrations**
   - Go to SQL Editor
   - Copy contents of `supabase/volumes/db/salariann-init.sql`
   - Paste and execute

4. **Configure Auth**
   - Authentication → Providers
   - Enable Email/Password
   - Set redirect URLs

### Option B: Self-Hosted Supabase (Docker)

1. **Prepare Server**
   ```bash
   # Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install docker.io docker-compose
   ```

2. **Deploy Docker Compose**
   ```bash
   cd supabase
   cp .env.example .env
   # Edit .env with production values
   docker compose up -d
   ```

3. **Setup SSL with Caddy**
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.caddy.yml up -d
   ```

4. **Backup Strategy**
   ```bash
   # Daily backups
   docker exec supabase-db pg_dump -U postgres postgres > backup-$(date +%Y%m%d).sql
   ```

## Phase 2: Backend Deployment

### Option A: Heroku

1. **Install Heroku CLI**
   ```bash
   npm install -g heroku
   heroku login
   ```

2. **Create Heroku App**
   ```bash
   cd backend
   heroku create salariann-api
   ```

3. **Set Environment Variables**
   ```bash
   heroku config:set SUPABASE_URL=https://your-project.supabase.co
   heroku config:set SUPABASE_ANON_KEY=your-anon-key
   heroku config:set SUPABASE_SERVICE_ROLE_KEY=your-service-key
   heroku config:set JWT_SECRET=your-jwt-secret
   heroku config:set NODE_ENV=production
   ```

4. **Deploy**
   ```bash
   git push heroku main
   ```

5. **Monitor**
   ```bash
   heroku logs --tail
   ```

### Option B: Railway

1. **Connect Repository**
   - Go to https://railway.app
   - Click "New Project"
   - Select "Deploy from GitHub"
   - Connect your repository

2. **Configure Environment**
   - Variables → Add variables
   - Set all required environment variables

3. **Deploy**
   - Railway auto-deploys on push
   - Monitor in dashboard

### Option C: AWS EC2

1. **Launch EC2 Instance**
   ```bash
   # Ubuntu 20.04 LTS
   # t3.small or larger
   # Security group: Allow ports 80, 443, 3001
   ```

2. **Setup Node.js**
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

3. **Deploy Application**
   ```bash
   git clone your-repo
   cd backend
   npm install
   npm run build  # if applicable
   ```

4. **Setup PM2 (Process Manager)**
   ```bash
   npm install -g pm2
   pm2 start src/index.js --name "salariann-api"
   pm2 startup
   pm2 save
   ```

5. **Setup Nginx Reverse Proxy**
   ```nginx
   server {
       listen 80;
       server_name api.salariann.com;

       location / {
           proxy_pass http://localhost:3001;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

6. **Setup SSL with Let's Encrypt**
   ```bash
   sudo apt-get install certbot python3-certbot-nginx
   sudo certbot --nginx -d api.salariann.com
   ```

## Phase 3: Frontend Deployment

### Option A: Firebase Hosting

1. **Install Firebase CLI**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. **Initialize Firebase**
   ```bash
   cd frontend
   firebase init hosting
   ```

3. **Build Flutter Web**
   ```bash
   flutter build web
   ```

4. **Deploy**
   ```bash
   firebase deploy
   ```

### Option B: Netlify

1. **Build Flutter Web**
   ```bash
   cd frontend
   flutter build web
   ```

2. **Deploy via CLI**
   ```bash
   npm install -g netlify-cli
   netlify deploy --prod --dir=build/web
   ```

3. **Or Connect GitHub**
   - Go to https://netlify.com
   - Click "New site from Git"
   - Select repository
   - Set build command: `flutter build web`
   - Set publish directory: `build/web`

### Option C: Vercel

1. **Build Flutter Web**
   ```bash
   flutter build web
   ```

2. **Create vercel.json**
   ```json
   {
     "buildCommand": "flutter build web",
     "outputDirectory": "build/web"
   }
   ```

3. **Deploy**
   ```bash
   npm install -g vercel
   vercel --prod
   ```

## Phase 4: Configuration & Security

### 1. Update API URLs

**Frontend** (`lib/config/api_config.dart`):
```dart
class ApiConfig {
  static const String baseUrl = 'https://api.salariann.com/api';
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-production-anon-key';
}
```

### 2. Setup CORS

**Backend** (`src/index.js`):
```javascript
app.use(cors({
  origin: ['https://salariann.com', 'https://www.salariann.com'],
  credentials: true
}));
```

### 3. Environment Variables

**Production .env:**
```
PORT=3001
NODE_ENV=production
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-production-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-production-service-key
JWT_SECRET=your-production-jwt-secret
```

### 4. Database Security

- Enable Row Level Security (RLS) on all tables
- Create appropriate policies
- Regular backups
- Monitor access logs

### 5. API Security

- Rate limiting (implement in backend)
- Input validation
- HTTPS only
- API key rotation
- CORS configuration

## Phase 5: Monitoring & Maintenance

### 1. Application Monitoring

```bash
# Backend logs
heroku logs --tail  # Heroku
pm2 logs           # Self-hosted

# Frontend errors
# Use Sentry or similar
```

### 2. Database Monitoring

- Monitor query performance
- Check connection pool usage
- Monitor storage usage
- Setup alerts

### 3. Uptime Monitoring

```bash
# Use services like:
# - UptimeRobot
# - Pingdom
# - CloudFlare
```

### 4. Performance Optimization

- Enable caching headers
- Compress responses
- Optimize database queries
- Use CDN for static assets

## Phase 6: CI/CD Pipeline

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '16'
      - run: cd backend && npm install
      - run: cd backend && npm test
      - run: git push heroku main

  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: cd frontend && flutter pub get
      - run: cd frontend && flutter build web
      - run: firebase deploy --token ${{ secrets.FIREBASE_TOKEN }}
```

## Rollback Procedure

### Backend Rollback

```bash
# Heroku
heroku releases
heroku rollback v123

# Railway
# Redeploy previous commit
git revert HEAD
git push

# Self-hosted
pm2 restart salariann-api
```

### Database Rollback

```bash
# Restore from backup
psql -U postgres postgres < backup-20240531.sql
```

## Post-Deployment Checklist

- [ ] Test all endpoints with production URLs
- [ ] Verify authentication flow
- [ ] Check suitability score calculations
- [ ] Test file uploads (if applicable)
- [ ] Verify email notifications
- [ ] Check error logging
- [ ] Monitor performance
- [ ] Setup backups
- [ ] Configure alerts
- [ ] Document deployment process
- [ ] Train team on deployment
- [ ] Setup status page

## Troubleshooting

### Backend Connection Issues

```bash
# Check Supabase connectivity
curl https://your-project.supabase.co

# Check environment variables
heroku config  # Heroku
echo $SUPABASE_URL  # Self-hosted
```

### Frontend Not Loading

```bash
# Check build output
flutter build web --verbose

# Verify API URL
# Check browser console for CORS errors
```

### Database Issues

```bash
# Check connection
psql -h host -U user -d database

# Monitor connections
SELECT * FROM pg_stat_activity;
```

## Scaling Considerations

### Horizontal Scaling

- Use load balancer (AWS ALB, Nginx)
- Multiple backend instances
- Database read replicas
- CDN for static assets

### Vertical Scaling

- Upgrade server specs
- Increase database resources
- Increase memory/CPU

### Caching Strategy

- Redis for session/cache
- CloudFlare for edge caching
- Browser caching headers

## Cost Optimization

- Use spot instances for non-critical services
- Optimize database queries
- Implement caching
- Use CDN for assets
- Monitor and clean up unused resources

## Disaster Recovery

- Regular backups (daily)
- Backup testing (monthly)
- Documented recovery procedures
- Failover setup
- RTO/RPO targets

## Support

For deployment issues:
1. Check service status pages
2. Review logs
3. Check documentation
4. Contact support teams
5. Post in community forums
