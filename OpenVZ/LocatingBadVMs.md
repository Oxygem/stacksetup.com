$title=Locating & Identifying "bad" OpenVZ Containers

OpenVZ often makes it difficult to map the processes found in top/htop to a VM. There are various methods/techniques we've developed over the years:

    lsof
    lsof -p <pid>

Hopefully this will show the location of the files the process is using, which should include some in the /vz/root/<ctid> directory. If this works, jump around full of joy because it's by far the easiest method. Unfortunately some processes (MySQL, I'm looking at you) don't behave nicely.


#### Disappearing Processes
Often the problem with a program is it will spawn a bunch of threads to do it's 'work'. These threads cause the high load, but are impossible to track (try lsof on a MySQL process doing writing, unless you're insanely fast or the server is really, really slow lsof will output nothing... because that process has already ended. So we need to locate the 'master' process – which is likely to have none/almost no load, and thus is hard to find (particularly if, as with VM hosting, the host node has thousands of processes running at once). Simply searching through ps aux would take way too long.


#### iotop
iotop is a fantastic piece of software for locating high-IO processes. The most useful command I have found is:

    iotop -a -P

`-a` puts it into 'accumulative' mode – meaning the reads/writes build up over time, which gives an easy way to find processes writing/reading large blocks of data. And `-P` makes it show processes and not threads, making it easier to capture 'disappearing processes'.


#### Kill a VM that won't die

    ps aux | grep init

Then, for each init process, lsof it to determine which VM it's related to. Once you find the VM in question, kill it's init process and it will die. May/likely-to cause data loss.