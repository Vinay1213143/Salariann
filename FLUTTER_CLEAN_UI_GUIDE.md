# Salariann Flutter Clean UI Guide

## Overview
This document describes the new clean Material 3 Flutter UI that combines both web frontend features and native Flutter capabilities for Salariann.

## Architecture

### 1. App Shell (`app_shell.dart`)
The main navigation container that adapts to different screen sizes:

**Features:**
- **Mobile Layout**: Bottom navigation bar with 5 tabs
- **Tablet Layout**: Left navigation rail + main content
- **Desktop Layout**: Left navigation rail + main content + right sidebar
- Professional header with search functionality
- User menu with profile and logout options

**Navigation Tabs:**
1. **Home** - Job discovery and search
2. **Companies** - Company directory and profiles
3. **Notifications** - Job alerts and updates
4. **Messages** - Messaging system
5. **Profile** - User profile and settings

### 2. Home Screen (`home_screen.dart`)
Main job discovery interface with:

**Components:**
- **Search Header**: Gradient background with search input
- **Filter Panel**: City, job type, and salary range filters
- **Job List**: Scrollable list of job cards with affordability badges

**Features:**
- Real-time search filtering
- Multi-criteria filtering
- Responsive job card layout
- Empty state handling

### 3. Companies Screen (`companies_screen.dart`)
Company directory with:

**Features:**
- Company search functionality
- Company cards with:
  - Company logo/avatar
  - Company name and employee count
  - Description preview
  - View Profile and View Jobs buttons
- Responsive grid layout

### 4. Filter Panel (`filter_panel.dart`)
Advanced filtering widget with:

**Filters:**
- **City Selection**: Dropdown with 20 Indian cities
- **Job Type**: Full-time, Contract, Part-time, Internship
- **Salary Range**: Dual slider for min/max salary

**Supported Cities:**
Bangalore, Mumbai, Delhi, Hyderabad, Pune, Chennai, Kolkata, Noida, Gurgaon, Ahmedabad, Jaipur, Chandigarh, Kochi, Indore, Lucknow, Coimbatore, Thiruvananthapuram, Nagpur, Visakhapatnam, Bhubaneswar

### 5. Job Card (`job_card.dart`)
Individual job listing component with:

**Information Displayed:**
- Company name and logo
- Job title
- Location
- Salary range
- Job description
- Tags/skills
- Posted date
- Applicant count
- **Affordability Badge** (Green/Yellow/Red)
- Save button
- Easy Apply button

### 6. Affordability Features
Integrated affordability analysis:

**Components:**
- `affordability_badge.dart` - Color-coded status badge
- `affordability_breakdown.dart` - Detailed cost breakdown
- `cost_of_living_card.dart` - City cost data display
- `suitability_badge.dart` - Salary suitability indicator

**Scoring System:**
- **GREEN**: >30% savings (Comfortable)
- **YELLOW**: 10-30% savings (Manageable)
- **RED**: <10% savings (High financial stress)

## Responsive Design

### Breakpoints
- **Mobile**: < 600px width
- **Tablet**: 600px - 1024px width
- **Desktop**: > 1024px width

### Layout Adaptations

**Mobile:**
- Single column layout
- Bottom navigation bar
- Full-width components
- Touch-optimized spacing

**Tablet:**
- Left navigation rail
- Main content area
- Two-column layout
- Optimized for landscape

**Desktop:**
- Left navigation rail (extended)
- Main content (2 columns)
- Right sidebar with trending/tips
- Three-column layout

## State Management

### Providers Used
1. **AuthProvider** - Authentication and user session
2. **JobsProvider** - Job listing, filtering, and search
3. **CompaniesProvider** - Company data and search
4. **UserProvider** - User profile and preferences

### Provider Pattern
```dart
Consumer<JobsProvider>(
  builder: (context, jobsProvider, _) {
    // Access provider data and methods
  },
)
```

## Color Scheme

