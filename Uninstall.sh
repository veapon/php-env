#!/bin/bash
source ./config.sh

userdel $NGX_USER
groupdel $NGX_GROUP
rm -rf $NGX_INSTALL_PATH /etc/init.d/nginx

userdel $MYSQL_USER
groupdel $MYSQL_GROUP
rm -rf $MYSQL_INSTALL_PATH $MYSQL_DATA_PATH /etc/init.d/mysql

rm -rf $PHP_INSTALL_PATH /etc/init.d/php-fpm
