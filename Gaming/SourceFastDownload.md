$title=Source Fast Download

In order to use Fast Download with a source game, an HTTP server needs to be set up. If you're already using one, I suggest placing the HTTP server for the Fast Download service on a different port (maybe 8080?). Setting up the actual server is not that difficult.


#### HTTP Server

In order to set up the HTTP server, you'll need a directory to serve the files. This directory should be relative to the game directory (for Team Fortress 2, it'd be the tf directory). We'll use /home/source-server/public/ for now.


#### Nginx

For nginx, you should define a server that points to that directory:

    server {
      listen 8080; # We're assuming that we're going to be listening on port 8080.
      server_name some_ip; # This should be the server name, whether it be a domain (i.e. example.com) or an IP (i.e. 192.168.0.1).

      location / {
        root /home/source-server/public; # This is the directory that we're going to serve files from.
        autoindex on; # This is completely optional; if someone were to look at the root (/) location on your server, they'd see an index
                      # of all the files in that directory because of this.
        autoindex_exact_size off; # This is used for the option above.
      }
    }

This should be defined in an HTTP context for Nginx.

Once you have that set up, start nginx or restart it. You might want to make sure that the operating system starts nginx on start up (just in case the server goes down).


#### Apache

For Apache, you should define a virtual host that points to that directory:

    Listen 8080

    <VirtualHost *:8080> # again, port 8080
      DocumentRoot /home/source-server/public # This is the directory that we're going to serve files from.
      ServerName some_ip # This should be the server name, whether it be a domain (i.e. example.com) or an IP (i.e. 192.168.0.1).
      Options +Indexes  # This is completely optional; if someone were to look at the root (/) location on your server, they'd see an index
                        # of all the files in that directory because of this.
    </VirtualHost>

Once you have that set up, start Apache or restart it. You might want to make sure that the operating system starts Apache on start up (just in case the server goes down).


#### Serving Files

Serving files for your server is as simple as adding them to the directory. The server must also tell the clients that join it that those files are needed for download; for maps that the client doesn't have, this is done automatically; for models, sounds, etc., this needs to be done through a SourceMod plugin.


#### Compression

Most source games by default support a .bz2-compressed file and will check for this before downloading the raw file; to take advantage of this, compressing the file needs to be done:

    bzip2 --best -k -z -- file_name