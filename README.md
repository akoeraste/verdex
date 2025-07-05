# Verdex 🌱

A smart multilingual plant identification app that helps users identify plants, learn about their properties, and manage their plant collections.

## 🌟 Features

### Plant Identification
- **AI-Powered Recognition**: Uses TensorFlow Lite for offline plant identification
- **Multilingual Support**: Available in multiple languages with localized content
- **High Accuracy**: Trained on extensive plant databases for reliable identification

### User Experience
- **Offline Functionality**: Core features work without internet connection
- **Favorites System**: Save and organize your favorite plants
- **Educational Content**: Learn about plant properties, uses, and care
- **Audio Pronunciations**: Hear correct plant name pronunciations

### Technical Features
- **Cross-Platform**: Works on iOS, Android, and Web
- **Real-time Sync**: Cloud synchronization when online
- **User Authentication**: Secure login and registration system
- **Feedback System**: Report issues and suggest improvements

## 🏗️ Architecture

Verdex is built with a modern, scalable architecture:

```
Verdex/
├── backend/          # Laravel API backend
├── frontend/         # Flutter mobile & web app
└── docs/            # Documentation
```

### Backend (Laravel)
- **RESTful API**: Comprehensive API for all app features
- **Authentication**: Laravel Sanctum for secure token-based auth
- **Database**: MySQL with migrations and seeders
- **Testing**: Full test coverage with PHPUnit
- **Admin Panel**: Web-based admin interface for content management

### Frontend (Flutter)
- **Cross-Platform**: Single codebase for iOS, Android, and Web
- **State Management**: Provider pattern for app state
- **Offline Storage**: SQLite for local data persistence
- **ML Integration**: TensorFlow Lite for plant identification
- **Localization**: Multi-language support with easy_localization

## 🚀 Quick Start

### Prerequisites
- **Backend**: PHP 8.2+, MySQL 8.0+, Composer
- **Frontend**: Flutter 3.7+, Dart 3.0+
- **Development**: Git, VS Code (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/akoeraste/verdex.git
   cd verdex
   ```

2. **Setup Backend**
   ```bash
   cd backend
   composer install
   cp .env.example .env
   # Configure your database and other settings
   php artisan migrate --seed
   php artisan serve
   ```

3. **Setup Frontend**
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```

For detailed setup instructions, see:
- [Backend README](backend/README.md)
- [Frontend README](frontend/README.md)

## 📱 Screenshots

*[Add screenshots of the app here]*

## 🛠️ Development

### Running Tests
```bash
# Backend tests
cd backend
php artisan test

# Frontend tests
cd frontend
flutter test
```

### Code Style
- **Backend**: Laravel Pint for PHP code formatting
- **Frontend**: Flutter Lints for Dart code quality

### Contributing
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- **Issues**: [GitHub Issues](https://github.com/akoeraste/verdex/issues)
- **Discussions**: [GitHub Discussions](https://github.com/akoeraste/verdex/discussions)
- **Email**: support@verdex.app

## 🙏 Acknowledgments

- Plant identification model training data
- Flutter and Laravel communities
- Open source contributors

---

**Made with ❤️ by the Mr TEA** 