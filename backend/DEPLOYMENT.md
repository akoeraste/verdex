# Verdex Backend - Railway Deployment Guide

## 🚀 Quick Deploy to Railway

### Prerequisites
- Railway account
- GitHub repository with this code
- MySQL database (Railway provides this)

### Deployment Steps

1. **Connect to Railway**
   - Go to [Railway.app](https://railway.app)
   - Connect your GitHub repository
   - Select this backend directory

2. **Set Environment Variables**
   Add these variables in Railway dashboard:
   ```
   APP_NAME=Verdex
   APP_ENV=production
   APP_DEBUG=false
   APP_URL=https://your-app-name.railway.app
   APP_KEY=base64:your-generated-key
   
   DB_CONNECTION=mysql
   DB_HOST=your-railway-mysql-host
   DB_PORT=3306
   DB_DATABASE=your-database-name
   DB_USERNAME=your-database-user
   DB_PASSWORD=your-database-password
   
   FILESYSTEM_DISK=public
   LOG_LEVEL=error
   ```

3. **Generate Application Key**
   ```bash
   php artisan key:generate
   ```

4. **Database Setup**
   - Railway will automatically run migrations
   - Seeders will populate the database with plants and audio files

5. **Storage Setup**
   - The deployment script creates storage links automatically
   - For production, consider using S3 or similar for file storage

### Environment Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `APP_NAME` | Application name | Yes |
| `APP_ENV` | Environment (production) | Yes |
| `APP_KEY` | Laravel encryption key | Yes |
| `APP_URL` | Your Railway app URL | Yes |
| `DB_HOST` | Railway MySQL host | Yes |
| `DB_DATABASE` | Database name | Yes |
| `DB_USERNAME` | Database username | Yes |
| `DB_PASSWORD` | Database password | Yes |
| `FILESYSTEM_DISK` | File storage disk | Yes |

### Post-Deployment

1. **Test the API**
   - Visit `https://your-app.railway.app/api/plants/app/all`
   - Should return plant data

2. **Check Storage**
   - Ensure storage link is created
   - Test file uploads if needed

3. **Monitor Logs**
   - Check Railway logs for any errors
   - Monitor application performance

### Troubleshooting

**Common Issues:**
- Database connection errors: Check DB credentials
- Storage permission errors: Ensure proper file permissions
- 500 errors: Check Laravel logs in Railway dashboard

**Useful Commands:**
```bash
# Check application status
php artisan about

# Clear all caches
php artisan optimize:clear

# Check storage link
php artisan storage:link

# Run migrations manually
php artisan migrate --force
```

### Security Notes

- ✅ Environment variables are encrypted
- ✅ Debug mode is disabled in production
- ✅ Error logging is configured
- ✅ Database credentials are secure
- ⚠️ Consider using S3 for file storage in production
- ⚠️ Set up proper CORS for frontend integration

### Performance Optimization

- Config, routes, and views are cached
- Autoloader is optimized
- Database queries are optimized
- Static assets are served efficiently

---

**Need Help?** Check Railway documentation or Laravel deployment guides. 