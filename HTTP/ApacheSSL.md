$title=Apache SSL

It is assumed Apache is installed and compiled with SSL (recompile with --enable-ssl and --enable-setenvif).

First we need to generate a Certificate Signing Request, this is then sent to the SSL provider who return a certificate. It's also possible to use the signing request in your own self-signed certificate:

    openssl req -new -sha1 -newkey rsa:2048 -nodes -keyout example.com.key -out example.com.csr

This should give example.com.key which is a private key and example.com.csr, our signing request. You must set this up with your provider and they should return you a certificate, which you can paste into a new file called example.com.cert. They should also send you a CA (certificate authority certificate) file, called example.com.ca in this article.

To verify your certificate, key and CA file all work together we run a few commands, first to check the CA file:
openssl verify -CAfile example.com.ca -purpose sslserver example.com.cert

Next, check the certificate corresponds to our private key, the output from each of the following should be the identical:

    openssl x509 -noout -modulus -in example.com.cert | openssl sha1
    openssl rsa -noout -modulus -in example.com.key | openssl sha1

Now we have our certificate and private key we can begin setting up Apache for SSL. A few things to add somewhere in httpd.conf (snippets are from extra/httpd-ssl.conf when building Apache):

    #listen on port 433 (https)
    Listen 443
    #   SSL Cipher Suite:
    #   List the ciphers that the client is permitted to negotiate.
    #   See the mod_ssl documentation for a complete list.
    SSLCipherSuite HIGH:MEDIUM:!aNULL:+SHA1:+MD5:+HIGH:+MEDIUM

    #   Pass Phrase Dialog:
    #   Configure the pass phrase gathering process.
    #   The filtering dialog program (`builtin' is an internal
    #   terminal dialog) has to provide the pass phrase on stdout.
    SSLPassPhraseDialog  builtin

Now Apache's main configuration is complete, we just need a new VirtualHost to deal with the directories/certificate itself (example from our afterburst.com configurations):

    <VirtualHost *:443>
        DocumentRoot "/web/www/afterburst.com/client.afterburst.com"
        ServerAlias afterburst.com

        #enable ssl
        SSLEngine on

        #certificate
        SSLCertificateFile "/web/ssl/afterburst.com/cert"

        #private key
        SSLCertificateKeyFile "/web/ssl/afterburst.com/key"

        #ca certificate
        #SSLCertificateChainFile "/web/ssl/afterburst.com/ca"
    </VirtualHost>

Related:
wwwhttp://onlamp.com/onlamp/2008/[..]sl-under-apache.html