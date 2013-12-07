$title=Postfix DKIM Setup

Here we setup DKIM (wwwhttp://en.wikipedia.org/wiki/DomainKeys_Identified_Mail) for use with Postfix. To build the DKIM's for each email, we use software called OpenDKIM. This sits on a port listening on localhost only, and Postfix will pass emails 'through' the OpenDKIM server which will apply the keys (where appropriate – ie only on mail from owned domains).

DKIM is a three step process:

+ A private & public key is generated for each domain
+ The public key then must be added to the domains DNS as a txt record
+ OpenDKIM then signs the emails with the private key, and the public key is used to verify the email was sent from the domain owner (assumed: if you control the DNS you own/control the domain)


#### Setup OpenDKIM
Firstly we need to install OpenDKIM, via apt-get in this case:
apt-get install opendkim opendkim-tools

Next to configure OpenDKIM, which uses two files /etc/opendkim.conf and /etc/default/opendkim. The second file simply lists the port and IP to bind to. The most important part is telling OpenDKIM where to locate a few files (key table, signing table & hosts lists):

    KeyTable        /mail/dkim/keyTable
    SigningTable        /mail/dkim/signTable
    ExternalIgnoreList  /mail/dkim/hosts
    InternalHosts       /mail/dkim/hosts

Example /mail/dkim/hosts (simple list of domains):

    afterburst.com
    example.com

Example /mail/dkim/signTable (maps domain => DNS txt record name):

    afterburst.com default._domainkey.afterburst.com
    example.com default._domainkey.example.com

Example /mail/dkim/keyTable (maps DNS txt record name => domain private key):

    default._domainkey.afterburst.com afterburst.com:default:/mail/dkim/keys/afterburst.com/default.private
    default._domainkey.example.com example.com:default:/mail/dkim/keys/example.com/default.private


#### Configure Postfix

In /etc/postfix/main.cf:

    #dkim
    milter_default_action = accept
    milter_protocol = 6
    smtpd_milters = inet:localhost:12000
    non_smtpd_milters = inet:localhost:12000

That assumes you've setup /etc/default/opendkim to use port 12000 and localhost/127.0.0.1 to bind to.


#### Generate Keys
To generate a private/public key combo for a domain, simply:

    opendkim-genkey -d example.com

This creates two files: default.txt, which is a TXT record you need to apply on your DNS server, and default.private, which needs to be placed according to the OpenDKIM configuration above (keyTable).


#### Running & Testing

Start OpenDKIM & restart Postfix:

    service opendkim start
    service postfix reload

If you send mail from any configured domains and watch /var/log/mail.info you should see nothing mentioning OpenDKIM (if it works). However when you check the email source you should see the DKIM along with the email. Send an email to check-auth@verifier.port25.com and it'll automatically reply with DKIM test results (as well as SPF & DomainKeys testing) included.

Related:
https://help.ubuntu.com/community/Postfix/DKIM