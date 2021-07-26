#!/bin/bash

sudo apt install apt-mirror -y > /dev/null 2>&1

if   [[ $(lsb_release -sc) = "focal" ]] ; then

### Change sources.list file
sourcesfile='/etc/apt/sources.list'
mirrorfile='/etc/apt/mirror.list'

repopath='/media/mike/seagate500/repos'

[ -f "$sourcesfile" ] && sudo mv "$sourcesfile" "$sourcesfile.bak"

sourcestext="## Main and Restriced
deb http://archive.ubuntu.com/ubuntu/ focal main restricted
deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted

## Updates, Main and Restriced
deb     http://archive.ubuntu.com/ubuntu focal-updates main restricted
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted

## Universe
deb     http://archive.ubuntu.com/ubuntu/ focal universe
deb-src http://archive.ubuntu.com/ubuntu/ focal universe
deb     http://archive.ubuntu.com/ubuntu/ focal-updates universe
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates universe

## Multiverse
deb     http://archive.ubuntu.com/ubuntu/ focal multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal multiverse
deb     http://archive.ubuntu.com/ubuntu/ focal-updates multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates multiverse

## Backports
deb     http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse

## Security
deb     http://archive.ubuntu.com/ubuntu focal-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu focal-security main restricted universe multiverse

## Partners
deb     http://archive.canonical.com/ubuntu focal partner
deb-src http://archive.canonical.com/ubuntu focal partner"

sudo bash -c "echo '$sourcestext' > '$sourcesfile'"
printf "\nUpdated sources.list\n\n"


### Add offline repo to sources.list and configure mirror.list

read -p "Do you wish to use an offline mirror? [Y|N]" -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]] ; then

mirrortext="## Local Repository Mirror
deb     file://$repopath/mirror/archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb     file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb     file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse
deb     file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-security main restricted universe multiverse
deb     file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-proposed main restricted universe multiverse

deb-src file://$repopath/mirror/archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb-src file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb-src file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse
deb-src file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-security main restricted universe multiverse
deb-src file://$repopath/mirror/archive.ubuntu.com/ubuntu focal-proposed main restricted universe multiverse

"
sudo bash -c "echo '$mirrortext' > '$sourcesfile'"
sudo bash -c "echo '$sourcestext' >> '$sourcesfile'"

[ -f "$mirrorfile" ] && sudo mv "$mirrorfile" "$mirrorfile.bak"

mirrortext="############# config ##################
#
# set base_path    /var/spool/apt-mirror
  set base_path    $repopath
#
# set mirror_path  \$base_path/mirror
# set skel_path    \$base_path/skel
# set var_path     \$base_path/var
# set cleanscript \$var_path/clean.sh
# set defaultarch  <running host architecture>
# set postmirror_script \$var_path/postmirror.sh
# set run_postmirror 0
set nthreads     20
set _tilde 0
#
############# end config ##############

deb     [arch=amd64] http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb     [arch=amd64] http://archive.ubuntu.com/ubuntu focal-security main restricted universe multiverse
deb     [arch=amd64] http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb     [arch=amd64] http://archive.ubuntu.com/ubuntu focal-proposed main restricted universe multiverse
deb     [arch=amd64] http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse

deb     [arch=i386]  http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb     [arch=i386]  http://archive.ubuntu.com/ubuntu focal-security main restricted universe multiverse
deb     [arch=i386]  http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb     [arch=i386]  http://archive.ubuntu.com/ubuntu focal-proposed main restricted universe multiverse
deb     [arch=i386]  http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse

deb-src              http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb-src              http://archive.ubuntu.com/ubuntu focal-security main restricted universe multiverse
deb-src              http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb-src              http://archive.ubuntu.com/ubuntu focal-proposed main restricted universe multiverse
deb-src              http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse

clean http://archive.ubuntu.com/ubuntu"

sudo bash -c "echo '$mirrortext' > '$mirrorfile'"

printf "\nUpdated mirror.list\n\n"

fi

## Update sources
sudo apt update > /dev/null 2>&1

## Clean up script
unset mirrorfile sourcestext sourcesfile mirrortext repopath
sudo bash -c "cat /dev/null > ~/.bash_history && history -c"

else
	echo "Unable to create sources.list and mirror.list for Ubuntu $(lsb_release -sc)"
fi