**Primary Colors:**
- Primary Blue: `Colors.blue.shade700` (#1976D2)
- Dark Blue: `Colors.blue.shade600` (#1565C0)
- Light Blue: `Colors.blue.shade100` (#BBDEFB)

**Status Colors:**
- Green (Affordable): `Colors.green.shade600`
- Orange (Moderate): `Colors.orange.shade600`
- Red (Tight): `Colors.red.shade600`

**Neutral Colors:**
- Text: `Colors.black87`
- Secondary Text: `Colors.grey.shade600`
- Borders: `Colors.grey.shade300`
- Background: `Colors.white`

## Typography

**Headline Styles:**
- `headlineLarge` - Page titles (24sp, bold)
- `titleLarge` - Section titles (20sp, bold)
- `titleMedium` - Card titles (16sp, medium)

**Body Styles:**
- `bodyLarge` - Descriptions (16sp)
- `bodyMedium` - Regular text (14sp)
- `bodySmall` - Secondary text (12sp)

## Navigation Flow

```
Landing Screen
    ↓
Login/Signup
    ↓
App Shell (Main Navigation)
    ├── Home (Job Discovery)
    │   └── Job Detail
    ├── Companies (Directory)
    │   └── Company Profile
    │       ├── Add Review
    │       ├── Contribute Salary
    │       └── Share Interview
    ├── Notifications
    ├── Messages
    └── Profile
        ├── Edit Profile
        └── Settings
```

## Key Features

### 1. Job Discovery
- Real-time search across job titles, companies, roles
- Advanced filtering by location, salary, job type
- Affordability analysis for each job
- Easy apply functionality

### 2. Company Insights
- Comprehensive company profiles
- Employee count and description
- Job listings per company
- User reviews and ratings
- Salary data by role
- Interview experiences

### 3. User Contributions
- Submit company reviews
- Contribute salary data
- Share interview experiences
- Anonymous submissions

### 4. Responsive Experience
- Seamless adaptation across devices
- Touch-optimized for mobile
- Efficient use of screen space on desktop
- Consistent navigation patterns

## Implementation Details

### File Structure
```
frontend/lib/
├── screens/
│   ├── home/
│   │   └── home_screen.dart
│   ├── companies/
│   │   ├── companies_screen.dart
│   │   ├── company_directory_screen.dart
│   │   └── company_profile_screen.dart
│   ├── shell/
│   │   └── app_shell.dart
│   ├── profile/
│   ├── messaging/
│   ├── notifications/
│   └── auth/
├── widgets/
│   ├── job_card.dart
│   ├── filter_panel.dart
│   ├── responsive_scaffold.dart
│   ├── affordability_badge.dart
│   ├── affordability_breakdown.dart
│   ├── cost_of_living_card.dart
│   └── suitability_badge.dart
├── providers/
│   ├── jobs_provider.dart
│   ├── companies_provider.dart
│   ├── auth_provider.dart
│   └── user_provider.dart
├── config/
│   ├── router.dart
│   └── api_config.dart
└── main.dart
```

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  go_router: ^13.0.0
  http: ^1.1.0
  supabase_flutter: ^1.10.0
  google_fonts: ^6.0.0
  url_launcher: ^6.1.0
  intl: ^0.19.0
```

## Getting Started

### 1. Setup Flutter
```bash
flutter pub get
```

### 2. Run the App
```bash
# For web
flutter run -d chrome

# For mobile
flutter run

# For desktop
flutter run -d windows
```

### 3. Access the App
- Web: http://localhost:5000
- Mobile: Emulator or physical device
- Desktop: Native window

## Customization

### Changing Colors
Edit `lib/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF0a66c2);
static const Color accentColor = Color(0xFF2e7d32);
```

### Adding New Screens
1. Create screen file in `lib/screens/`
2. Add route in `lib/config/router.dart`
3. Add navigation in `app_shell.dart`

### Modifying Filters
Edit `lib/widgets/filter_panel.dart`:
```dart
static const List<String> cities = [
  // Add/remove cities here
];
```

## Performance Optimization

### Implemented Strategies
- Lazy loading of job lists
- Provider-based state management
- Efficient widget rebuilds
- Image caching
- API response caching

### Best Practices
- Use `const` constructors where possible
- Implement `shouldRebuild` in providers
- Use `SingleChildScrollView` for overflow handling
- Optimize list rendering with `ListView.builder`

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widgets/
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Deployment

### Web Deployment
```bash
flutter build web
# Deploy to Firebase Hosting, Netlify, or your CDN
```

### Mobile Deployment
```bash
# iOS
flutter build ios

# Android
flutter build apk
flutter build appbundle
```

### Desktop Deployment
```bash
# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
```

## Troubleshooting

### Common Issues

**Issue**: App crashes on startup
- **Solution**: Run `flutter clean && flutter pub get`

**Issue**: Widgets not updating
- **Solution**: Check provider listeners and `notifyListeners()` calls

**Issue**: Navigation not working
- **Solution**: Verify routes in `router.dart` and check GoRouter configuration

**Issue**: Affordability badge not showing
- **Solution**: Ensure `suitability_score.js` is running on backend

## Future Enhancements

- [ ] Dark mode support
- [ ] Offline job caching
- [ ] Push notifications
- [ ] Job alerts
- [ ] Saved jobs
- [ ] Advanced analytics
- [ ] Video interviews
- [ ] Salary negotiation tools
- [ ] Career path recommendations
- [ ] Skill assessments

## Support & Documentation

- **Flutter Docs**: https://flutter.dev/docs
- **Provider Package**: https://pub.dev/packages/provider
- **GoRouter**: https://pub.dev/packages/go_router
- **Material Design 3**: https://m3.material.io/

---

**Last Updated**: June 18, 2026
**Status**: Production Ready ✅
