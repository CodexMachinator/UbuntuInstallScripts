#!/bin/bash

sudo apt install dconf-editor gnome-shell-extensions gnome-tweak-tool -y

# enable gnome extensions
gsettings set org.gnome.shell disable-user-extensions false

# turn on darkmode for application and system
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Yaru-dark'

# set gedit preferences
gsettings set org.gnome.gedit.preferences.editor highlight-current-line false
gsettings set org.gnome.gedit.preferences.editor scheme 'solarized-dark' 

# Trackpad turn off natural scroll
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Set Menu Bar Clock and Battery
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Remove Trash and Home off desktop to dock
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
gsettings set org.gnome.shell.extensions.desktop-icons show-home false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true

# Set Dock on left side and minimize on launcher click
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'

# remove show applications buttion
#gsettings set org.gnome.shell.extensions.dash-to-dock show-show-apps-button false

# change privacy settings
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
#gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.privacy remember-app-usage false

# Change Favorites in the Dock

if   [[ $(lsb_release -sc) = "focal" ]] ; then
	gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'firefox.desktop', 'thunderbird.desktop', 'libreoffice-startcenter.desktop', 'org.gnome.gedit.desktop']"
fi

# add code folder and bookmark it
mkdir -p ~/Code
echo "file:///home/$USER/Code" > $HOME/.config/gtk-3.0/bookmarks

### Not supported in Ubuntu 20.04

# Bring Out Submenu Of Power Off/Logout Button
#gsettings set com.canonical.indicator.session suppress-logout-menuitem false
#gsettings set com.canonical.indicator.session suppress-logout-restart-shutdown true
#gsettings set com.canonical.indicator.session suppress-restart-menuitem false
#gsettings set com.canonical.indicator.session suppress-shutdown-menuitem false

# date time on right side of menu bar

# put name in menu bar
#gsettings set com.canonical.indicator.session show-real-name-on-panel true

# Blacklist i2c bus for VMs
if ! grep -q "blacklist i2c_piix4" /etc/modprobe.d/blacklist.conf; then sudo bash -c 'echo -e "\n# for VMs\nblacklist i2c_piix4" >> /etc/modprobe.d/blacklist.conf'; fi

# Turn off data reporting
if   [[ $(lsb_release -sc) = "focal" ]] ; then
	# turn off crash reports
	file='/etc/default/apport'
	search='enabled'; replace='enabled=0'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	
	#turn off system reports
	ubuntu-report -f send no
	
	# opt out of popularity contest
	sudo apt remove popularity-contest -y
fi

gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 180


# Remove periodic software updates and checks
if   [[ $(lsb_release -sc) = "focal" ]] ; then

	file='/etc/apt/apt.conf.d/10periodic'
	search='Update-Package-Lists'; replace='APT::Periodic::Update-Package-Lists "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='Download-Upgradeable-Packages'; replace='APT::Periodic::Download-Upgradeable-Packages "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='AutocleanInterval'; replace='APT::Periodic::AutocleanInterval "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='Unattended-Upgrade'; replace='APT::Periodic::Unattended-Upgrade "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi

	file='/etc/apt/apt.conf.d/20auto-upgrades'
	search='Update-Package-Lists'; replace='APT::Periodic::Update-Package-Lists "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='Download-Upgradeable-Packages'; replace='APT::Periodic::Download-Upgradeable-Packages "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='AutocleanInterval'; replace='APT::Periodic::AutocleanInterval "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='Unattended-Upgrade'; replace='APT::Periodic::Unattended-Upgrade "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi

	file='/etc/update-manager/release-upgrades'
	search='Prompt='; replace='Prompt=never'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi

fi

unset file search replace

# use to identify other settings to add to script
# dconf watch /


sudo apt-get update -y
sudo apt-get autoremove -y && sudo apt-get autoclean -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y && sudo apt-get autoclean -y

# Delete history of script
sudo cat /dev/null > ~/.bash_history && history -c

# Restart after script
echo "\n\nAbout to Reboot\n\n"
sleep 5
sudo reboot
