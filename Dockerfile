# Use PHP FPM image as the base
FROM php:8.2-fpm

# Install required system dependencies for PHP and Nginx
RUN apt-get update && apt-get install -y \
    nginx \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring zip exif pcntl bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the Nginx configuration file
COPY docker_files/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy the project files to the container
COPY . /var/www

# Set the working directory
WORKDIR /var/www

# Set permissions for the project files
RUN chown -R www-data:www-data /var/www

# Install the project dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Expose the necessary ports (Nginx: 80, PHP-FPM: 9000)
EXPOSE 80
EXPOSE 9000

# Define environment variables (optional)
ENV NAME hotel-management-php

# Start Nginx and PHP-FPM when the container runs
CMD ["sh", "-c", "service nginx start && php-fpm"]