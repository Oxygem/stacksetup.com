$description=How to set up Apache, PHP and MySQL
$keywords=apache, php, mysql, linux
$title=Apache + PHP with MySQL

Here I'm manually installing Apache and PHP to obtain the latest versions. I'm using Debian but the following steps (except the first set of package/library installs) should work on any Linux distro. This tutorial/guide assumes MySQL-server is installed on the machine in the default location (/usr/local/mysql).

Firstly install some bits Debian didn't have (minimal install from Linode):

    apt-get install cmake libncurses5-dev libapreq2 libxml2 libpng++-dev libjpeg8 libjpeg8-dev libpng3 libxml2-dev libapr1 libapr1-dev apache2-utils


#### Apache

Now, make a temporary directory, grab the latest Apache and untar:

    cd /tmp
    mkdir apache
    cd apache
    wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org//httpd/httpd-2.4.4.tar.gz
    tar -zxf httpd*
    cd httpd*

Configure & install Apache (to /opt/apache in this case):

    ./configure --prefix=/opt/apache --enable-rewrite --enable-ssl
    make
    sudo make install


##### PHP

Now, time to make a temp directory for PHP, grab & untar:

    cd /tmp
    mkdir php
    cd php
    wget http://www.php.net/get/php-5.4.13.tar.gz/from/uk1.php.net/mirror -O php-5.4.13.tar.gz
    tar -zxf php*
    cd php*

Configure, using Apache's apxs (APache eXtenSion protocol) system, then make & install:

    ./configure --prefix=/opt/php --with-apxs2=/opt/apache/bin/apxs --with-mysql=/usr/local/mysql
    make
    sudo make install


#### Finishing Up
Now, just add the following to your httpd.conf file (normally under the mime types module if statement – the module include is added automatically by the above install):

    AddHandler php5-script .php
    AddType text/html .php

Drop an index.php into your webroot directory and fire up Apache – voila!