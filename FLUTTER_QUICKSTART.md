# Flutter Clean UI - Quick Start Guide

## Prerequisites
- Flutter 3.0+ installed
- Dart SDK 3.0+
- Backend API running on port 3001
- Modern web browser or mobile emulator

## Setup

### 1. Install Dependencies
```bash
cd frontend
flutter pub get
```

### 2. Configure API
Edit `lib/config/api_config.dart` with your backend URL:
```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:3001';
  static const String supabaseUrl = 'http://localhost:8000';
  static const String supabaseAnonKey = 'your-key';
}
```

### 3. Run the App

**For Web:**
```bash
flutter run -d chrome
```

**For Mobile (iOS):**
```bash
flutter run -d ios
```

**For Mobile (Android):**
```bash
flutter run -d android
```

**For Desktop (Windows):**
```bash
flutter run -d windows
```

**For Desktop (macOS):**
```bash
flutter run -d macos
```

## Access the App

- **Web**: http://localhost:5000
- **Mobile**: Emulator or physical device
- **Desktop**: Native window

## Main Features

### 1. Home Screen
- **Search**: Find jobs by keyword
- **Filters**: City, job type, salary range
- **Job Cards**: View job details with affordability
- **Easy Apply**: Apply directly to jobs

### 2. Companies Screen
- **Search**: Find companies
- **Browse**: View company details
- **Jobs**: See all jobs from a company
- **Profile**: View full company profile

### 3. Navigation
- **Home**: Job discovery
- **Companies**: Company directory
- **Notifications**: Job alerts
- **Messages**: Messaging system
- **Profile**: User profile and settings

## Responsive Layouts

### Mobile
- Bottom navigation bar
- Single column layout
- Touch-optimized buttons

### Tablet
- Left navigation rail
- Two-column layout
- Balanced spacing

### Desktop
- Extended navigation rail
- Three-column layout
- Right sidebar with trending

## Testing Features

### 1. Job Search
1. Go to Home tab
2. Type in search box
3. See filtered results

### 2. City Filtering
1. Click city dropdown
2. Select a city
3. Jobs update automatically

### 3. Salary Range
1. Click salary range
2. Adjust min/max sliders
3. See filtered results

### 4. Company Search
1. Go to Companies tab
2. Type company name
3. View company details

### 5. Affordability
1. View job cards
2. Check affordability badge (Green/Yellow/Red)
3. Click for detailed breakdown

## Troubleshooting

### App Won't Start
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### API Connection Error
- Ensure backend is running on port 3001
- Check `api_config.dart` settings
- Verify network connectivity

### Widgets Not Updating
- Check Provider listeners
- Verify `notifyListeners()` calls
- Clear app cache: `flutter clean`

### Navigation Issues
- Verify routes in `router.dart`
- Check GoRouter configuration
- Clear navigation stack

### Affordability Badge Missing
- Ensure backend suitability score is working
- Check API response format
- Verify city metrics in database

## Development Tips

### Hot Reload
```bash
# In Flutter console
r - Hot reload
R - Hot restart
q - Quit
```

### Debug Mode
```bash
flutter run -d chrome --debug
```

### Release Mode
```bash
flutter run -d chrome --release
```

### View Logs
```bash
flutter logs
```

## File Locations

**New Screens:**
- `lib/screens/home/home_screen.dart`
- `lib/screens/companies/companies_screen.dart`
- `lib/screens/shell/app_shell.dart`

**New Widgets:**
- `lib/widgets/filter_panel.dart`

**Updated Files:**
- `lib/config/router.dart`

**Existing Widgets:**
- `lib/widgets/job_card.dart`
- `lib/widgets/affordability_badge.dart`
- `lib/widgets/responsive_scaffold.dart`

## Key Shortcuts

| Action | Shortcut |
|--------|----------|
| Hot Reload | `r` |
| Hot Restart | `R` |
| Quit | `q` |
| Open DevTools | `d` |
| Screenshot | `s` |
| Toggle Debug Info | `i` |

## Performance Tips

1. **Use const constructors** where possible
2. **Implement shouldRebuild** in providers
3. **Use ListView.builder** for long lists
4. **Cache API responses** for 1 hour
5. **Lazy load images** and content

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

## Common Commands

```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Run tests
flutter test

# Build web
flutter build web

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Clean project
flutter clean

# Format code
dart format lib/

# Analyze code
dart analyze
```

## Environment Variables

Create `.env` file in `frontend/`:
```
API_BASE_URL=http://localhost:3001
SUPABASE_URL=http://localhost:8000
SUPABASE_ANON_KEY=your-key
```

## Support

- **Flutter Docs**: https://flutter.dev/docs
- **Provider Package**: https://pub.dev/packages/provider
- **GoRouter**: https://pub.dev/packages/go_router
- **Material Design 3**: https://m3.material.io/

## Next Steps

1. ✅ Run the app
2. ✅ Test all features
3. ✅ Check responsiveness
4. ✅ Verify affordability calculations
5. ✅ Test navigation
6. ✅ Deploy to your platform

---

**Quick Start Complete!** 🚀

Your Salariann Flutter app is ready to use. Start exploring jobs and companies!
