FROM ubuntu:14.04
MAINTAINER Anjesh Tuladhar <anjesh@yipl.com.np>

RUN apt-get update
RUN apt-get install -y \
                    curl \
                    git \
                    wget

RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" > /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get install -y \
                    apache2 \
                    php5 \
                    php5-cli \
                    php5-curl \
                    php5-mcrypt \
                    php5-readline 

RUN a2enmod rewrite
RUN a2enmod php5
RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/apache2/conf.d/20-mcrypt.ini
RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini

WORKDIR /var/www/html/
RUN git clone https://github.com/younginnovations/resourcecontracts-api rc-api

ADD conf/.env /var/www/html/rc-api/.env
WORKDIR /var/www/html/rc-api
RUN curl -s http://getcomposer.org/installer | php
RUN php composer.phar install --prefer-source
RUN php composer.phar dump-autoload --optimize


EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREGROUND

