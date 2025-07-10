# Railway Laravel Deployment - Fixed Configuration

## ✅ Changes Implemented

### 1. **Production-Grade Server Setup**
- ✅ Replaced `artisan serve` with nginx + php-fpm
- ✅ Added supervisor to manage both processes
- ✅ Proper port exposure (8080, Railway injects $PORT)
- ✅ Production-ready Dockerfile

### 2. **Environment Variables Fixed**
- ✅ `LOG_CHANNEL=errorlog` (for cloud logging)
- ✅ `APP_ENV=production`
- ✅ Railway database variables configured
- ✅ All required variables in `.env.example`

### 3. **Health Check Route**
- ✅ `/health` route returns JSON 200
- ✅ `/` route also returns JSON 200
- ✅ Proper error handling

### 4. **Build Configuration**
- ✅ Using Dockerfile builder (not Nixpacks)
- ✅ Removed custom start commands
- ✅ Proper file permissions set

## 🚀 Railway Dashboard Configuration

### **Environment Variables (Set in Railway Dashboard)**
```
APP_NAME=Verdex
APP_ENV=production
APP_KEY=base64:YOUR_GENERATED_KEY_HERE
APP_DEBUG=false
APP_URL=https://your-app-name.railway.app

LOG_CHANNEL=errorlog
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=error

# Railway provides these automatically:
DB_CONNECTION=mysql
DB_HOST=${MYSQLHOST}
DB_PORT=${MYSQLPORT}
DB_DATABASE=${MYSQLDATABASE}
DB_USERNAME=${MYSQLUSER}
DB_PASSWORD=${MYSQLPASSWORD}

CACHE_DRIVER=file
SESSION_DRIVER=cookie
QUEUE_CONNECTION=sync
FILESYSTEM_DISK=public
```

### **Build Command (Set in Railway Dashboard)**
```
php artisan optimize && php artisan migrate --force
```

### **Health Check Path (Set in Railway Dashboard)**
```
/health
```

## 📋 Deployment Steps

### 1. **Generate APP_KEY**
```bash
# Run locally to generate key
php artisan key:generate --show
# Copy the output and paste in Railway APP_KEY variable
```

### 2. **Railway Dashboard Setup**
1. Go to Railway Dashboard
2. Select your service
3. Go to "Variables" tab
4. Add all environment variables listed above
5. Go to "Settings" tab
6. Set Build Command: `php artisan optimize && php artisan migrate --force`
7. Set Health Check Path: `/health`

### 3. **Add MySQL Service**
1. In Railway dashboard, click "New Service"
2. Select "Database" → "MySQL"
3. Railway will automatically link it to your app

### 4. **Deploy**
1. Push your code to GitHub
2. Railway will automatically detect the Dockerfile
3. Build will run with the specified build command
4. Health checks will use `/health` endpoint

## 🔍 Testing Your Deployment

### **Health Check Test**
```bash
curl https://your-app.railway.app/health
```
**Expected Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-07-08T12:00:00.000000Z",
  "environment": "production",
  "version": "1.0.0",
  "message": "Health check passed"
}
```

### **Root Endpoint Test**
```bash
curl https://your-app.railway.app/
```
**Expected Response:**
```json
{
  "status": "healthy",
  "message": "Verdex Backend is running",
  "timestamp": "2024-07-08T12:00:00.000000Z",
  "environment": "production",
  "version": "1.0.0"
}
```

## 📊 Expected Logs

### **Successful Health Check Log**
```
[nginx] 2024/07/08 12:00:00 [notice] 1#1: start worker processes
[php-fpm] [08-Jul-2024 12:00:01] NOTICE: fpm is running, pid 1
[php-fpm] [08-Jul-2024 12:00:01] NOTICE: ready to handle connections
[nginx] 2024/07/08 12:00:02 [info] 1#1: *1 "GET /health HTTP/1.1" 200
[app] Health check passed: {"status":"healthy","timestamp":"2024-07-08T12:00:02.000000Z","environment":"production","version":"1.0.0","message":"Health check passed"}
```

## 🛠️ Troubleshooting

### **If Health Check Still Fails**
1. Check Railway logs for nginx/php-fpm errors
2. Verify environment variables are set correctly
3. Ensure APP_KEY is generated and set
4. Check if MySQL service is properly linked

### **If Build Fails**
1. Check if all environment variables are set
2. Verify database connection variables
3. Check Railway logs for specific error messages

### **If App Won't Start**
1. Check supervisor logs in Railway dashboard
2. Verify nginx and php-fpm are running
3. Check file permissions on storage and bootstrap/cache

## ✅ Success Checklist

- [ ] All environment variables set in Railway dashboard
- [ ] Build command configured: `php artisan optimize && php artisan migrate --force`
- [ ] Health check path set: `/health`
- [ ] MySQL service added and linked
- [ ] APP_KEY generated and set
- [ ] Code pushed to GitHub
- [ ] Railway deployment successful
- [ ] Health check returns 200 OK
- [ ] Root endpoint returns JSON response

## 🎯 Why These Changes Work

1. **nginx + php-fpm**: Production-grade, recommended by Laravel and Railway
2. **LOG_CHANNEL=errorlog**: Ensures logs go to stdout/stderr for Railway
3. **Dockerfile builder**: More reliable than Nixpacks for Laravel
4. **Supervisor**: Manages both nginx and php-fpm processes
5. **Proper port exposure**: nginx listens on 8080, Railway injects $PORT
6. **Build command**: Ensures config is cached and DB is migrated
7. **Health check route**: Simple JSON response, no complex logic

This configuration follows Railway's best practices and should resolve the health check failures. 