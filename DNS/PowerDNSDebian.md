$title=PowerDNS 3.1 On Debian 7 (Wheezy)

# THIS GUIDE IS OUTDATED!!


This wiki entry will guide you through setting up a PowerDNS-server (based on current 3.1 version) in a master-slave configuration using AXFR.
You can easily use this guide to add more slaves to your master if you want.
We will use a MySQL-backend for each server to store records, and AXFR to replicate zones across.
We will make sure that each server is listening and replying on IPv6 as well.
We will setup DNSSEC for the domains that support it (check with your registrar before, or skip this step!)

Initial steps required on both hosts:

    apt-get update && apt-get upgrade --force-yes
Installing the needed packages on both hosts

    apt-get install pdns-server pdns-backend-mysql pdns-recursor mysql-server nano dnsutils

The MySQL-server will now prompt you for a root-password, generate two passwords from wwwhere and save them for later. One will be used for the root account and the second one will be used for the powerdns-mysql user.

PowerDNS's recursor might also be a bitch here, so just abort the setup if so, and continue with the step below.
Create a pdns.sql-file with following data on both hosts

    nano pdns.sql

Paste the following into this file.
Don't forget to use the password you previously generated for your powerdns-user.

    CREATE DATABASE powerdns character set utf8;
    GRANT ALL ON powerdns.* TO 'poweradmin'@'localhost' IDENTIFIED BY 'yourgeneratedpasshere';
    FLUSH PRIVILEGES;
    USE powerdns;
    CREATE TABLE domains (
     id INT auto_increment,
     name VARCHAR(255) NOT NULL,
     master VARCHAR(128) DEFAULT NULL,
     last_check INT DEFAULT NULL,
     type VARCHAR(6) NOT NULL,
     notified_serial INT DEFAULT NULL,
     account VARCHAR(40) DEFAULT NULL,
     primary key (id)
    );
    CREATE UNIQUE INDEX name_index ON domains(name);
    CREATE TABLE records (
     id INT auto_increment,
     domain_id INT DEFAULT NULL,
     name VARCHAR(255) DEFAULT NULL,
     type VARCHAR(6) DEFAULT NULL,
     content VARCHAR(255) DEFAULT NULL,
     ttl INT DEFAULT NULL,
     prio INT DEFAULT NULL,
     change_date INT DEFAULT NULL,
     primary key(id)
    );
    CREATE INDEX rec_name_index ON records(name);
    CREATE INDEX nametype_index ON records(name,type);
    CREATE INDEX domain_id ON records(domain_id);
    CREATE TABLE supermasters (
     ip VARCHAR(25) NOT NULL,
     nameserver VARCHAR(255) NOT NULL,
     account VARCHAR(40) DEFAULT NULL
    );

Load structure into MySQL-servers (both)

    mysql -u root -p < pdns.sql

