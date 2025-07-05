# Verdex Backend 🚀

Laravel-based RESTful API backend for the Verdex plant identification app. Provides authentication, plant management, user data synchronization, and admin functionality.

## 🏗️ Architecture

### Technology Stack
- **Framework**: Laravel 11.x
- **Database**: MySQL 8.0+
- **Authentication**: Laravel Sanctum
- **Testing**: PHPUnit
- **API Documentation**: Laravel Request Docs
- **Activity Logging**: Spatie Activity Log
- **Permissions**: Spatie Laravel Permission
- **Media Management**: Spatie Media Library

### Key Features
- **RESTful API**: Complete CRUD operations for all entities
- **Multi-language Support**: Plant translations in multiple languages
- **File Management**: Image and audio file uploads with organized storage
- **User Management**: Registration, authentication, and profile management
- **Admin Panel**: Web-based admin interface for content management
- **Data Synchronization**: Offline-first sync capabilities
- **Comprehensive Testing**: 52 passing tests with full coverage

## 📋 Prerequisites

- **PHP**: 8.2 or higher
- **Composer**: Latest version
- **MySQL**: 8.0 or higher
- **Node.js**: 18+ (for frontend assets)
- **Extensions**: BCMath, Ctype, JSON, Mbstring, OpenSSL, PDO, Tokenizer, XML

## 🚀 Installation

### 1. Clone and Setup
```bash
cd backend
composer install
cp .env.example .env
```

### 2. Environment Configuration
Edit `.env` file with your database and app settings:

```env
APP_NAME=Verdex
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=verdex
DB_USERNAME=root
DB_PASSWORD=your_password

FILESYSTEM_DISK=public
```

### 3. Generate Application Key
```bash
php artisan key:generate
```

### 4. Database Setup
```bash
php artisan migrate
php artisan db:seed
```

### 5. Storage Setup
```bash
php artisan storage:link
```

### 6. Start Development Server
```bash
php artisan serve
```

The API will be available at `http://localhost:8000`

## 📚 API Documentation

### Authentication Endpoints
- `POST /api/register` - User registration
- `POST /api/login` - User login
- `POST /api/logout` - User logout
- `POST /api/forget-password` - Password reset request
- `POST /api/reset-password` - Password reset

### Plant Endpoints
- `GET /api/plants` - Get all plants (paginated)
- `GET /api/plants/{id}` - Get single plant
- `POST /api/plants` - Create new plant
- `PUT /api/plants/{id}` - Update plant
- `DELETE /api/plants/{id}` - Delete plant
- `GET /api/plants/app/all` - Get all plants for mobile app
- `GET /api/plants/app/search` - Search plants for mobile app

### User Management
- `GET /api/user` - Get current user profile
- `PUT /api/user` - Update user profile
- `POST /api/change-password` - Change password

### Favorites
- `GET /api/favorites` - Get user favorites
- `POST /api/favorites` - Add plant to favorites
- `DELETE /api/favorites/{plant_id}` - Remove from favorites
- `GET /api/favorites/{plant_id}` - Check if plant is favorited

### Feedback
- `POST /api/feedback` - Submit feedback
- `GET /api/feedback` - Get all feedback (admin)
- `GET /api/feedback/{id}` - Get single feedback (admin)
- `PUT /api/feedback/{id}/respond` - Respond to feedback (admin)

### Admin Endpoints
- `GET /api/users` - User management
- `GET /api/roles` - Role management
- `GET /api/permissions` - Permission management
- `GET /api/activity-logs` - Activity logging
- `GET /api/backup/download` - Database backup

## 🗄️ Database Schema

### Core Tables
- **users** - User accounts and profiles
- **plants** - Plant information and metadata
- **plant_categories** - Plant classification categories
- **plant_translations** - Multi-language plant content
- **languages** - Supported languages
- **favorites** - User favorite plants
- **feedback** - User feedback and support tickets

### Admin Tables
- **roles** - User roles and permissions
- **permissions** - System permissions
- **activity_logs** - User activity tracking
- **browser_sessions** - User session management

## 🧪 Testing

### Running Tests
```bash
# Run all tests
php artisan test

# Run specific test file
php artisan test tests/Feature/PlantControllerTest.php

# Run with coverage (requires Xdebug)
php artisan test --coverage
```

### Test Structure
- **Unit Tests**: Model relationships, methods, and business logic
- **Feature Tests**: API endpoints and integration testing
- **Test Coverage**: 52 tests covering all major functionality

### Test Data
- **Factories**: Comprehensive factories for all models
- **Seeders**: Sample data for development and testing
- **Database**: In-memory SQLite for testing

## 🔧 Development

### Code Style
```bash
# Format PHP code
./vendor/bin/pint

# Check code style
./vendor/bin/pint --test
```

### Database Migrations
```bash
# Create new migration
php artisan make:migration create_new_table

# Run migrations
php artisan migrate

# Rollback migrations
php artisan migrate:rollback
```

### Model Creation
```bash
# Create model with migration and factory
php artisan make:model ModelName -mf

# Create model with controller
php artisan make:model ModelName -c

# Create API resource
php artisan make:resource ModelNameResource
```

### API Development
```bash
# Create controller
php artisan make:controller Api/ControllerName

# Create form request
php artisan make:request StoreModelNameRequest

# Create API resource
php artisan make:resource ModelNameResource
```

## 📁 Project Structure

```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/    # API controllers
│   │   ├── Requests/           # Form validation
│   │   └── Resources/          # API resources
│   ├── Models/                 # Eloquent models
│   └── Services/               # Business logic
├── database/
│   ├── factories/              # Model factories
│   ├── migrations/             # Database migrations
│   └── seeders/                # Database seeders
├── routes/
│   └── api.php                 # API routes
├── tests/
│   ├── Feature/                # Feature tests
│   └── Unit/                   # Unit tests
└── storage/
    └── app/public/             # Public file storage
```

## 🔐 Security

### Authentication
- **Laravel Sanctum**: Token-based authentication
- **CSRF Protection**: Built-in CSRF protection
- **Rate Limiting**: API rate limiting for abuse prevention
- **Input Validation**: Comprehensive request validation

### File Upload Security
- **File Type Validation**: Only allowed file types
- **Size Limits**: Configurable file size limits
- **Virus Scanning**: Optional virus scanning for uploads
- **Secure Storage**: Files stored outside web root

## 🚀 Deployment

### Production Setup
1. Set `APP_ENV=production` in `.env`
2. Configure production database
3. Set up file storage (AWS S3 recommended)
4. Configure caching (Redis recommended)
5. Set up SSL certificates

### Environment Variables
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_HOST=your-db-host
DB_DATABASE=your-db-name
DB_USERNAME=your-db-user
DB_PASSWORD=your-db-password

FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-bucket
```

### Performance Optimization
```bash
# Cache configuration
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Optimize autoloader
composer install --optimize-autoloader --no-dev
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

**Backend Team** - Building robust APIs for plant lovers 🌱

