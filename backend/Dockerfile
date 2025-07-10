FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www

# Install dependencies (skip problematic scripts)
RUN composer install --no-dev --optimize-autoloader --no-scripts
RUN composer dump-autoload --optimize

# Generate key if not exists
RUN php artisan key:generate --no-interaction || true

# Cache configurations
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Create storage link
RUN php artisan storage:link

# Change current user to www
USER www-data

# Expose port 8000
EXPOSE 8000

# Start server
CMD php artisan serve --host=0.0.0.0 --port=8000 