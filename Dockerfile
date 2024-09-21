# Author: Allan Rodrigues
# Email: allan.rodrigues14@hotmail.com

# Build arguments
FROM php:8.3-fpm

# Directory app - Padrão NGINX
WORKDIR /var/www

# Atualiza a lista de pacotes e instala apt-utils
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    supervisor \
    zlib1g-dev \
    libzip-dev \
    unzip \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    nginx \
    curl

# Instala a última versão do Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala as extensões do PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql pdo_pgsql pgsql session xml zip iconv simplexml pcntl gd fileinfo

# Instala o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia as configurações do Supervisor
COPY ./docker/supervisord/supervisord.conf /etc/supervisor
COPY ./docker/supervisord/conf /etc/supervisord.d/

# Carrega a configuração padrão do NGINX
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Limpa arquivos temporários
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Comando para iniciar o Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
