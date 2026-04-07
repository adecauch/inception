FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-intl \
    php-mbstring \
    php-xml \
    php-zip \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar \
    -o /usr/local/bin/wp-cli.phar \
    && chmod +x /usr/local/bin/wp-cli.phar \
    && ln -s /usr/local/bin/wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init.sh /init.sh

RUN chmod +x /init.sh \
    && mkdir -p /var/www/html/wordpress

EXPOSE 9000

ENTRYPOINT ["/init.sh"]
