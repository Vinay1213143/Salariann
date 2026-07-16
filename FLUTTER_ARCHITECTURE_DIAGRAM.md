# Salariann Flutter Architecture Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SALARIANN FLUTTER APP                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    APP SHELL (Main)                      │  │
│  │  - Responsive Navigation                                │  │
│  │  - Header with Search                                   │  │
│  │  - User Menu                                            │  │
│  │  - Right Sidebar (Desktop)                              │  │
│  └──────────────────────────────────────────────────────────┘  │
│                            │                                    │
│         ┌──────────────────┼──────────────────┐                │
│         │                  │                  │                │
│    ┌────▼────┐        ┌────▼────┐       ┌────▼────┐           │
│    │  Home   │        │Companies │       │ Profile │           │
│    │ Screen  │        │ Screen   │       │ Screen  │           │
│    └────┬────┘        └────┬────┘       └────┬────┘           │
│         │                  │                  │                │
│    ┌────▼────────────────────────────────────▼────┐           │
│    │         Notifications & Messages              │           │
│    └──────────────────────────────────────────────┘           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Screen Hierarchy

```
Landing Screen
    │
    ├─→ Login Screen
    │
    ├─→ Sign Up Screen
    │
    ├─→ Forgot Password Screen
    │
    └─→ App Shell (Main Navigation)
        │
        ├─→ Home Screen
        │   ├─→ Search Bar
        │   ├─→ Filter Panel
        │   │   ├─→ City Filter
        │   │   ├─→ Job Type Filter
        │   │   └─→ Salary Range Filter
        │   └─→ Job List
        │       └─→ Job Card (with Affordability Badge)
        │           └─→ Job Detail Screen
        │
        ├─→ Companies Screen
        │   ├─→ Search Bar
        │   └─→ Company List
        │       └─→ Company Card
        │           └─→ Company Profile Screen
        │               ├─→ Add Review
        │               ├─→ Contribute Salary
        │               └─→ Share Interview
        │
        ├─→ Notifications Screen
        │   └─→ Job Alerts
        │
        ├─→ Messaging Screen
        │   └─→ Messages
        │
        └─→ Profile Screen
            ├─→ User Profile
            ├─→ Edit Profile
            └─→ Settings
```

## Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   Screens    │  │   Widgets    │  │   Theme      │    │
│  ├──────────────┤  ├──────────────┤  ├──────────────┤    │
│  │ HomeScreen   │  │ JobCard      │  │ AppTheme     │    │
│  │ Companies    │  │ FilterPanel  │  │ Colors       │    │
│  │ Profile      │  │ AppBar       │  │ Typography   │    │
│  │ Messaging    │  │ Navigation   │  │ Spacing      │    │
│  │ Notifications│  │ Affordability│  │              │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   STATE MANAGEMENT LAYER                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ AuthProvider │  │ JobsProvider │  │ Companies    │    │
│  │              │  │              │  │ Provider     │    │
│  │ - Login      │  │ - Fetch Jobs │  │              │    │
│  │ - Signup     │  │ - Filter     │  │ - Fetch      │    │
│  │ - Logout     │  │ - Search     │  │ - Search     │    │
│  │ - Session    │  │ - Details    │  │ - Details    │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │            UserProvider                             │  │
│  │ - Profile Data                                      │  │
│  │ - Preferences                                       │  │
│  │ - Settings                                          │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    BUSINESS LOGIC LAYER                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Affordability Calculator                     │  │
│  │ - Net Income Calculation                            │  │
│  │ - Expense Comparison                                │  │
│  │ - Savings Percentage                                │  │
│  │ - Score Generation (Green/Yellow/Red)               │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Data Processing                             │  │
│  │ - Filtering Logic                                   │  │
│  │ - Search Logic                                      │  │
│  │ - Sorting Logic                                     │  │
│  │ - Caching Logic                                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    DATA ACCESS LAYER                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ HTTP Client  │  │ Supabase     │  │ Local Cache  │    │
│  │              │  │ Client       │  │              │    │
│  │ - REST API   │  │ - Auth       │  │ - Shared     │    │
│  │ - Jobs       │  │ - Database   │  │   Prefs      │    │
│  │ - Companies  │  │ - Storage    │  │ - Hive       │    │
│  │ - Salaries   │  │              │  │              │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND SERVICES                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Node.js Express Backend (Port 3001)         │  │
│  │                                                      │  │
│  │  ┌──────────────┐  ┌──────────────────────────┐    │  │
│  │  │ Job API      │  │ Company API              │    │  │
│  │  │ - GET /jobs  │  │ - GET /companies         │    │  │
│  │  │ - POST /jobs │  │ - GET /companies/:id     │    │  │
│  │  │ - Filtering  │  │ - POST /companies        │    │  │
│  │  └──────────────┘  └──────────────────────────┘    │  │
│  │                                                      │  │
│  │  ┌──────────────┐  ┌──────────────────────────┐    │  │
│  │  │ Affordability│  │ Cost of Living API       │    │  │
│  │  │ Calculator   │  │ - Numbeo Integration     │    │  │
│  │  │ - Scoring    │  │ - City Metrics           │    │  │
│  │  │ - Breakdown  │  │ - Real-time Data         │    │  │
│  │  └──────────────┘  └──────────────────────────┘    │  │
│  │                                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    DATABASE LAYER                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Supabase (PostgreSQL)                        │  │
│  │                                                      │  │
│  │  ┌──────────────┐  ┌──────────────────────────┐    │  │
│  │  │ Tables       │  │ Authentication           │    │  │
│  │  │ - users      │  │ - JWT Tokens             │    │  │
│  │  │ - jobs       │  │ - Sessions               │    │  │
│  │  │ - companies  │  │ - User Roles             │    │  │
│  │  │ - reviews    │  │                          │    │  │
│  │  │ - salaries   │  │                          │    │  │
│  │  │ - interviews │  │                          │    │  │
│  │  │ - city_      │  │                          │    │  │
│  │  │   metrics    │  │                          │    │  │
│  │  └──────────────┘  └──────────────────────────┘    │  │
│  │                                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
User Input
    │
    ├─→ Search Query
    │   └─→ JobsProvider.filterJobs()
    │       └─→ HTTP GET /api/jobs?search=query
    │           └─→ Backend Filtering
    │               └─→ Database Query
    │                   └─→ Results
    │                       └─→ UI Update
    │
    ├─→ Filter Selection
    │   └─→ JobsProvider.filterJobs()
    │       └─→ HTTP GET /api/jobs?city=X&type=Y&salary=Z
    │           └─→ Backend Filtering
    │               └─→ Database Query
    │                   └─→ Results
    │                       └─→ UI Update
    │
    └─→ Job Click
        └─→ JobDetailScreen
            └─→ HTTP GET /api/jobs/:id
                └─→ Backend Fetch
                    └─→ Database Query
                        ├─→ Job Details
                        ├─→ Company Info
                        ├─→ Affordability Calc
                        └─→ UI Display
