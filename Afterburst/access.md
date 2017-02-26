$title=Installing Afterburst's Support access key

#### What this is used for
Although Afterburst provide unmanaged VPS, it may occasionally be required for us to observe a problem inside your VPS, if we are unable to replicate it elsewhere. Additionally we may offer to provide assistance beyond our Unmanaged Support SLA; in which case we may be performing actions inside your VPS for you.

This is particularly important for KVM VPS, where we have significantly less access to your VPS without installing our access key. 

We recommend that you only install our key if we have asked you to do so in a ticket. The key can be safely uninstalled when we have completed our work for you. 

#### Install and uninstall
Our key can be installed or uninstalled using our access script. The script will install our access key if it does not already exist, and will uninstall it if it already exists when run.

The script must be run as a user with root privileges.

    # wget -O access.sh https://stacksetup.com/Afterburst/access.sh
    # chmod a+x access.sh
    # ./access.sh

If you have changed your SSH port, please let our support staff know in the ticket. 



