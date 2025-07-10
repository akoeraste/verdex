# Railway Deployment Guide for Verdex Backend

## Prerequisites

1. **Railway Account**: Sign up at [railway.app](https://railway.app)
2. **GitHub Repository**: Your code should be in a GitHub repository
3. **Database**: Railway MySQL or PostgreSQL service

## Step-by-Step Deployment

### 1. Connect Your Repository

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your repository
4. Choose the `backend` directory as the root

### 2. Environment Variables Setup

Add these environment variables in Railway dashboard:

```bash
# App Configuration
APP_NAME=Verdex
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-app-name.railway.app

# Database Configuration (Railway will provide these)
DB_CONNECTION=mysql
DB_HOST=${MYSQLHOST}
DB_PORT=${MYSQLPORT}
DB_DATABASE=${MYSQLDATABASE}
DB_USERNAME=${MYSQLUSER}
DB_PASSWORD=${MYSQLPASSWORD}

# Cache and Session
CACHE_DRIVER=file
SESSION_DRIVER=cookie
QUEUE_CONNECTION=sync

# CORS Settings
CORS_ALLOWED_ORIGINS=https://your-frontend-url.com,https://your-frontend-app.railway.app

# Mail Configuration (optional)
MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="Verdex"
```

### 3. Database Setup

1. **Add MySQL Service**:
   - In Railway dashboard, click "New Service" → "Database" → "MySQL"
   - Railway will automatically link the database to your app

2. **Database Variables** (automatically provided by Railway):
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLDATABASE`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`

### 4. Deploy

1. Railway will automatically detect the Laravel project
2. The build process will:
   - Install dependencies with `composer install --no-dev --optimize-autoloader`
   - Run database migrations
   - Cache configurations
   - Create storage links

### 5. Post-Deployment Setup

After deployment, you may need to:

1. **Run Seeders** (if needed):
   ```bash
   php artisan db:seed --force
   ```

2. **Set up Storage**:
   ```bash
   php artisan storage:link
   ```

3. **Clear Caches** (if needed):
   ```bash
   php artisan config:clear
   php artisan route:clear
   php artisan view:clear
   ```

## Configuration Files

### railway.json
- Configures the build and deployment process
- Sets up health checks and restart policies

### Procfile
- Defines how to start the application
- Uses `php artisan serve` with proper host and port

### .env.example
- Template for environment variables
- Includes Railway-specific configurations

## Troubleshooting

### Common Issues

1. **Database Connection Failed**:
   - Check if MySQL service is properly linked
   - Verify database environment variables

2. **500 Internal Server Error**:
   - Check application logs in Railway dashboard
   - Ensure `APP_KEY` is set
   - Verify all required environment variables

3. **CORS Issues**:
   - Update `CORS_ALLOWED_ORIGINS` with your frontend URL
   - Check if frontend is making requests to the correct backend URL

4. **Storage Issues**:
   - Ensure `php artisan storage:link` runs during deployment
   - Check file permissions

### Logs and Monitoring

1. **View Logs**: Go to your service in Railway dashboard → "Deployments" → "View Logs"
2. **Monitor Performance**: Use Railway's built-in monitoring
3. **Health Checks**: Railway will automatically check `/` endpoint

## Security Considerations

1. **Environment Variables**: Never commit sensitive data to Git
2. **HTTPS**: Railway automatically provides SSL certificates
3. **CORS**: Configure allowed origins properly
4. **Database**: Use Railway's managed database service

## Performance Optimization

1. **Caching**: Laravel configurations are cached automatically
2. **Database**: Use Railway's optimized database service
3. **CDN**: Consider using a CDN for static assets
4. **Monitoring**: Use Railway's performance monitoring

## Support

- **Railway Documentation**: [docs.railway.app](https://docs.railway.app)
- **Laravel Documentation**: [laravel.com/docs](https://laravel.com/docs)
- **Community**: Railway Discord and Laravel Forums 