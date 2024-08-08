#!/bin/sh
# Simon's tools for Linux System administrators
# GIT: https://github.com/simonszoft/stools
# Created by: Simon Nándor <nandor.simon@gmail.com>
# file: install_motd.sh

clear

#Get current distribution
dist=`awk -F= '/^NAME/{print $2}' /etc/os-release`

echo $dist

if [[ $dist =~ .*"Ubuntu".* ]]; then
    disttype="UBUNTU"
elif [[ $dist =~ .*"Debian".* ]]; then
    disttype="DEBIAN"
else
    echo "Not supported linux distributon."
    exit
fi

#Installing packages
echo "Installing packages:"
if [ $(dpkg-query -W -f='${Status}' figlet 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    apt-get install figlet;
else
    echo "figlet...ok"
fi

if [ $(dpkg-query -W -f='${Status}' neofetch 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    apt-get install neofetch;
else
    echo "neofetch...ok"
fi


if [ "$disttype" = "UBUNTU" ]; then
    echo "Supported linux distribution: $disttype"
elif [ "$disttype" = "DEBIAN" ]; then
    echo "Supported linux distribution: $disttype"
else
    echo "ERROR: disttype"
    exit
fi

