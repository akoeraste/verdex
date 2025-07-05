# Verdex Frontend 📱

Cross-platform Flutter application for plant identification, featuring offline functionality, multi-language support, and AI-powered plant recognition.

## 🌟 Features

### Core Functionality
- **Plant Identification**: AI-powered plant recognition using TensorFlow Lite
- **Offline Support**: Core features work without internet connection
- **Multi-language**: Support for English, French, Spanish, and more
- **Favorites System**: Save and organize your favorite plants
- **Educational Content**: Learn about plant properties and uses

### User Experience
- **Intuitive UI**: Modern, accessible interface design
- **Audio Pronunciations**: Hear correct plant name pronunciations
- **Image Capture**: Take photos for plant identification
- **Search & Filter**: Find plants by name, category, or characteristics
- **Dark/Light Mode**: Theme support for user preference

### Technical Features
- **Cross-Platform**: iOS, Android, and Web support
- **State Management**: Provider pattern for app state
- **Local Storage**: SQLite database for offline data
- **Real-time Sync**: Cloud synchronization when online
- **Push Notifications**: User engagement features

## 🏗️ Architecture

### Technology Stack
- **Framework**: Flutter 3.7+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Local Database**: SQLite (sqflite)
- **Networking**: HTTP/Dio for API communication
- **ML Integration**: TensorFlow Lite
- **Localization**: easy_localization
- **Storage**: Shared Preferences & Secure Storage

### Project Structure
```
frontend/
├── lib/
│   ├── constants/           # App constants and configuration
│   ├── models/              # Data models
│   ├── providers/           # State management providers
│   ├── screens/             # UI screens and pages
│   ├── services/            # Business logic and API services
│   ├── utils/               # Utility functions and helpers
│   ├── widgets/             # Reusable UI components
│   └── main.dart            # App entry point
├── assets/
│   ├── images/              # App images and icons
│   ├── model/               # ML model files
│   └── translations/        # Localization files
├── test/                    # Unit and widget tests
└── pubspec.yaml            # Dependencies and configuration
```

## 📋 Prerequisites

- **Flutter**: 3.7.0 or higher
- **Dart**: 3.0.0 or higher
- **Android Studio** / **VS Code**: IDE with Flutter support
- **Android SDK**: For Android development
- **Xcode**: For iOS development (macOS only)
- **Git**: Version control

## 🚀 Installation

### 1. Clone and Setup
```bash
cd frontend
flutter pub get
```

### 2. Environment Configuration
Create `lib/constants/api_config.dart` with your backend API URL:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api';
  // or your production API URL
  // static const String baseUrl = 'https://your-api.com/api';
}
```

### 3. Run the App
```bash
# For development
flutter run

# For specific platform
flutter run -d chrome    # Web
flutter run -d android   # Android
flutter run -d ios       # iOS
```

## 📱 App Structure

### Main Screens
- **Home**: Plant identification and discovery
- **Search**: Find plants by name or characteristics
- **Favorites**: Saved plant collection
- **Profile**: User account and settings
- **About**: App information and help

### Key Components
- **PlantCard**: Reusable plant display component
- **BottomNavBar**: Navigation between main sections
- **CustomAppBar**: Consistent app header
- **EducationalSnippet**: Plant information display
- **ImagePicker**: Camera and gallery integration

## 🔧 Development

### State Management
The app uses Provider pattern for state management:

```dart
// Example provider
class PlantProvider extends ChangeNotifier {
  List<Plant> _plants = [];
  
  List<Plant> get plants => _plants;
  
  Future<void> fetchPlants() async {
    // API call logic
    notifyListeners();
  }
}
```

### API Integration
```dart
// Example service
class PlantService {
  final Dio _dio = Dio();
  
  Future<List<Plant>> getPlants() async {
    final response = await _dio.get('$baseUrl/plants');
    return (response.data['data'] as List)
        .map((json) => Plant.fromJson(json))
        .toList();
  }
}
```

### Local Storage
```dart
// SQLite database operations
class DatabaseHelper {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
```

## 🧪 Testing

### Running Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Specific test file
flutter test test/widget_test.dart
```

### Test Structure
- **Unit Tests**: Business logic and utility functions
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end app flow testing
- **Mock Tests**: API and service mocking

## 🌍 Localization

### Adding New Languages
1. Create translation file in `assets/translations/`
2. Add language to `lib/main.dart`
3. Update language selection in settings

### Translation Structure
```json
{
  "app_name": "Verdex",
  "home": {
    "title": "Plant Identification",
    "scan_button": "Scan Plant"
  }
}
```

## 🤖 Machine Learning Integration

### TensorFlow Lite Setup
- Model file: `assets/model/plant_classifier_mobile.tflite`
- Input: 224x224 pixel images
- Output: Plant classification probabilities

### Usage Example
```dart
class PlantClassifierService {
  late Interpreter _interpreter;
  
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model/plant_classifier_mobile.tflite');
  }
  
  Future<List<double>> classifyImage(File imageFile) async {
    // Image preprocessing and classification logic
  }
}
```

## 📦 Building for Production

### Android
```bash
# Generate APK
flutter build apk --release

# Generate App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

### Web
```bash
# Build for web
flutter build web --release
```

## 🔐 Security

### Data Protection
- **Secure Storage**: Sensitive data encrypted
- **API Security**: Token-based authentication
- **Input Validation**: Client-side validation
- **Network Security**: HTTPS enforcement

### Permissions
- **Camera**: Plant photo capture
- **Storage**: Save images and data
- **Internet**: API communication
- **Location**: Optional location-based features

## 🚀 Performance Optimization

### Best Practices
- **Image Caching**: Cached network images
- **Lazy Loading**: Load data on demand
- **Memory Management**: Proper disposal of resources
- **Code Splitting**: Optimize bundle size

### Monitoring
- **Performance Profiling**: Flutter DevTools
- **Memory Leaks**: Memory leak detection
- **Network Monitoring**: API call optimization

## 🐛 Debugging

### Development Tools
```bash
# Flutter Doctor
flutter doctor

# Hot Reload
flutter run --hot

# Debug Mode
flutter run --debug
```

### Common Issues
- **Platform-specific**: Check platform compatibility
- **Dependencies**: Verify pubspec.yaml
- **Build Issues**: Clean and rebuild
- **API Issues**: Check network connectivity

## 📊 Analytics and Monitoring

### Integration
- **Crash Reporting**: Automatic error tracking
- **User Analytics**: Usage pattern analysis
- **Performance Monitoring**: App performance metrics
- **A/B Testing**: Feature testing framework

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Run all tests
5. Submit pull request

### Code Style
- **Dart Format**: `dart format .`
- **Lint Rules**: Follow `analysis_options.yaml`
- **Documentation**: Add comments for complex logic
- **Testing**: Maintain test coverage

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

- **Documentation**: Check this README and inline comments
- **Issues**: Report bugs on GitHub
- **Discussions**: Join community discussions
- **Email**: support@verdex.app

---

**Frontend Team** - Building beautiful experiences for plant lovers 🌱