This should load the correct structure and then exit back to shell.
Delete old backend-config & create new one (both)

    rm /etc/powerdns/pdns.d/* && nano /etc/powerdns/pdns.d/pdns.local

Add the following to the newly created pdns.local

    gmysql-host=127.0.0.1
    gmysql-user=poweradmin
    gmysql-password=yourgeneratedpasshere
    gmysql-dbname=powerdns
    gmysql-dnssec=yes

Move old configs and creat new one (Master)

    mv /etc/powerdns/recursor.conf /etc/powerdns/recursor.conf.old && mv /etc/powerdns/pdns.conf /etc/powerdns/pdns.conf.old && nano /etc/powerdns/pdns.conf

Paste the following into your new config-file, and change accordingly. Please note that you can comment out the IPv6-stuff if you do not need it, but it is advised to keep it.

    allow-recursion=IPv6-address-of-your-slave,IPv4-address-of-your-slave
    allow-axfr-ips=IPv6-address-of-your-slave,IPv4-address-of-your-slave
    chroot=/var/spool/powerdns
    config-dir=/etc/powerdns
    daemon=yes
    disable-axfr=no
    disable-tcp=no
    guardian=yes
    launch=gmysql
    lazy-recursion=yes
    local-address=IPv4-address-of-your-master
    local-ipv6=IPv6-address-of-your-master
    query-local-address6=IPv6-address-of-your-master
    aaaa-additional-processing=yes
    local-port=53
    log-dns-details=on
    log-failed-updates=on
    loglevel=3
    module-dir=/usr/lib/powerdns
    master=yes
    slave=no
    recursor=127.0.0.1
    setgid=pdns
    setuid=pdns
    socket-dir=/var/run
    version-string=powerdns
    include=/etc/powerdns/pdns.d

Next we open up our recursor.conf

    nano /etc/powerdns/recursor.conf

And paste the following

    allow-from=IPv6-address-of-your-slave,IPv4-address-of-your-slave
    dont-query=
    local-address=127.0.0.1
    local-port=53
    quiet=yes
    setgid=pdns
    setuid=pdns

Next we configure the slave.


#### Slave configurations

    mv /etc/powerdns/recursor.conf /etc/powerdns/recursor.conf.old && mv /etc/powerdns/pdns.conf /etc/powerdns/pdns.conf.old && nano /etc/powerdns/pdns.conf

Paste the following into your new config-file, and change accordingly. Please note that you can comment out the IPv6-stuff if you do not need it, but it is advised to keep it.

    allow-recursion=IPv6-address-of-your-slave,IPv4-address-of-your-slave,IPv4-address-of-your-master,IPv6-address-of-your-master
    chroot=/var/spool/powerdns
    config-dir=/etc/powerdns
    daemon=yes
    disable-axfr=yes
    disable-tcp=no
    guardian=yes
    launch=gmysql
    lazy-recursion=yes
    local-address=IPv4-address-of-your-master
    local-ipv6=IPv6-address-of-your-master
    local-port=53
    module-dir=/usr/lib/powerdns
    recursor=127.0.0.1
    setgid=pdns
    setuid=pdns
    master=no
    slave=yes
    slave-cycle-interval=60
    socket-dir=/var/run
    version-string=powerdns
    include=/etc/powerdns/pdns.d

And finally we edit the recursor.conf

    nano /etc/powerdns/recursor.conf

And enter the following

    allow-from=IPv6-address-of-your-slave,IPv4-address-of-your-slave
    dont-query=
    local-address=127.0.0.1
    local-port=53
    quiet=yes
    setgid=pdns
    setuid=pdns

Save and exit. Next we will update the mysql-tables to be able to handle DNSSEC.


#### Update powerdns-table to support DNSSEC

First we change directory and fetch the updated dnssec-schema.

    cd /tmp && wget http://wiki.powerdns.com/trac/export/2930/trunk/pdns/pdns/dnssec.schema.mysql.sql

We then proceed to update our powerdns-tables using the above mentioned patch

    mysql -u root -pyourpasswordhere < dnssec.schema.mysql.sql

And we also need to change the maximum char-limit to be able to successfully store your key's

    mysql -u -root
    use powerdns;
    ALTER TABLE records MODIFY content VARCHAR(64000);


#### Install poweradmin

Once this is done you may proceed with installing a webserver, preferably using our lighttpd tutorial.
Create DNSSEC-keys
After you have created your zones and transfered everything, we will need to rectify your zones (even unsigned ones) and create keys for them.

This should be done on your master. It will be replicated to your slave(s)

    pdnssec rectify-zone example.com
    pdnssec add-zone-key example.com zsk
    pdnssec add-zone-key example.com ksk

With this done we can now try running the following command (via normal commandline) to see if DNSSEC works as intended.

    dig +dnssec +multiline 127.0.0.1 www.mydomain.com

If working correctly you should get something like this

    example.com.           43200 IN RRSIG SOA 8 2 86400 20121213000000 (
                                20121129000000 18651 example.com.
                                f2e14W/luhOd5rox562IOYCyYb6LSGjYsAIj4cvgnxWZ
                                s77DjD1VnYv8zGt7eE4nVZK4Pnc1aGmFewpMzj4d0ria
                                TXq9YuKu9i9w2uSlp04hzFHriOBxxNPSqj0tpzTBCU1U
                                HzWhZ5E39rSchXXWJLhtxeL5isOD5e6PC3OMnPk= )

Now to successfully finish off the chain, you would need to have your registrar support DNSSEC, contact them about how to proceed.