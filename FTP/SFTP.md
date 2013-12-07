$title=SFTP: FTP without an FTP server

When you get shared hosting you upload files via FTP. When most people move to their own hardware/virtualized hardware they install an FTP server and continue as before.

However there's no need whatsoever to install an FTP server – SSH provides one for you! All you need to is add a new user & set a password:

    useradd <username>
    passwd <username>

Then just give them a home directory to write to (by default they'll be able to read the entire filesystem):

    usermod -d <directory> <username>

And login with an SFTP client (Cyberduck on OSX) using those details – FTP without the FTP server!