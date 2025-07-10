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
   - Install dependencies with `composer install --no-dev --optimize-autoloader --no-scripts`
   - Run the automated setup script (`railway-setup.sh`)
   - Generate application key (if needed)
   - Run database migrations
   - Run database seeders
   - Create storage links
   - Cache configurations
   - Set proper permissions

### 5. Automated Setup

The `railway-setup.sh` script automatically handles:

✅ **Application Key Generation** - Creates APP_KEY if not exists  
✅ **Database Migrations** - Runs all pending migrations  
✅ **Database Seeders** - Populates initial data  
✅ **Storage Links** - Creates public storage symlink  
✅ **Configuration Caching** - Optimizes Laravel configs  
✅ **Permissions** - Sets proper file permissions  
✅ **Health Check** - Verifies application is running  

### 6. Manual Commands (if needed)

If you need to run commands manually after deployment:

```bash
# Generate application key
php artisan key:generate

# Run migrations
php artisan migrate --force

# Run seeders
php artisan db:seed --force

# Create storage link
php artisan storage:link

# Clear caches
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Cache configurations
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## Configuration Files

### railway.json
- Configures the build and deployment process
- Sets up health checks and restart policies

### nixpacks.toml
- Defines build phases and dependencies
- Includes automated setup script execution

### Dockerfile
- Alternative deployment method
- Includes all necessary setup steps

### railway-setup.sh
- Automated post-deployment setup script
- Handles all initialization tasks

## Troubleshooting

### Common Issues

1. **Database Connection Failed**:
   - Check if MySQL service is properly linked
   - Verify database environment variables
   - Ensure migrations are compatible

2. **500 Internal Server Error**:
   - Check application logs in Railway dashboard
   - Ensure `APP_KEY` is set
   - Verify all required environment variables

3. **CORS Issues**:
   - Update `CORS_ALLOWED_ORIGINS` with your frontend URL
   - Check if frontend is making requests to the correct backend URL

4. **Storage Issues**:
   - The setup script automatically creates storage links
   - Check file permissions if issues persist

5. **Migration Errors**:
   - Check database connection
   - Verify migration files are compatible
   - Check database user permissions

### Logs and Monitoring

1. **View Logs**: Go to your service in Railway dashboard → "Deployments" → "View Logs"
2. **Monitor Performance**: Use Railway's built-in monitoring
3. **Health Checks**: Railway will automatically check `/` endpoint
4. **Setup Script Logs**: Check the output of `railway-setup.sh` in deployment logs

## Security Considerations

1. **Environment Variables**: Never commit sensitive data to Git
2. **HTTPS**: Railway automatically provides SSL certificates
3. **CORS**: Configure allowed origins properly
4. **Database**: Use Railway's managed database service
5. **Permissions**: Setup script sets proper file permissions

## Performance Optimization

1. **Caching**: Laravel configurations are cached automatically
2. **Database**: Use Railway's optimized database service
3. **CDN**: Consider using a CDN for static assets
4. **Monitoring**: Use Railway's performance monitoring
5. **Autoloader**: Optimized composer autoloader

## Support

- **Railway Documentation**: [docs.railway.app](https://docs.railway.app)
- **Laravel Documentation**: [laravel.com/docs](https://laravel.com/docs)
- **Community**: Railway Discord and Laravel Forums
- **Setup Script**: Check `railway-setup.sh` for detailed setup process 