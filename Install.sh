#!/bin/bash
source ./config.sh
[ -d $WORKDIR ] || mkdir -p $WORKDIR

yum install -y gcc libxml2-devel libcurl-devel libjpeg-devel libpng-devel freetype-devel libxslt-devel pcre pcre-devel openssl openssl-devel cmake gcc-c++ ncurses-devel perl-Data-Dumper; yum -y clean all  

if [ ! -d $NGX_INSTALL_PATH ]; then
	groupadd $NGX_GROUP
	useradd -M -s /bin/false -g $NGX_GROUP $NGX_USER
	if [ ! -d $WORKDIR/nginx-$NGX_VERSION ]; then
		cd $WORKDIR
		curl -o $WORKDIR/nginx-$NGX_VERSION.tar.gz http://mirrors.sohu.com/nginx/nginx-$NGX_VERSION.tar.gz
		tar zxf $WORKDIR/nginx-$NGX_VERSION.tar.gz
	fi
	mkdir -p $(NGX_INSTALL_PATH) 
	cd $WORKDIR/nginx-$NGX_VERSION
	./configure --prefix=$NGX_INSTALL_PATH --group=$NGX_GROUP --user=$NGX_USER --with-http_ssl_module
	make 
	make install
	sed -i "s#NGX_BIN_HOLDER#$NGX_INSTALL_PATH\/bin\/nginx/g" $CURTDIR/scripts/nginx.init.d
	sed -i "s#NGX_BIN_HOLDER#$NGX_INSTALL_PATH\/bin\/nginx/g" $CURTDIR/scripts/nginx.init.d
	cp $CURTDIR/scripts/nginx.init.d /etc/init.d/nginx
	chmod +x /etc/init.d/nginx
fi

if [ ! -d $MYSQL_INSTALL_PATH ]; then
	groupadd $MYSQL_GROUP
	useradd -M -s /bin/false -g $MYSQL_GROUP $MYSQL_USER
	if [ ! -d $WORKDIR/mysql-$MYSQL_VERSION ]; then
		cd $WORKDIR
		curl -o $WORKDIR/mysql-$MYSQL_VERSION.tar.gz $MYSQL_DL_URL
		tar zxf mysql-$MYSQL_VERSION.tar.gz
	fi
	mkdir -p $MYSQL_INSTALL_PATH
	mkdir -p $MYSQL_DATA_PATH
	cd $WORKDIR/mysql-$MYSQL_VERSION
	cmake . -DCMAKE_INSTALL_PREFIX=$MYSQL_INSTALL_PATH -DMYSQL_DATADIR=$MYSQL_DATA_PATH
	make 
	make install
	cp $MYSQL_INSTALL_PATH/support-files/my-default.cnf /etc/my.cnf
	$MYSQL_INSTALL_PATH/scripts/mysql_install_db --user=$MYSQL_USER --basedir=$MYSQL_INSTALL_PATH --datadir=$MYSQL_DATA_PATH
	$MYSQL_INSTALL_PATH/support-files/mysql.server start
	$MYSQL_INSTALL_PATH/bin/mysqladmin -u root password 'root'
	chown -R $MYSQL_GROUP.$MYSQL_USER $MYSQL_DATA_PATH
	cp $MYSQL_INSTALL_PATH/support-files/mysql.server /etc/init.d/mysql
fi

if [ ! -d $WORKDIR/libmcrypt-2.5.8 ]; then
cd $WORKDIR
curl -o $WORKDIR/libmcrypt.tar.gz http://ncu.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
tar zxf $WORKDIR/libmcrypt.tar.gz 
fi
cd $WORKDIR/libmcrypt-2.5.8
./configure --prefix=/usr/local
make
make install

if [ ! -d $WORKDIR/mhash-0.9.9.9 ]; then
cd $WORKDIR
curl -o $WORKDIR/mhash.tar.gz http://ncu.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz
tar zxf $WORKDIR/mhash.tar.gz 
fi
cd $WORKDIR/mhash-0.9.9.9
./configure --prefix=/usr/local
make 
make install

if [ ! -d $WORKDIR/mcrypt-2.6.8 ]; then
cd $WORKDIR
curl -o $WORKDIR/mcrypt.tar.gz http://ncu.dl.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz
tar zxf $WORKDIR/mcrypt.tar.gz 
fi
cd $WORKDIR/mcrypt-2.6.8
LD_LIBRARY_PATH=/usr/local/lib ./configure --prefix=/usr/local
make 
make install

if [ ! -d $PHP_INSTALL_PATH ]; then
	if [ ! -d $WORKDIR/php-$PHP_VERSION ]; then
		cd $WORKDIR
		curl -o $WORKDIR/php.tar.gz http://mirrors.sohu.com/php/php-$PHP_VERSION.tar.gz
		tar zxf $WORKDIR/php.tar.gz 
	fi
	mkdir -p $PHP_INSTALL_PATH 
	cd $WORKDIR/php-$PHP_VERSION
	./configure --prefix=$PHP_INSTALL_PATH --with-curl --enable-mbstring --with-mcrypt=/usr/local --with-mysql=$MYSQL_INSTALL_PATH --with-mysqli=$MYSQL_INSTALL_PATH/bin/mysql_config --with-pdo-mysql=$MYSQL_INSTALL_PATH --enable-fpm --enable-libxml --with-xsl --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-zlib --enable-opcache --with-openssl
	make 
	make install
	cp $PHP_INSTALL_PATH/etc/php-fpm.conf.default $PHP_INSTALL_PATH/etc/php-fpm.conf
	cp $WORKDIR/php-$PHP_VERSION/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
	chmod +x /etc/init.d/php-fpm
fi
