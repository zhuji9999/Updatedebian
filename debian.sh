#!/bin/bash  
RELEASE=$(cat /etc/issue)  
__do_apt_update(){  
    apt update  
    if [ $? -ne 0 ]; then  
        exit 1  
    fi;  
}  
__do_apt_upgrade(){  
    __do_apt_update  
    apt upgrade -y  
    apt dist-upgrade -y  
    apt full-upgrade -y  
}  
__do_debian10_upgrade(){  
    echo "[INFO] Doing debian 10 upgrade..."  
    __do_apt_upgrade  
    sed -i 's/stretch/buster/g' /etc/apt/sources.list  
    sed -i 's/stretch/buster/g' /etc/apt/sources.list.d/*.list  
    __do_apt_upgrade  
    echo "[INFO] Please reboot"  
}  
__do_debian11_upgrade(){  
    echo "[INFO] Doing debian 11 upgrade..."  
    __do_apt_upgrade  
    sed -i 's/buster/bullseye/g' /etc/apt/sources.list  
    sed -i 's/buster/bullseye/g' /etc/apt/sources.list.d/*.list  
    sed -i 's/bullseye\/updates/bullseye-security/g' /etc/apt/sources.list  
    __do_apt_upgrade  
    echo "[INFO] Please reboot"  
}  
__do_debian12_upgrade(){  
    echo "[INFO] Doing debian 12 upgrade..."  
    __do_apt_upgrade  
    sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list  
    sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list.d/*.list  
    sed -i 's/bullseye-security/bullseye-bookworm/g' /etc/apt/sources.list  
    __do_apt_upgrade  
    echo "[INFO] Please reboot"  
}  
# Check the system release and display an appropriate message for each version.  
if echo $RELEASE | grep ' 9 '; then  
    echo "Your system is running Debian 9. Do you want to upgrade to Debian 10? (y/n)"  
    read answer  
    if [ "$answer" = "y" ]; then  
        __do_debian10_upgrade  
    else  
        exit 0  
    fi;  
elif echo $RELEASE | grep ' 10 '; then  
    echo "Your system is running Debian 10. Do you want to upgrade to Debian 11? (y/n)"  
    read answer  
    if [ "$answer" = "y" ]; then  
        __do_debian11_upgrade  
    else  
        exit 0  
    fi;  
elif echo $RELEASE | grep ' 11 '; then  
    echo "Your system is running Debian 11. Do you want to upgrade to Debian 12? (y/n)"  
    read answer  
    if [ "$answer" = "y" ]; then  
        __do_debian12_upgrade  
    else  
        exit 0  
    fi;  
else  
    echo "Your system is not running Debian 9, 10, or 11."  
    exit 0;  
fi;
