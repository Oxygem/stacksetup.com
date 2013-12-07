$title=Show Hardware Information

Basic Info:

    cat /proc/cpuinfo  #CPU
    cat /proc/meminfo  #RAM
    cat /proc/mdstat   #RAID


Hard Disk's:

    #need either hdparm or smartmontools (in yum/apt)
    hdparm -i /dev/sda
    #or
    smartctl -i /dev/sda