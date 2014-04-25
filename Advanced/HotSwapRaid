$title=Hot Swapping with Raid

Once the drive is swapped, disable it:

    echo 1 > /sys/block/sdX/device/delete

Then re-enable:

    echo "0 0 0 " > /sys/class/scsi_host/host(X-1)/scan

Copy partitions from spare working to new drive:

    sfdisk -d /dev/sdOLD | sfdisk /dev/sdNEW
    
Re-add drives to arrays:

    mdadm -a /dev/mdX /dev/sdXX
