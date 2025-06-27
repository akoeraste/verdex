# Verdex Frontend Documentation (Flutter)

## Overview
Verdex's frontend is a cross-platform Flutter application for iOS, Android, and Web. It provides plant identification, plant library, user feedback, notifications, and more.

## Features
- Plant identification via camera/gallery
- Plant library browsing and search
- User authentication and profile management
- Feedback submission and notification
- Multi-language support
- Offline data caching
- Push notifications
- Favorites management

## Project Structure
```
lib/
  constants/         # API config and constants
  models/            # Data models
  providers/         # State management (Provider)
  screens/           # Main app screens (Home, Identify, Settings, etc.)
  services/          # API, Auth, Notification, Language, etc.
  utils/             # Utility functions
  widgets/           # Reusable UI components
assets/
  images/            # App images
  translations/      # Localization files (en.json, fr.json, etc.)
```

## Main Screens & Navigation
- **HomeScreen**: Dashboard, plant highlights
- **IdentifyScreen**: Plant identification via camera/gallery
- **PlantDetailScreen**: Plant info, images, uses
- **FavoritesScreen**: User's favorite plants
- **FeedbackScreen**: Submit feedback
- **NotificationsScreen**: View notifications
- **SettingsScreen**: Profile, preferences, language, theme
- **Login/Register**: Authentication
- **About/Privacy/Terms**: Info pages

Navigation is managed via `Navigator` and custom bottom navigation bar.

## State Management
- Uses **Provider** for app-wide state (auth, language, favorites, etc.)
- Local state via `StatefulWidget` where appropriate

## API Integration
- Uses `http` package for REST API calls
- All endpoints are defined in `constants/api_config.dart`
- Authenticated requests use Bearer tokens
- Error handling and loading states are managed in each screen/service

## Caching & Offline Support
- Uses `SharedPreferences` for local storage
- Caches plant data, favorites, and user info for offline use
- Handles network errors gracefully

## Localization
- Uses `easy_localization` package
- Translation files in `assets/translations/`
- Supports English, French, Spanish, Bengali, and more

## Notifications
- In-app notification center (`NotificationsScreen`)
- Fetches notifications from backend via API
- Supports marking as read, deleting, and clearing all
- (Optional) Integrate with Firebase Cloud Messaging for push

## How to Build and Run
1. Install Flutter SDK (3.x recommended)
2. Run `flutter pub get`
3. For Android: `flutter run -d android`
4. For iOS: `flutter run -d ios`
5. For Web: `flutter run -d chrome`
6. To build release: `flutter build apk` / `flutter build ios` / `flutter build web`

## Testing
- Widget tests in `test/`
- Run all tests: `flutter test`

## Contribution Guidelines
- Fork the repo and create a feature branch
- Follow Dart/Flutter best practices
- Write clear commit messages
- Add/Update tests for new features
- Submit a pull request for review

## Troubleshooting
- If dependencies fail: run `flutter pub get --verbose`
- For iOS issues: run `pod install` in `ios/`
- For Android: check emulator/device connection
- For localization: ensure `easy_localization` is initialized

## Future Improvements
- Real-time sync with backend (WebSockets)
- Advanced offline mode
- More languages
- Enhanced accessibility
- Deep linking and sharing
- In-app tutorials 