FROM php:7.4.8-apache as sendy

ARG SENDY_VER=6.0.3
ARG ARTIFACT_DIR=6.0.3

ARG SENDY_PROTOCOL=https
ARG SENDY_FQDN
ARG MYSQL_HOST
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE
ARG PORT

ENV SENDY_VERSION ${SENDY_VER}

RUN apt -qq update && apt -qq upgrade -y \
  # Install unzip cron
  && apt -qq install -y unzip cron  \
  # Install php extension gettext
  # Install php extension mysqli
  && docker-php-ext-install calendar gettext mysqli \
  # Remove unused packages
  && apt autoremove -y

# Copy artifacts
COPY ./artifacts/${ARTIFACT_DIR}/ /tmp

# Install Sendy
RUN unzip /tmp/sendy-${SENDY_VER}.zip -d /tmp \
  && cp -r /tmp/includes/* /tmp/sendy/includes \
  && mkdir -p /tmp/sendy/uploads/csvs \
  && chmod -R 777 /tmp/sendy/uploads \
  && rm -rf /var/www/html \
  && mv /tmp/sendy /var/www/html \
  && chown -R www-data:www-data /var/www \
  && mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
  && rm -rf /tmp/* \
  && echo "\nServerName \${SENDY_FQDN}" > /etc/apache2/conf-available/serverName.conf \
  && echo "\nListen 0.0.0.0:\${PORT}" > /etc/apache2/httpd.conf \
  && sed -i "s/^Listen\ 80/Listen\ 0.0.0.0:\${PORT}/" /etc/apache2/httpd.conf \
  && sed -i "s/^127.0.0.1/0.0.0.0/" /etc/apache2/httpd.conf \
  # Ensure X-Powered-By is always removed regardless of php.ini or other settings.
  && printf "\n\n# Ensure X-Powered-By is always removed regardless of php.ini or other settings.\n\
  Header always unset \"X-Powered-By\"\n\
  Header unset \"X-Powered-By\"\n" >> /var/www/html/.htaccess \
  && printf "[PHP]\nerror_reporting = E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED\n" > /usr/local/etc/php/conf.d/error_reporting.ini

# Apache config
RUN a2enconf serverName

# Apache modules
RUN a2enmod rewrite headers

# Copy hello-cron file to the cron.d directory
COPY cron /etc/cron.d/cron
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cron \
  # Apply cron job
  && crontab /etc/cron.d/cron \
  # Create the log file to be able to run tail
  && touch /var/log/cron.log

COPY artifacts/docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

