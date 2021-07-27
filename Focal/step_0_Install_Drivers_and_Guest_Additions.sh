#!/bin/bash

## Install Drivers

# DisplayLink
printf "Please download displaylink-driver-5.4.0-55.153.run to $HOME/Downloads/
   file can be found at: https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu-5.4?filetype=exe\n"
read -n 1 -s -r -p "Press any key to continue when displaylink-driver-5.4.0-55.153.run is available"
printf "\n\n"
chmod 754 $HOME/Downloads/displaylink-driver-5.4.0-55.153.run
sudo $HOME/Downloads/displaylink-driver-5.4.0-55.153.run
printf "|nLoad MOK on reboot if UEFI Secure boot is enabled\n"

# Bluetooth broadcom firmware
wget -O $HOME/Downloads/broadcom-bt-firmware-10.1.0.1115.deb https://github.com/winterheart/broadcom-bt-firmware/releases/download/v12.0.1.1105_p3/broadcom-bt-firmware-10.1.0.1115.deb
sudo apt install ~/Downloads/broadcom-bt-firmware-10.1.0.1115.deb -y
sudo apt install gnome-shell-extension-bluetooth-quick-connect blueman -y
sudo hciconfig hci0 down
sudo rmmod btusb
sudo modprobe btusb
sudo hciconfig hci0 up
sudo rfkill unblock bluetooth
systemctl restart bluetooth
rm $HOME/Downloads/broadcom-bt-firmware-10.1.0.1115.deb 

#grep -i "hci0" /var/log/syslog
#sudo /etc/init.d/bluetooth status
#dmesg | grep -i bluetooth
#lspci -nnk | grep -iA2 net


### TODO configure power management for so that computer will wake from suspend
# already updated bios for ASPM ( still doesn't work )
# try updating to 465 or 470 https://forums.developer.nvidia.com/t/ubuntu-20-04-with-nvidia-460-driver-freezes-randomly-after-resume-from-suspend-hibernate/173818/16
# try https://download.nvidia.com/XFree86/Linux-x86_64/460.39/README/powermanagement.html
# used ideas from https://askubuntu.com/questions/1298198/ubuntu-20-04-doesnt-wake-up-after-suspend

### For running in VirtualBox VM only

### Manual tasks
# 1. attach host shared folder
###


read -p "Do you wish to install VirtualBox Guest Additions? [Y|N]" -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]] ; then

	printf "Installing VirtualBox Guest Additions...\n"

### TODO update for Focal 20.04

	printf "This feature is not implementned\n"
	exit 1
	
	# Make sure only root can run our script
	if [ "$(id -u)" != "0" ]; then
	   echo "This script must be run as root" 1>&2
	   exit 1
	fi

	# Install guest addition 5.0.14
	cd ~
	wget http://download.virtualbox.org/virtualbox/5.0.14/VBoxGuestAdditions_5.0.14.iso
	sudo mkdir /media/$USER/VBoxGuestAdditions_5.0.14
	sudo mount -o loop "~/VBoxGuestAdditions_5.0.14.iso" /media/$USER/VBoxGuestAdditions_5.0.14
	cd /media/$USER/VBoxGuestAdditions_5.0.14
	sudo ./VBoxLinuxAdditions.run
	cd ~
	sudo umount /media/$USER/VBoxGuestAdditions_5.0.14
	sudo rm -rf /media/$USER/VBoxGuestAdditions_5.0.14
	rm VBoxGuestAdditions_5.0.14.iso

	#add vboxsf user for host file sharing
	sudo usermod -a -G vboxsf $USER

	# enable virtualbox video
	if ! grep -q vboxvideo /etc/modules; then sudo bash -c 'echo "vboxvideo" >> /etc/modules'; fi
	
### End TODO

	# Blacklist i2c bus for VMs
	if ! grep -q "blacklist i2c_piix4" /etc/modprobe.d/blacklist.conf; then sudo bash -c 'echo -e "\n# for VMs\nblacklist i2c_piix4" >> /etc/modprobe.d/blacklist.conf'; fi

fi
