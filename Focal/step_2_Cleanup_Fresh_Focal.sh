#!/bin/bash

sudo apt install mesa-utils -y
printf "\nVerify current video settings:\n"
glxinfo | egrep "OpenGL vendor|OpenGL renderer|OpenGL core profile version string*"
printf "\n"

read -p "Do you wish to use the current graphic settings and continue the update? [Y|N]" -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
	exit 1
else
	printf "continuing...\n"
fi

# Update installed packages
sudo apt install dconf-editor gnome-shell-extensions gnome-tweak-tool wget -y
sudo apt-get update -y
sudo apt-get autoremove -y && sudo apt-get autoclean -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y && sudo apt-get autoclean -y

# enable gnome extensions
gsettings set org.gnome.shell disable-user-extensions false

# turn on darkmode for application and system
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.shell.extensions.user-theme name 'Yaru-dark'

# Set list view in file browser
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

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

# Set up Dock behaviors
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-monitors true

# remove show applications buttion
#gsettings set org.gnome.shell.extensions.dash-to-dock show-show-apps-button false

# change privacy settings
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'
#gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.privacy remember-app-usage false

# Change Favorites in the Dock

if   [[ $(lsb_release -sc) = "focal" ]] ; then
	gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'firefox.desktop', 'thunderbird.desktop', 'libreoffice-startcenter.desktop', 'org.gnome.gedit.desktop', 'gnome-control-center.desktop']"
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

gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 14


# Remove periodic software updates and checks
if   [[ $(lsb_release -sc) = "focal" ]] ; then

	file='/etc/apt/apt.conf.d/10periodic'
	search='Enable'; replace='APT::Periodic::Enable "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='Update-Package-Lists'; replace='APT::Periodic::Update-Package-Lists "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='Download-Upgradeable-Packages'; replace='APT::Periodic::Download-Upgradeable-Packages "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='AutocleanInterval'; replace='APT::Periodic::AutocleanInterval "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
	search='Unattended-Upgrade'; replace='APT::Periodic::Unattended-Upgrade "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi

	file='/etc/apt/apt.conf.d/20auto-upgrades'
	search='Enable'; replace='APT::Periodic::Enable "0";'
	if grep -q $search $file; then sudo sed -i "/$search/c\\$replace" $file; else sudo bash -c "echo '$replace' >> '$file'"; fi
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

# Set up bash dot files
#git clone git@github.com:CodexMachinator/dotfiles.git $HOME/.dotfiles
wget -O $HOME/Downloads/dotfiles-1.0.tar.gz --no-check-certificate --content-disposition https://github.com/CodexMachinator/dotfiles/archive/refs/tags/v1.0.tar.gz
mkdir -p $HOME/.dotfiles
tar -xf $HOME/Downloads/dotfiles-1.0.tar.gz -C $HOME/.dotfiles --strip-components=1
rm $HOME/Downloads/dotfiles-1.0.tar.gz
$HOME/.dotfiles/makeLink.sh

# use to identify other settings to add to script
# dconf watch /

# Delete history of script
sudo cat /dev/null > ~/.bash_history && history -c

# Restart after script
printf "\n\nRebooting 5 seconds\n\n\n"
sleep 5
sudo reboot
