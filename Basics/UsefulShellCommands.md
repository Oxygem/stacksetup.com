$title=Useful Shell Commands & Etc

A collection of useful shell stuff.


Run a command and print out lines where a string appears:

    <command> | grep <string>


Basic hard drive speed test, 512MB copy (see wwwthis):

    time sh -c "dd bs=1M count=512 if=/dev/zero of=test conv=fdatasync"


Tail + follow updates of logfiles:

    tail -f /var/log/syslog