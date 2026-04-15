#!/bin/sh
# Simon's tools for Linux System administrators
# GIT: https://github.com/simonszoft/stools
# Created by: Simon Nándor <nandor.simon@gmail.com>
# file: install_motd.sh

#Version
version="1.0.1"
#Last update
lastupdate="2026-04-16"
#Hostname
hostname=`hostname`
#User id
EUID=`id -u`

clear

#Script header
echo "MOTD installer script for Debian and Ubuntu Linux distributions"
echo "(Simon's tools for Linux System administrators)"
echo "Version: $version"
echo "Last update: $lastupdate"
echo "GIT: https://github.com/simonszoft/stools\n"

#if /etc/os-release file is not exist, then exit
if [ ! -f /etc/os-release ]; then
    echo "ERROR: /etc/os-release file is not exist."
    exit
fi

#Get current distribution
dist=`awk -F= '/^NAME/{print $2}' /etc/os-release`

echo "Linux Distribution: $dist \n"


#Check if the distribution is supported
if [ "$dist" = "\"Ubuntu\"" ]; then
    disttype="UBUNTU"
elif [ "$dist" = "\"Debian GNU/Linux\"" ]; then
    disttype="DEBIAN"
else
    echo "ERROR: Unsupported Linux distribution."
    exit
fi

echo "Linux distribution is supported: $disttype"

#Check root user
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root."
    exit
fi

#Installing packages
echo "\nInstalling packages:"
if [ $(dpkg-query -W -f='${Status}' figlet 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    apt-get install figlet;
else
    echo "figlet...ok"
fi

#Ubuntu specific packages: neofetch
if [ "$disttype" = "UBUNTU" ]; then
    if [ $(dpkg-query -W -f='${Status}' neofetch 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then
        apt-get install neofetch;
    else
        echo "neofetch...ok"
    fi
fi

#Debian specific packages: fastfetch
if [ "$disttype" = "DEBIAN" ]; then
    if [ $(dpkg-query -W -f='${Status}' fastfetch 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then
        apt-get install fastfetch;
    else
        echo "fastfetch...ok"
    fi
fi

#Creating MOTD file
echo "\nCreating MOTD file..."
if [ -f /etc/motd ]; then
    echo "MOTD file already exist...ok"
else
    touch /etc/motd
    echo "MOTD file created...ok"
fi

#Creating MOTD script
echo "\nCreating MOTD script..."
if [ -f /etc/profile.d/motd.sh ]; then
    echo "MOTD script already exist...ok"
    #If the MOTD script already exist, question the user if they want to overwrite it
    read -p "MOTD script already exist. Do you want to overwrite it? (y/n) " answer
    if [ "$answer" = "n" ]; then
        exit
    fi
else
    touch /etc/profile.d/motd.sh
    echo "MOTD script created...ok"
fi

#Writing MOTD script
echo "\nWriting MOTD script..."
if [ "$disttype" = "UBUNTU" ]; then
    echo "figlet -c $hostname" > /etc/profile.d/motd.sh
    # Show logo options ?
    read -p "Do you want to show the Ubuntu logo in the MOTD? (y/n) " answer
    if [ "$answer" = "y" ]; then
        echo "neofetch --logo small" >> /etc/profile.d/motd.sh
    else
        echo "neofetch --logo none" >> /etc/profile.d/motd.sh
    fi
elif [ "$disttype" = "DEBIAN" ]; then
    echo "figlet -c $hostname" > /etc/profile.d/motd.sh
    # Show logo options ?
    read -p "Do you want to show the Debian logo in the MOTD? (y/n) " answer
    if [ "$answer" = "y" ]; then
        echo "fastfetch --logo small" >> /etc/profile.d/motd.sh
    else
        echo "fastfetch --logo none" >> /etc/profile.d/motd.sh
    fi
fi

#Custom MOTD message
read -p "Do you want to add a custom message to the MOTD? (y/n) " answer
if [ "$answer" = "y" ]; then
    read -p "Enter the custom message: " custommessage
    echo "echo \"$custommessage\"" >> /etc/profile.d/motd.sh
fi

echo "MOTD script written...ok"

#Modtd script permissions
echo "\nSetting MOTD script permissions..."
chmod +x /etc/profile.d/motd.sh
echo "MOTD script permissions set...ok"

#Modtd file permissions
echo "\nSetting MOTD file permissions..."
chmod 644 /etc/motd
echo "MOTD file permissions set...ok"

echo "\nMOTD installation completed successfully."

#Run MOTD script?
read -p "Do you want to run the MOTD script now? (y/n) " answer
if [ "$answer" = "y" ]; then
    /etc/profile.d/motd.sh
fi

#End of script