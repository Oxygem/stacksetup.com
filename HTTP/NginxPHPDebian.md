$title=nginx + PHP on Debian

This entry will guide you through setting up nginx with php5-fpm.

`www.example.com` and `192.168.1.1` are used as domains and IPs - change as required for you.


#### Initial steps

Ensure your installation is up to date

    apt-get update && apt-get upgrade --force-yes

Install the required packages:

    apt-get install nginx-light php5-fpm


#### Set up nginx

Nginx serves vhosts located in `/etc/nginx/sites-enabled/*` (usually symlinked from `/etc/nginx/sites-available`).  
We'll create a new vhost for your website of choice:

    nano /etc/nginx/sites-available/www.example.com

Here's a template you can drop the appropriate names into:

    server {
        listen 80;
        # If you want to listen on IPv6, uncomment this:
        #listen [::]:80 ipv6only=on;

        # Where you're keeping your site files:
        root /path/to/your/public_html;
        index index.php index.html index.htm;

        # Set this to `server_name _;` (underscore) to make this the
        # default server nginx will fall back to.
        server_name www.example.com example.com;

        location / {
            # Try serving as a file, then a directory, then
            # fall back to displaying a 404.
            try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;

            fastcgi_pass unix:/var/run/php5-fpm.sock;
            fastcgi_index index.php;
            include fastcgi_params;
        }

        location ~ /\.ht {
            # Ensure nobody can touch Apache config files.
            deny all;
        }
    }

Save the file, tell nginx about it, then reload nginx:

    ln -s /etc/nginx/sites-available/www.example.com /etc/nginx/sites-enabled/
    service nginx reload

If the reload fails, you may have to remove the default site provided by nginx (then try again):

    rm /etc/nginx/sites-enabled/default
    service nginx reload

_Note:_ The `try_files $uri =404;` line in the PHP block is to stop code-execution exploits. See [wiki.nginx.org/Pitfalls](http://wiki.nginx.org/Pitfalls#Passing_Uncontrolled_Requests_to_PHP) for more info.

#### Set up php5-fpm

Open up `php.ini` in your editor of choice:

    nano /etc/php5/fpm/php.ini

Ensure `cgi.fix_pathinfo=0`:

    [...]
    ; cgi.fix_pathinfo provides *real* PATH_INFO/PATH_TRANSLATED support for CGI.  PHP's
    ; previous behaviour was to set PATH_TRANSLATED to SCRIPT_FILENAME, and to not grok
    ; what PATH_INFO is.  For more information on PATH_INFO, see the cgi specs.  Setting
    ; this to 1 will cause PHP CGI to fix its paths to conform to the spec.  A setting
    ; of zero causes PHP to behave as before.  Default is 1.  You should fix your scripts
    ; to use SCRIPT_FILENAME rather than PATH_TRANSLATED.
    ; http://php.net/cgi.fix-pathinfo
    cgi.fix_pathinfo=0
    [...]

Save the file and reload php5-fpm:

    service php5-fpm reload

#### Test everything is functioning

You may have to start nginx/php5-fpm:

    service nginx start
    service php5-fpm start

Drop a file called `info.php` in your root (provided in the nginx vhost file) with the contents:

    <?php phpinfo(); ?>

Visit `http://www.example.com/info.php` and you should be greeted with information about your PHP install!
