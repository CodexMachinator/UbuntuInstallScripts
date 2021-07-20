#!/bin/bash

## set ssh
ssh-keygen -qt rsa -b 4096 -C "CodexMachinator@gmail.com" -N "" -f "$HOME/.ssh/id_rsa"

## code stuff
sudo apt install git git-review tree vim parallel -y
git config --global user.name "Michael McConnehey"
git config --global user.email CodexMachinator@gmail.com
git config --global core.editor nano
git config --global init.defaultBranch dev

git clone git@github.com:CodexMachinator/dotfiles.git $HOME/.dotfiles
sudo bash -c "$HOME/.dofiles/makeLink.sh"

sudo ./displaylink-driver-5.3.1.34.run
*remember to load MOK on reboot

#bluetooth
wget -P ~/Downloads https://github.com/winterheart/broadcom-bt-firmware/releases/download/v12.0.1.1105_p3/broadcom-bt-firmware-10.1.0.1115.deb
sudo apt install -y ~/Downloads/broadcom-bt-firmware-10.1.0.1115.deb
sudo apt-get install gnome-shell-extension-bluetooth-quick-connect
sudo apt-get install blueman
sudo hciconfig hci0 down
sudo rmmod btusb
sudo modprobe btusb
sudo hciconfig hci0 up
sudo rfkill unblock bluetooth
systemctl restart bluetooth

#grep -i "hci0" /var/log/syslog
#sudo /etc/init.d/bluetooth status
#dmesg | grep -i bluetooth
#lspci -nnk | grep -iA2 net
#gnome-tweaks


download android studio
download sdk
sudo-apt get install:libc6 i386:libncurses5 i386++libstdc:6 i386 lib32z1-libbz2.1:i386
sudo tar -xzf android-studio-ide-193.6514223-linux.tar.gz
move sdk to folders

##python install

sha256sum pycharm-professional-2020.3.tar.gz 
sudo tar -xzf pycharm-professional-2020.3.tar.gz -C /opt

sudo apt install python3-pip python3-dev

sudo -H pip3 install --upgrade pip
sudo /usr/bin/python3 -m pip install --upgrade pip

sudo -H pip3 install virtualenv
sudo -H pip3 install pipenv
sudo -H pip3 install conda
