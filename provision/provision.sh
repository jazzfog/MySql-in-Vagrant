#!/bin/bash

#-------------------------------------------------
# Non-interactive update & dist-upgrade

unset UCF_FORCE_CONFFOLD
export UCF_FORCE_CONFFNEW=YES
ucf --purge /boot/grub/menu.lst
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade

#-------------------------------------------------
# Install some tools

apt-get -y install htop ntp ntpdate mc

#-------------------------------------------------

# Install MySQL in non-interactive mode, with login 'root', password - empty.
# use "mysql -u root" in order to connect from localhost, not need to use key "-p"
DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server

# Also you can use these instead, if you want to set real password
#echo mysql-server mysql-server/root_password password 'somepassword' | sudo debconf-set-selections
#echo mysql-server mysql-server/root_password_again password 'somepassword' | sudo debconf-set-selections

# Installing client
apt-get install -y mysql-client

# Stop MySQL before any changes
/etc/init.d/mysql stop

# Copy original binary files to new folder (if not exists yet)
if [ ! -d /vagrant/MysqlData ]
then
  mkdir -p /vagrant/MysqlData
  cp -R -p -v /var/lib/mysql/* /vagrant/MysqlData;
else
  printf "* \n";
  printf "* Data directory already exists: Not creating one. \n";
  printf "* Remove dir '/vagrant/MysqlData' if you want to reset state and provision new DB from scratch. \n";
  printf "* \n";
fi

# Extend main config with custom, where new data directory is specified
cp /vagrant/provision/my.cnf /etc/mysql/conf.d/my.cnf

# Update paths in App Armor config
sed -i 's/\/var\/lib\/mysql/\/vagrant\/MysqlData/g' /etc/apparmor.d/usr.sbin.mysqld

# Reload App Armor
/etc/init.d/apparmor reload

# Yes, `restart` not just `start` MySQL
/etc/init.d/mysql restart

#-------------------------------------------------

# Do not remove
sleep 3

# Extract debian randomly generated password
DEBPASS=$(awk -F "=" '/password/ {print $2;exit;}' /etc/mysql/debian.cnf)
DEBPASS="${DEBPASS//[[:space:]]/}"

# Allow access from all hosts for root
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ''"

# Apply debian randomly generated password to our persistent DB
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '$DEBPASS'"

# Final MySQL restart
/etc/init.d/mysql restart

#-------------------------------------------------