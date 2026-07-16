# Salariann - IT Job Market Platform for India

A comprehensive IT job market platform for India with built-in Cost-of-Living (CoL) and Salary Suitability calculator, heavily inspired by AmbitionBox.

## Project Structure

```
salariann/
├── backend/               # Node.js Express API with suitability score engine
└── frontend/              # Flutter Material 3 responsive application
```

**Database**: Supabase Cloud (PostgreSql)

## Tech Stack

- **Frontend:** Flutter (Material 3, Responsive LayoutBuilder)
- **Backend:** Node.js + Express
- **Database & Auth:** Supabase Cloud (Managed PostgreSQL)
- **State Management:** Provider (Flutter)
- **Routing:** GoRouter (Flutter)

## Core Features

### 1. Job Aggregation & Redirection
- Display IT jobs with location, salary, and role
- Click "Apply" redirects to company's ATS
- Backend logs engagement metrics

### 2. Company Insights (AmbitionBox Clone)
- Company profiles with employee count
- User-generated reviews (work-life balance, skill development)
- Anonymous salary contribution data by role
- Interview questions and experience ratings

### 3. Salariann Suitability Score (Core USP)
Determines if a job's salary is survivable in the city:

**Formula:**
1. Net Monthly = (Annual CTC / 12) × 0.88
2. Total Expenses = Rent + Food + Commute + Utilities (from city_metrics)
3. Disposable Income = Net Monthly - Total Expenses
4. Savings % = (Disposable Income / Net Monthly) × 100
5. Score:
   - **GREEN:** Savings > 30% (Comfortable)
   - **YELLOW:** Savings 10-30% (Manageable)
   - **RED:** Savings < 10% (High financial stress)

## Getting Started

### Prerequisites
- Node.js 16+
- Flutter 3.0+

### 1. Setup Backend

```bash
cd backend
npm install
# .env is already configured with Supabase Cloud credentials
npm start
```

Backend runs on `http://localhost:3001`

### 2. Setup Flutter Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome  # For web
# or flutter run for mobile/desktop
```

## Database Schema

### Core Tables
- `users` - User profiles with lifestyle preferences
- `companies` - Company information
- `jobs` - Job listings with salary ranges
- `reviews` - User-generated company reviews
- `salaries` - Anonymous salary contributions
- `interviews` - Interview experiences and questions
- `city_metrics` - Baseline cost-of-living data by city
- `click_events` - ATS redirect engagement tracking

## API Endpoints

### Jobs
- `GET /api/jobs` - List jobs with filters (city, role)
- `GET /api/jobs/:id` - Job details with suitability score
- `POST /api/jobs` - Create job (admin)
- `POST /api/jobs/click` - Log ATS click

### Companies
- `GET /api/companies` - List companies
- `GET /api/companies/:id` - Company profile with stats
- `POST /api/companies` - Create company (admin)

### Reviews
- `GET /api/companies/:company_id/reviews` - Company reviews
- `POST /api/reviews` - Submit review (auth required)
- `PUT /api/reviews/:id` - Update review (auth required)

### Salaries
- `GET /api/companies/:company_id/salaries` - Salary data
- `POST /api/salaries` - Submit salary (auth required)
- `GET /api/salaries/stats` - Salary statistics

### Interviews
- `GET /api/companies/:company_id/interviews` - Interview experiences
- `POST /api/interviews` - Submit interview (auth required)
- `PUT /api/interviews/:id` - Update interview (auth required)

## Flutter Responsive Layout

The app uses `LayoutBuilder` with three breakpoints:

- **Mobile (< 600px):** Single column + BottomNavigationBar
- **Tablet (600-1024px):** NavigationRail + Main content
- **Desktop (> 1024px):** NavigationRail + Main content + Right panel

## Screens

### Auth & Onboarding
- Landing/Home Page
- Login, Sign Up, Forgot Password

### Core Job Engine
- Job Dashboard (filterable, responsive)
- Job Detail (with suitability score breakdown)

### Company Insights
- Company Directory (searchable)
- Company Profile (tabbed: Overview, Jobs, Reviews, Salaries, Interviews)

### User Contributions
- Add Review
- Contribute Salary
- Share Interview Experience

### User Management
- Profile/Settings (lifestyle modifier)

## Environment Variables

### Backend (.env)
```
PORT=3001
NODE_ENV=development
SUPABASE_URL=http://localhost:8000
SUPABASE_ANON_KEY=<your-key>
SUPABASE_SERVICE_ROLE_KEY=<your-key>
JWT_SECRET=<your-secret>
```

### Supabase (.env)
See `supabase/.env.example` for full configuration

## Development

### Run Backend in Dev Mode
```bash
cd backend
npm run dev
```

### Run Flutter in Dev Mode
```bash
cd frontend
flutter run -d chrome
```

### Database Migrations
SQL migrations are automatically applied on Supabase startup via `volumes/db/salariann-init.sql`

## Deployment

### Database
- Using Supabase Cloud (https://ayvwifmobthpievoyzsx.supabase.co)
- Managed PostgreSQL with automatic backups

### Backend
- Deploy to Heroku, Railway, or any Node.js host
- Update `SUPABASE_URL` to production instance

### Flutter
- Build for web: `flutter build web`
- Build for mobile: `flutter build apk` or `flutter build ios`
- Deploy to Firebase Hosting, Netlify, or your CDN

## Key Features Implementation

### Suitability Score Calculation
Located in `backend/src/utils/suitabilityScore.js`:
- Fetches city metrics from database
- Calculates net income after tax/EPF
- Compares against baseline expenses
- Returns traffic light score with breakdown

### Responsive UI
Located in `frontend/lib/widgets/responsive_scaffold.dart`:
- Uses `LayoutBuilder` for dynamic layout
- Adapts navigation based on screen size
- Maintains consistent UX across devices

### State Management
- `AuthProvider` - Supabase authentication
- `JobsProvider` - Job listing and filtering
- `CompaniesProvider` - Company data
- `UserProvider` - User profile management

## Future Enhancements

- Advanced filtering (tech stack, company size, experience level)
- Job alerts and saved jobs
- User recommendations based on preferences
- Company comparison tool
- Salary negotiation guides
- Interview preparation resources
- Mobile app optimization
- Analytics dashboard for companies

## License

MIT

## Support

For issues or questions, please open an issue on the repository.
