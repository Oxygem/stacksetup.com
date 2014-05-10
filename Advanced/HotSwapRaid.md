$title=Hot Swapping with Raid

Before removing drive, remove from raid arrays:

    mdadm -f /dev/mdX /dev/sdXX
    mdadm -r /dev/mdX /dev/sdXX

Then disable it entirely:

    echo 1 > /sys/block/<name of device ie sda>/device/delete

Tail the end of dmesg and note the ata number, something similar to:

    [1380211.312112] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
    [1380211.312313] sd 2:0:0:0: [sdc] Stopping disk
    [1380211.846080] ata3.00: disabled

Replace the drive, and once replaced use this number - 1 to trigger a re-scan of the drive connection:

    echo "0 0 0 " > /sys/class/scsi_host/host<ata number - 1>/scan

Copy partitions from spare working to new drive:

    sfdisk -d /dev/sdOLD | sfdisk /dev/sdNEW
    

Re-add drives to arrays:

    mdadm -a /dev/mdX /dev/sdXX
