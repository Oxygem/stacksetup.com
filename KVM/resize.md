$title=Upgrading KVM - Resizing

#### Background
Our KVM plans can be upgraded at any time. However, in order to take advantage of the additional disk space, some changes need to be made on both the partitions and the filesystem. This guide will assume the layout used by our template installs -- if you've installed via ISO, you will need to tweak to be suitable for your system. 

Partitions must be resized before the filesystem is resized. 

#### Rescue Disk

First, you must boot into a rescue CD in order to make changes to the partitions. To do this, access the VPS control panel and mount '_RescueDisks - GRML' in the CDRom section.

Secondly, you must change the boot order to ensure the rescue disk is booted. To do this, navigate to the Settings tab and change the boot order to '(1) CDROM (2) Hard Disk'. 

Now, reboot the VPS using the Reboot button and then access the HTML5 VNC Console by clicking VNC. The rescue system should now be visible. GRML will ask if you want to change any options before dropping you to shell -- normally the defaults are OK (just press Enter). 

#### Resizing the partitions
First we must identify whether the disk is /dev/sda or /dev/vda (virtio).

    root@grml ~# ls -al /dev/[sv]da
    brw-rw---- 1 root disk 254, 0 Jun 7 17:28 /dev/vda 
    
In this example above, the disk is /dev/vda. Now we can take a look at the current partitions using the parted 'print' command.

    root@grml ~# parted /dev/vda
    ...
    (parted) print

This will display current partitions. In this example, we have two partitions; one 68.8GB of ext4 and one 1141MB of linux-swap(v1). If you installed using our templates, your layout is likely similar. Additionally, we can see the full size of the block device listed as "Disk /dev/vda: 129GB".

We will now need to delete the swap partition in order to extend the first (data) partition. 

    (parted) rm 2

Now we can proceed in extending the first partition. It is advisible to leave approximately 1-2GB left available for a new swap partition.

    (parted) resizepart 1 128GB
    
Finally, we can recreate the swap partition.

    (parted) mkpart
    (parted) Partition type? primary/extended? primary
    (parted) File system type? linux-swap
    (parted) Start? 128GB
    (parted) End? 129GB
    (parted) quit
    root@grml ~#
    
#### Resizing the filesystem

Now we must resize the filesystem in order for this extra space to be usable. We can do this with the resize2fs tool. Sometimes it may insist on a fsck being run first.

    root@grml ~# resize2fs /dev/vda1
    ...
    Please run 'e2fsck -f /dev/vda1 first
    root@grml ~# e2fsck -f /dev/vda1
    ...
    /dev/vda1: x/y files (n.n% non-contiguous), a/b blocks
    root@grml ~# resize2fs /dev/vda1
    ...
    Resizing the filesystem on /dev/vda1 to X (4k) blocks
    The filesystem on /dev/vda1 is now X (4k) blocks long.
    ...
    root@grml ~#
 
#### Finishing up

Now we just need to make sure that the swap exists on the new swap partition /dev/vda2. 

    root@grml ~# mkswap /dev/vda2
    root@grml ~# shutdown -h now
    
Finally, return to the VPS control panel and unmount the rescue disk from the CD-Rom. Then change the boot order back to '(1) Hard Disk (2) CD-ROM' and then click the 'reboot' button. 

The system should boot as expected -- but if there is any problems you can check via the VNC console. Once booted, the additional disk space will be available to the system.

    root@test-resize:~# df -h
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/vda1       118G 1005M  111G   1% /
    udev             10M     0   10M   0% /dev
    tmpfs           213M  4.4M  209M   3% /run
    tmpfs           532M     0  532M   0% /dev/shm
    tmpfs           5.0M     0  5.0M   0% /run/lock
    tmpfs           532M     0  532M   0% /sys/fs/cgroup