```

## Responsive Layout Flow

```
Device Width Detection
    │
    ├─→ < 600px (Mobile)
    │   └─→ MobileLayout
    │       ├─→ AppBar
    │       ├─→ Body
    │       └─→ BottomNavigationBar
    │
    ├─→ 600-1024px (Tablet)
    │   └─→ TabletLayout
    │       ├─→ AppBar
    │       ├─→ Row
    │       │   ├─→ NavigationRail
    │       │   └─→ Body
    │       └─→ (No Bottom Nav)
    │
    └─→ > 1024px (Desktop)
        └─→ DesktopLayout
            ├─→ AppBar
            ├─→ Row
            │   ├─→ NavigationRail (Extended)
            │   ├─→ Body
            │   └─→ RightPanel
            │       ├─→ Trending
            │       └─→ Tips
            └─→ (No Bottom Nav)
```

## State Management Flow

```
Widget
    │
    ├─→ Consumer<JobsProvider>
    │   └─→ jobsProvider.filteredJobs
    │       └─→ Update UI
    │
    ├─→ Consumer<AuthProvider>
    │   └─→ authProvider.currentUser
    │       └─→ Update UI
    │
    ├─→ Consumer<CompaniesProvider>
    │   └─→ companiesProvider.filteredCompanies
    │       └─→ Update UI
    │
    └─→ Consumer<UserProvider>
        └─→ userProvider.userProfile
            └─→ Update UI

Provider Changes
    │
    └─→ notifyListeners()
        └─→ Consumer Rebuilds
            └─→ UI Updates
```

## Navigation Flow

```
GoRouter
    │
    ├─→ StatefulShellRoute
    │   └─→ AppShell
    │       ├─→ Branch 0: /home
    │       │   └─→ HomeScreen
    │       │       └─→ /home/job/:id
    │       │           └─→ JobDetailScreen
    │       │
    │       ├─→ Branch 1: /companies
    │       │   └─→ CompaniesScreen
    │       │       └─→ /companies/:id
    │       │           └─→ CompanyProfileScreen
    │       │
    │       ├─→ Branch 2: /notifications
    │       │   └─→ NotificationsScreen
    │       │
    │       ├─→ Branch 3: /messaging
    │       │   └─→ MessagingScreen
    │       │
    │       └─→ Branch 4: /profile
    │           └─→ ProfileScreen
    │               ├─→ /profile/review
    │               ├─→ /profile/salary
    │               └─→ /profile/interview
    │
    └─→ Initial Routes
        ├─→ /
        │   └─→ LandingScreen
        ├─→ /login
        │   └─→ LoginScreen
        ├─→ /signup
        │   └─→ SignUpScreen
        └─→ /forgot-password
            └─→ ForgotPasswordScreen
```

## Affordability Calculation Flow

```
Job Salary (Annual CTC)
    │
    ├─→ Calculate Net Income
    │   └─→ Annual CTC × 0.88 (12% tax/EPF)
    │       └─→ Monthly Net = Net Annual / 12
    │
    ├─→ Fetch City Metrics
    │   └─→ Database Query
    │       └─→ Rent + Grocery + Transport + Utilities
    │           └─→ Total Monthly Expenses
    │
    ├─→ Calculate Disposable Income
    │   └─→ Monthly Net - Total Expenses
    │
    ├─→ Calculate Savings Percentage
    │   └─→ (Disposable Income / Monthly Net) × 100
    │
    └─→ Generate Score
        ├─→ > 30% = GREEN (Comfortable)
        ├─→ 10-30% = YELLOW (Manageable)
        └─→ < 10% = RED (High Stress)
            └─→ Display Badge
```

## Filter Panel Flow

```
Filter Panel
    │
    ├─→ City Dropdown
    │   └─→ onCityChanged()
    │       └─→ setState() + applyFilters()
    │           └─→ JobsProvider.filterJobs()
    │
    ├─→ Job Type Dropdown
    │   └─→ onJobTypeChanged()
    │       └─→ setState() + applyFilters()
    │           └─→ JobsProvider.filterJobs()
    │
    └─→ Salary Range Slider
        └─→ onSalaryRangeChanged()
            └─→ setState() + applyFilters()
                └─→ JobsProvider.filterJobs()
                    └─→ API Call with Filters
                        └─→ Results Update
                            └─→ UI Refresh
```

---

**Architecture Version**: 1.0
**Last Updated**: June 18, 2026
**Status**: Production Ready ✅
