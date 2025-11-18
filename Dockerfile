# Dockerfile sécurisé pour Dolibarr avec Nginx et PHP-FPM
FROM php:8.1-fpm-alpine

# Installation des dépendances système
RUN apk update && apk --no-cache add nginx supervisor bash libpng-dev libjpeg-turbo-dev libwebp-dev freetype-dev icu-dev libxml2-dev mariadb-client libzip-dev

# Installation des extensions PHP nécessaires
RUN docker-php-ext-install pdo pdo_mysql gd intl xml zip

# Création d'un utilisateur non-root et du dossier /run/nginx
RUN addgroup -S dolibarr && adduser -S dolibarr -G dolibarr && mkdir -p /run/nginx

# Copie du code Dolibarr
COPY . /var/www/html
RUN chown -R dolibarr:dolibarr /var/www/html

# Copie de la configuration Nginx et Supervisor
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisord.conf

# Exposition du port web
EXPOSE 80


# Commande de démarrage
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]