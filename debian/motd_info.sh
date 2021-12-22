#!/bin/sh
# Simon's tools for Linux System administrators
# GIT: https://github.com/simonszoft/stools
# Created by: Simon Nándor <nandor.simon@gmail.com>

clear

#screenfetch
screenfetch

#standard ver / alap verzió
uname -snrvm

#Full verison / Teljes verzió
VER=`cat /etc/debian_version`
echo "Debian full version: $VER"

#Network devices / Hálózati eszközök
echo "Networking:"
ip a | grep "inet" | grep "brd"