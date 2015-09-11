#!/bin/bash
NGX_VERSION="1.9.4"
NGX_DL_URL="http://mirrors.sohu.com/nginx/nginx-$NGX_VERSION.tar.gz"
NGX_INSTALL_PATH="/servers/nginx"
NGX_GROUP="nginx"
NGX_USER="nginx"

MYSQL_VERSION="5.6.26"
MYSQL_DL_URL="http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-$MYSQL_VERSION.tar.gz"
MYSQL_INSTALL_PATH="/servers/mysql"
MYSQL_DATA_PATH="/data/mysql"
MYSQL_GROUP="mysql"
MYSQL_USER="mysql"

PHP_VERSION="5.6.6"
PHP_DL_URL="http://mirrors.sohu.com/php/php-$PHP_VERSION.tar.gz"
PHP_INSTALL_PATH="/servers/php"

CURTDIR=$(pwd)
WORKDIR=$(pwd)/tmp
