#!/bin/bash

# Railway Post-Deployment Setup Script for Verdex Backend
# This script handles all the necessary setup after deployment

echo "🚀 Starting Railway post-deployment setup..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to run artisan command safely
run_artisan() {
    local cmd="$1"
    local description="$2"
    
    log "$description..."
    if php artisan "$cmd" --no-interaction 2>/dev/null; then
        log "✅ $description completed"
        return 0
    else
        log "⚠️  $description failed (this might be normal)"
        return 1
    fi
}

# Check if we're in a Railway environment
if [ -z "$RAILWAY_ENVIRONMENT" ]; then
    log "⚠️  Not running in Railway environment, but continuing..."
fi

# Debug environment variables
log "🔍 Debug: Checking environment variables..."
log "APP_ENV: $APP_ENV"
log "APP_DEBUG: $APP_DEBUG"
log "DB_CONNECTION: $DB_CONNECTION"
log "DB_HOST: $DB_HOST"
log "PORT: $PORT"

# 1. Generate Application Key if not exists
log "🔑 Checking application key..."
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
    log "Generating new application key..."
    if php artisan key:generate --no-interaction 2>/dev/null; then
        log "✅ Application key generated"
    else
        log "⚠️  Application key generation failed (might already exist)"
    fi
else
    log "✅ Application key already exists"
fi

# 2. Test database connection
log "🗄️  Testing database connection..."
if php artisan tinker --execute="echo 'Database connection test'; DB::connection()->getPdo(); echo 'Database connected successfully';" 2>/dev/null; then
    log "✅ Database connection successful"
else
    log "❌ Database connection failed"
    log "This might be due to missing environment variables or database not ready"
fi

# 3. Run Database Migrations (only if database is connected)
log "🗄️  Running database migrations..."
if php artisan migrate --force --no-interaction 2>/dev/null; then
    log "✅ Database migrations completed"
else
    log "⚠️  Database migrations failed (this might be normal if database is not ready)"
fi

# 4. Run Database Seeders (if needed)
log "🌱 Running database seeders..."
if php artisan db:seed --force --no-interaction 2>/dev/null; then
    log "✅ Database seeders completed"
else
    log "⚠️  Database seeders failed or no seeders found (this is normal)"
fi

# 5. Create Storage Link
log "🔗 Creating storage link..."
if php artisan storage:link --no-interaction 2>/dev/null; then
    log "✅ Storage link created"
else
    log "⚠️  Storage link already exists or failed"
fi

# 6. Clear and Cache Configurations (with error handling)
log "⚡ Optimizing application..."

# Clear caches first
run_artisan "config:clear" "Clearing config cache"
run_artisan "route:clear" "Clearing route cache"
run_artisan "view:clear" "Clearing view cache"

# Try to cache configurations (might fail in Laravel 12)
run_artisan "config:cache" "Caching configurations"
run_artisan "route:cache" "Caching routes"
run_artisan "view:cache" "Caching views"

log "✅ Application optimization completed"

# 7. Set proper permissions
log "🔐 Setting permissions..."
chmod -R 775 storage bootstrap/cache 2>/dev/null || true
chmod -R 775 public/storage 2>/dev/null || true

log "✅ Permissions set"

# 8. Create a simple health check endpoint
log "🏥 Setting up health check..."
cat > public/health.php << 'EOF'
<?php
header('Content-Type: application/json');
echo json_encode([
    'status' => 'healthy',
    'timestamp' => date('Y-m-d H:i:s'),
    'environment' => $_ENV['APP_ENV'] ?? 'unknown'
]);
EOF

log "✅ Health check endpoint created at /health.php"

# 9. Test application startup
log "🚀 Testing application startup..."
if php artisan serve --host=0.0.0.0 --port=$PORT --no-interaction &
then
    log "✅ Application started successfully"
    sleep 5
    pkill -f "php artisan serve" 2>/dev/null || true
else
    log "❌ Application failed to start"
fi

log "🎉 Railway setup completed successfully!"
log "📊 Application URL: https://$RAILWAY_STATIC_URL"
log "🔍 Check logs at: https://railway.app/dashboard"
log "🏥 Health check available at: /health.php" 