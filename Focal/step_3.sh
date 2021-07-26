#!/bin/bash

## setup ssh
#geneerate new key or copy from previous install
#ssh-keygen -qt rsa -b 4096 -C "CodexMachinator@gmail.com" -N "" -f "$HOME/.ssh/id_rsa"

# Set up git
sudo apt install git git-review -y
git config --global user.name "Cody Mach"
git config --global user.email CodexMachinator@gmail.com
git config --global core.editor nano
git config --global init.defaultBranch dev


# update apt-mirror to a maintained forked project
sudo apt install apt-mirror -y
git clone https://github.com/Stifler6996/apt-mirror.git $HOME/Downloads/apt-mirror-fork
sudo cp /usr/bin/apt-mirror /usr/bin/apt-mirror.bak
sudo cp $HOME/Downloads/apt-mirror-fork/apt-mirror /usr/bin/apt-mirror
sudo chown root:root /usr/bin/apt-mirror && sudo chmod 755 /usr/bin/apt-mirror

sudo cp $HOME/Downloads/apt-mirror-fork/postmirror.sh /media/mike/seagate500/repos/var/
sudo chmod 755 /media/mike/seagate500/repos/var/postmirror.sh 

#
sudo apt install tree vim parallel htop -y


# Install VM viewing tools
#sudo apt-get install -y gnome-boxes


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
