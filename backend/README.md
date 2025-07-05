# Verdex Backend API

A Laravel 11 backend API for the Verdex plant identification application.

## 🌱 Features

- **Plant Management**: CRUD operations for plants with multi-language support
- **Authentication**: Laravel Sanctum API authentication
- **File Management**: Image and audio file handling for plants
- **Multi-language**: Support for English, French, Pidgin, and more
- **Role-based Access**: Admin and user permissions
- **Activity Logging**: Comprehensive audit trails
- **API Documentation**: Auto-generated API docs

## 🚀 Quick Start

### Prerequisites
- PHP 8.2+
- Composer
- MySQL 8.0+
- Node.js (for frontend assets)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd backend
   ```

2. **Install dependencies**
   ```bash
   composer install
   npm install
   ```

3. **Environment setup**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Database setup**
   ```bash
   php artisan migrate
   php artisan db:seed
   ```

5. **Storage setup**
   ```bash
   php artisan storage:link
   ```

6. **Start development server**
   ```bash
   php artisan serve
   ```

## 📚 API Documentation

Visit `/docs` for auto-generated API documentation.

## 🌍 Multi-language Support

The API supports multiple languages:
- English (en)
- French (fr)
- Pidgin (pg)
- Spanish (es)
- Bengali (bn)
- Portuguese (pt-BR)
- Chinese (zh-CN)

## 🔐 Authentication

Uses Laravel Sanctum for API token authentication.

## 📁 File Storage

- Images: `/storage/plants/{plant_name}/images/`
- Audio: `/storage/plants/{plant_name}/audio/`
- Public access via `/storage/` URL

## 🚀 Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for Railway deployment instructions.

## 📝 License

MIT License

