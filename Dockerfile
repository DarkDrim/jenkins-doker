FROM alpine:3.16

# Setup apache and php
RUN apk --no-cache --update \
    add apache2 \
    php8-apache2 \
    php8-phar \
    tzdata \
    && rm /var/www/localhost/htdocs/index.html

COPY src/index.php /var/www/localhost/htdocs

ENV TZ=Europe/Kiev
EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]
