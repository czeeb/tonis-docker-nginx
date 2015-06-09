#!/bin/sh
php5-fpm --nodaemonize >> /var/log/php5-fpm.log 2>&1
