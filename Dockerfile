# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.16

MAINTAINER Chris Zeeb <chris.zeeb@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install nginx php5-fpm php5-cli git
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ && mv /usr/bin/composer.phar /usr/bin/composer

ADD ./nginx/default /etc/nginx/sites-available/default
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./php5-fpm/www.conf /etc/php5/fpm/pool.d/www.conf

RUN mkdir /etc/service/nginx
ADD ./nginx/nginx.sh /etc/service/nginx/run

RUN mkdir /etc/service/php5-fpm
ADD ./php5-fpm/php5-fpm.sh /etc/service/php5-fpm/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
