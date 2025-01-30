# Use PHP FPM image as the base
FROM php:8.2-fpm

# Set DEBIAN_FRONTEND to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring zip exif pcntl bcmath \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . /var/www
WORKDIR /var/www
RUN chown -R www-data:www-data /var/www

# Install dependencies
RUN composer install --no-dev --optimize-autoloader || cat /var/www/composer.log

# Expose ports
EXPOSE 80 9000

# Start services
CMD ["sh", "-c", "nginx -g 'daemon off;' & php-fpm"]