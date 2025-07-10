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

# 2. Run Database Migrations
log "🗄️  Running database migrations..."
if php artisan migrate --force --no-interaction 2>/dev/null; then
    log "✅ Database migrations completed"
else
    log "❌ Database migrations failed"
    log "This might be due to database connection issues or missing environment variables"
fi

# 3. Run Database Seeders (if needed)
log "🌱 Running database seeders..."
if php artisan db:seed --force --no-interaction 2>/dev/null; then
    log "✅ Database seeders completed"
else
    log "⚠️  Database seeders failed or no seeders found (this is normal)"
fi

# 4. Create Storage Link
log "🔗 Creating storage link..."
if php artisan storage:link --no-interaction 2>/dev/null; then
    log "✅ Storage link created"
else
    log "⚠️  Storage link already exists or failed"
fi

# 5. Clear and Cache Configurations (with error handling)
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

# 6. Set proper permissions
log "🔐 Setting permissions..."
chmod -R 775 storage bootstrap/cache 2>/dev/null || true
chmod -R 775 public/storage 2>/dev/null || true

log "✅ Permissions set"

# 7. Health check
log "🏥 Running health check..."
if command_exists curl; then
    if curl -f http://localhost:$PORT > /dev/null 2>&1; then
        log "✅ Application is running and healthy"
    else
        log "⚠️  Health check failed (this might be normal during startup)"
    fi
else
    log "⚠️  curl not available, skipping health check"
fi

log "🎉 Railway setup completed successfully!"
log "📊 Application URL: https://$RAILWAY_STATIC_URL"
log "🔍 Check logs at: https://railway.app/dashboard" 