#!/bin/bash

# Railway deployment script for Laravel

echo "🚀 Starting Railway deployment..."

# Install dependencies
echo "📦 Installing dependencies..."
composer install --no-dev --optimize-autoloader

# Generate application key if not exists
if [ -z "$APP_KEY" ]; then
    echo "🔑 Generating application key..."
    php artisan key:generate
fi

# Run database migrations
echo "🗄️ Running database migrations..."
php artisan migrate --force

# Clear and cache configurations
echo "⚡ Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Create storage link
echo "🔗 Creating storage link..."
php artisan storage:link

echo "✅ Deployment completed successfully!" 