FROM php:7.4-apache

# Instala extensiones necesarias
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Habilita mod_rewrite de Apache
RUN a2enmod rewrite

# Copia el código fuente al contenedor
COPY . /var/www/html/

# Dale permisos apropiados
RUN chown -R www-data:www-data /var/www/html

# Expone el puerto 80
EXPOSE 80
