FROM php:8.1.12-fpm

RUN apt-get update && apt-get install -y \
    apache2 \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /app
COPY composer.json .

RUN composer install --no-scripts
COPY . .

COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf
EXPOSE 8080
CMD php artisan optimize;php artisan migrate:fresh --seed;php artisan serve --host=0.0.0.0 --port 8080


# # Copy composer.lock and composer.json
# COPY composer.lock composer.json /var/www/

# # Set working directory
# WORKDIR /var/www



# # Clear cache
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# EXPOSE 8080
# COPY --from=build /app /var/www/
# COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf
# COPY .env.example /var/www/.env
# RUN chmod 777 -R /var/www/storage/ && \
#     echo "Listen 8080" >> /etc/apache2/ports.conf && \
#     chown -R www-data:www-data /var/www/ && \
#     a2enmod rewrite

# # Install extensions
# RUN docker-php-ext-install pdo_mysql
# # RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
# RUN docker-php-ext-install gd

# # Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # Add user for laravel application
# RUN groupadd -g 1000 www
# RUN useradd -u 1000 -ms /bin/bash -g www www

# # Copy existing application directory contents
# COPY . /var/www
# COPY docker/000-default.conf /etc/apache2/sites-available/000-default.conf

# # Copy existing application directory permissions
# COPY --chown=www:www . /var/www

# RUN chown -R $USER:$USER /var/www

# # Change current user to www
# USER www

# # Expose port 9001 and start php-fpm server
# EXPOSE 8080
# CMD ["php-fpm"]