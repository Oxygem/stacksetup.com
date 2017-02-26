#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privileges." 1>&2
    exit 1
fi

if [ ! -f /home/afterburst/.ssh/authorized_keys ]; then
    echo "Did not find key, running install..."
    
    USERADD=`which useradd`
    MKDIR=`which mkdir`
    CHMOD=`which chmod`
    ECHO=`which echo`
    CHOWN=`which chown`
    KEY='from="176.9.117.205" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2W99Q/hYK/ktrUEt0jxEAgMg9i6zLRFemWXyX0OIe46EzhkNKp0GYGlEIeAvKowsQciFhuOLvPe3aLiv+8IV+gREP4NqLebx2Xq4yTlqUpTckv4w6iWljrD9KTdTy7P6hYLZdmizo3OI1fXBlXGCxeb7oOK2cxMg8FMIk3MtIJPO3oZJqtj+pkVRR/K6AtF1SzcIOCSB8gtq31eInWbiMQtlH6XwqFCUkhni08oDJkTznrAYpK7IkEcCVxZCZS8jRq1Pf1vjqhqTmZJP6qMtszweQEbS61nqzM3tktRsrr2KAHrc1umG23HXQC32EyXLMbSVvesy7rhNfO7r63WcEQ== support@afterburst.com'
    
    ${USERADD} afterburst
    ${MKDIR} /home/afterburst/.ssh
    ${CHMOD} 700 /home/afterburst/.ssh 
    ${ECHO} $KEY > /home/afterburst/.ssh/authorized_keys
    ${CHMOD} 600 /home/afterburst/.ssh/authorized_keys
    ${CHOWN} -R afterburst /home/afterburst
    
    echo "Afterburst Support key installed. Configuring sudo..."
    
    SUDOEXISTS=`cat /etc/sudoers | grep -w afterburst`
    if [[ ${#SUDOEXISTS} -gt 0 ]]; then
        echo "Sudo already configured."
    else
        SUDOSTRING='afterburst ALL=(ALL) NOPASSWD: ALL'
    
        ${ECHO} $SUDOSTRING >> /etc/sudoers
    fi
    echo "Done. To uninstall, re-run the script"
else
    echo "Key found, performing uninstall. To reinstall, re-run script."
    
    USERDEL=`which userdel`
    
    ${USERDEL} afterburst
    \rm -rf /home/afterburst
    echo "Done."
fi
    
