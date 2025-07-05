#!/bin/bash

# Railway deployment script for Verdex Backend

echo "🚀 Starting Verdex Backend deployment..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
sleep 10

# Run database migrations
echo "🗄️ Running database migrations..."
php artisan migrate --force

# Run database seeders
echo "🌱 Running database seeders..."
php artisan db:seed --force

# Clear and cache configurations
echo "⚡ Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Create storage link
echo "🔗 Creating storage link..."
php artisan storage:link

# Set proper permissions
echo "🔐 Setting permissions..."
chmod -R 775 storage bootstrap/cache

echo "✅ Deployment completed successfully!" 