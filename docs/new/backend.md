# Verdex Backend Documentation (Laravel)

## Overview
The Verdex backend is a Laravel 10.x RESTful API that powers the Verdex mobile and admin applications. It manages users, plants, feedback, notifications, and more.

## Features
- RESTful API for all app features
- User authentication (Sanctum)
- Role & permission management
- Plant CRUD and search
- Feedback system with admin responses
- Notification system (database & email)
- Activity logging
- Multi-language support
- File/image upload
- Caching and performance optimizations

## Project Structure
```
app/
  Console/           # Artisan commands
  Exceptions/        # Error handling
  Http/
    Controllers/     # API controllers
    Middleware/      # Request middleware
    Requests/        # Form validation
    Resources/       # API resources
  Mail/              # Email notifications
  Models/            # Eloquent models
  Notifications/     # Notification classes
  Providers/         # Service providers
config/              # App configuration
routes/              # API and web routes
resources/           # Views, assets
public/              # Public files
storage/             # File storage
lang/                # Localization
migrations/          # Database migrations
seeders/             # Database seeders
```

## Main Modules/Services
- **User Management**: Registration, login, profile, roles, permissions
- **Plant Management**: CRUD, categories, translations
- **Feedback System**: User feedback, admin responses
- **Notification System**: Database/email notifications
- **Activity Logging**: User/system actions
- **File Storage**: Image/file upload
- **Localization**: Multi-language support

## Database Schema
- `users`, `plants`, `categories`, `plant_translations`, `feedback`, `notifications`, `activity_logs`, `roles`, `permissions`, `favorites`
- See `database/migrations/` for details

## Authentication & Authorization
- Uses **Laravel Sanctum** for API token auth
- Role-based and permission-based access (Spatie package)
- Policies for resource access

## API Structure
- All API routes in `routes/api.php`
- RESTful endpoints for all resources
- Auth endpoints: `/login`, `/register`, `/logout`
- Feedback: `/feedback`, `/feedback/{id}/respond`
- Notifications: `/notifications`, `/notifications/{id}/read`, etc.
- See `app/Http/Controllers/Api/`

## Notifications & Feedback
- Users receive notifications when admins respond to feedback
- Notifications stored in DB and sent via email
- Users can view, mark as read, and delete notifications

## Caching & Performance
- Uses Redis for cache (if configured)
- Query/result caching for performance
- File and image caching
- Queue support for notifications/emails

## Testing
- Feature and unit tests in `tests/`
- Run tests: `php artisan test`

## Deployment
- Configure `.env` for production
- Run `php artisan migrate --seed`
- Set up web server (Nginx/Apache)
- Use supervisor for queue workers
- Set up storage symlink: `php artisan storage:link`

## Contribution Guidelines
- Fork and branch for features/bugfixes
- Follow PSR-12 coding standards
- Write tests for new features
- Submit pull requests for review

## Troubleshooting
- Check `.env` for DB and mail config
- Run `php artisan config:cache` after changes
- Check logs in `storage/logs/`
- For queue issues: check worker status

## Future Improvements
- Real-time broadcasting (WebSockets)
- Advanced analytics
- Microservices support
- More third-party integrations 