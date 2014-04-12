$title=Postfix Sending & Forwarding

Here I'm setting up a Postfix server to do two things:

+ Receive mail for a list of domains and forward to other mail servers (no hosting of the mail)
+ Act as a secure SMTP server to send mail for those domains (from apps/etc)

This consists of two steps and programs being used:

+ Core Postfix install, which can receive and forward mail accordingly
+ Installation of Dovecot to provide SASL authentication to Postfix to allow users to login and send mail


First install Postfix & Dovecot (Debian command below, I'm pretty sure most/all package managers will contain both):

    apt-get install postfix dovecot-core


#### Mail Receiving & Forwarding

Now, to get mail forwarding we need some 'virtual maps' which map incoming emails to external emails, we tell Postfix the file we wish to use in /etc/postfix/main.cf (in this case /mail/addresses):

    virtual_maps = hash:/mail/addresses

The /mail/addresses file should look something like this:

    oxygem.com      DOMAIN
    nick@oxygem.com     nick@example.com
    stacksetup.com      DOMAIN
    test@stacksetup.com test@example.com
    jack@stacksetup.com jack@example.com

Postfix requires this file to be converted into a '.db' file (in the same directory), to do this simply:

    postmap /mail/addresses

This will generate file /mail/addresses.db. Now you need to set the MX record for the domain(s) to the hostname of your mail server. Once this is done try sending a test email and it should forward correctly. Watching /var/log/mail.info will show you it's progress once it hits the server.


#### Dovecot SASL Setup
The first step to enabling authentication over SMTP/Postfix is to setup Dovecot. We only need a very simple Dovecot setup as the only feature we're going to be using is it's auth server. Dovecot's configuration is in /etc/dovecot/dovecot.conf, we can ignore this file and head to /etc/dovecot/conf.d, where each .conf file is included automatically. I just removed all the files except logging, ssl and auth main. Add the following at the end of auth:

    #password file
    passdb {
      driver = passwd-file
      args = scheme=PLAIN username_format=%u /mail/users
    }
    #user file (same as password)
    userdb {
      driver = passwd-file
      args = username_format=%u /mail/users
    }

And I then created another file /etc/dovecot/conf.d/postfix.conf:

    service auth {
      # Postfix smtp-auth
      unix_listener /var/spool/postfix/private/auth {
        mode = 0666
      }

      # Auth process is run as this user.
      user = $default_internal_user
    }

Which tells Dovecot where to place the socket Postfix will use to authenticate. The /etc/users file should be similar to:

    test:testpass
    anotherusername:anotherpassword

Now we need to tell Postfix about our Dovecot setup, in /etc/postfix/main.cf:

    #sasl/dovecot for smtp auth
    smtpd_sasl_type = dovecot
    smtpd_sasl_path = private/auth
    smtpd_sasl_auth_enable = yes
    smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
    smtpd_sasl_security_options = noanonymous, noplaintext
    smtpd_sasl_tls_security_options = noanonymous
    smtpd_tls_auth_only = yes


#### Testing
Restart Postfix and fire up a terminal. Telnet can be used to test a non-secure connection, which will reject auth attempts as per the above config (change smtpd_tls_auth_only to no to test auth over Telnet). We can use openssl s_client to test the secure connection with auth:

    openssl s_client -ign_eof -crlf -connect example.com:25 -starttls smtp

Issue the following two commands (the first introduces the mail server, the second attempts to login with username "test" and password "testpass" (the string is a base64 encoding of test\0testpass\0:

    EHLO hostname.example.com
    AUTH PLAIN AHRlc3QAdGVzdHBhc3M=


#### Related:

+ [http://www.postfix.org/SASL_README.html](http://www.postfix.org/SASL_README.html)
+ [http://www.postfix.org/TLS_README.html](http://www.postfix.org/TLS_README.html)