# Use PHP-FPM base image
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y nginx unzip libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring zip exif pcntl bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /var/www

# Copy project files into the container
COPY . /var/www

# Set permissions
RUN chown -R www-data:www-data /var/www

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install project dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Copy default Nginx configuration
COPY docker_files/nginx/default.conf /etc/nginx/conf.d/default.conf

# Expose necessary ports
EXPOSE 9000 80

# Start Nginx and PHP-FPM when the container starts
CMD service nginx start && php-fpm