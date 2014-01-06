$description=How to setup Lighttpd on Debian Linux
$keywords=lighttpd, debian
$title=Lighttpd on Debian 6

This wiki-entry will guide you through quickly setting up lighttpd to serve php-files.


#### Initial steps

    apt-get update && apt-get upgrade --force-yes

Installing needed packages:

    apt-get install nano lighttpd php5-cgi


#### Changing the configs

Next we proceed to edit our lighttpd.conf file to allow it to serve php-files

    nano /etc/lighttpd/lighttpd.conf

Modify the server.modules section to include:

    "mod_fastcgi",

    And at the end of the config add this:

    fastcgi.server = ( ".php" => ((
                         "bin-path" => "/usr/bin/php5-cgi",
                         "socket" => "/tmp/php.socket"
                     )))

Now save and restart your lighttpd-server using

    /etc/init.d/lighttpd restart

You may test that PHP is beign served correctly by creating a test.php file in your webroot, this file should contain the following:

    <?php
    phpinfo();
    ?>

If all is done successfully you should now see PHP-information.