$title=Setting up Poweradmin using lighttpd on Debian 6

This wiki entry will guide you through the process of setting up Poweradmin using lighttpd.

Poweradmin is a web-based frontend for managing PowerDNS.

You may find a guide for installing it here and a guide for setting up lighttpd here

This guide assumes you already have lighttpd up and running!


#### Initial steps

    apt-get update && apt-get upgrade --force-yes

Installing needed packages:

    apt-get install php5-mysql php-pear php5-mcrypt

Getting & Extracting poweradmin:

    cd /var/www && wget https://github.com/downloads/poweradmin/poweradmin/poweradmin-2.1.6.tgz && tar zxvf poweradmin-2.1.6.tgz
    mv /var/www/poweradmin-2.1.6 /var/www/poweradmin

Next we change the permissions for the poweradmin-directory

    chown www-data.www-data -R poweradmin

And finally we rename our poweradmin-config

    cp /var/www/poweradmin/inc/config-me.inc.php /var/www/poweradmin/inc/config.inc.php

Our next step is to browse to wwwhttp://our-server-ip/poweradmin/install


#### Installing poweradmin
Follow the on-screen installation process and enter the details you've previously used when setting up PowerDNS.

After successfully completing the installation, proceed to remove the installation-directory

    rm -rf /var/www/poweradmin/install


#### Setting up zone-templates

Press "List zone templates" > Add Zone Templates > Enter name and description.
You should get the following message

Zone template has been added successfully.

Proceed to edit the template and add the following records

    [ZONE] SOA ns1.example.com hostmaster.example.com [SERIAL] 10800 3600 604800 600
    [ZONE] A   192.168.56.3 600
    www.[ZONE] A   192.168.56.3 600
    [ZONE] NS  ns1.example.com 86400
    [ZONE] NS  ns2.example.com 86400


#### Using zone-templates & master-zones

You may use the template for any new domain you wish to host, just select the template you just created.

Try creating a new master-zone using the template we created, and do not forget to add A-records for ns1.example.com/ns2.example.com
Updating slaves to use a supermaster:

On your slaves you should issue the following commands to make sure that your slaves are replicating the domain(s) you have selected.

    mysql -u -root -p
    use powerdns;
    insert into supermasters values ('192.168.1.1', 'ns1.example.com', 'admin');

Once this is done you should see your slaves starting to replicate the master-zones you have created!


#### Additional testing

Once you have successfully restarted everything, created a master-zone and changed the nameservers for your domain to yours you may try it out.

Using this convenient site we can test if and how our nameservers reply correctly

    http://www.kloth.net/services/dig.php

Enter your domainname, your nameservers and check that it is answering queries as it should (DNSSEC/IPv6 etc)