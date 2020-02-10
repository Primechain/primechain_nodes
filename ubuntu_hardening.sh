#!/bin/bash

source primechain-api.conf

if ! id $linux_admin_user >/dev/null 2>&1; then
	# Setting up user account
	echo '----------------------------------------'
	echo -e 'SETTING UP '$linux_admin_user' USER ACCOUNT:'
	echo '----------------------------------------'

	passwd=`< /dev/urandom tr -dc A-Za-z0-9 | head -c20; echo`
	sudo useradd -d /home/$linux_admin_user -s /bin/bash -m $linux_admin_user
	sudo usermod -a -G sudo $linux_admin_user
	echo $linux_admin_user":"$passwd | sudo chpasswd
	echo "$linux_admin_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers    
fi

# Update the system
echo '----------------------------------------'
echo -e 'UPDATING THE SYSTEM:'
echo '----------------------------------------'
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get -y autoclean

# sleep 3

# echo '----------------------------------------'
# echo -e 'SETTING PASSWORD AGING FOR USER ACCOUNT:'
# echo '----------------------------------------'
# sudo chage -M 60 -m 7 -W 7 $linux_admin_user
# sudo chage -M 60 -m 7 -W 7 $USER

sleep 3

# Setting up swap partition
echo '----------------------------------------'
echo -e 'SETTING UP SWAP PARTITION:'
echo '----------------------------------------'

sudo dd if=/dev/zero of=/swapfile bs=4M count=500
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s
echo '/swapfile swap swap defaults 10 10' >> /etc/fstab
sudo echo 20 >> /proc/sys/vm/swappiness
sudo echo vm.swappiness = 20 >> /etc/sysctl.conf


sleep 3
echo '----------------------------------------'
echo -e 'DISABLING PING REQUESTS AND IPV6:'
echo '----------------------------------------'

echo 'net.ipv4.icmp_echo_ignore_all = 1' >> /etc/sysctl.conf
echo 'net.ipv4.icmp_echo_ignore_broadcasts = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf
sudo sysctl -p


echo '----------------------------------------'
echo -e 'VERIFYING OPENSSL VERSION:'
echo '----------------------------------------'

sudo apt-get -y update
sudo apt-get -y upgrade openssl libssl-dev
sudo apt-cache policy openssl libssl-dev


echo '----------------------------------------'
echo -e 'SECURING SHARED MEMORY:'
echo '----------------------------------------'

echo 'tmpfs     /run/shm    tmpfs     ro,noexec,nosuid        0       0' >> /etc/fstab
sudo mount -a


sleep 3
echo '----------------------------------------'
echo -e 'SECURING /tmp:'
echo '----------------------------------------'

cp -p /etc/fstab /etc/fstab.back
sudo dd if=/dev/zero of=/usr/tmpDSK bs=1024 count=1024000
sudo mkfs.ext4 /usr/tmpDSK
sudo cp -avr /tmp /tmpbackup

#Mount the new /tmp partition, and set the right permissions.
sudo mount -t tmpfs -o loop,noexec,nosuid,rw /usr/tmpDSK /tmp
sudo chmod 1777 /tmp

#Copy the data from the backup folder, and remove the backup folder.
sudo cp -avr /tmpbackup/* /tmp/
sudo rm -rf /tmpbackup

# Set the /tmp in the fbtab.
echo '/usr/tmpDSK /tmp tmpfs loop,nosuid,noexec,rw 0 0' >> /etc/fstab

#Test fstab entry.
sudo mount -a


sleep 3
echo '----------------------------------------'
echo -e 'SECURING /var/tmp:'
echo '----------------------------------------'

#create a symbolic link that makes /var/tmp point to /tmp.
sudo mv /var/tmp /var/tmpold
sudo ln -s /tmp /var/tmp
sudo cp -avr /var/tmpold/* /tmp/


echo '----------------------------------------'
echo -e 'SET SECURITY LIMITS:'
echo '----------------------------------------'

echo 'user1 hard nproc 100' >> /etc/security/limits.conf


echo '----------------------------------------'
echo -e 'SECURING SERVER AGAINST BASH VULNERABILITY:'
echo '----------------------------------------'

sudo apt-get -y update
sudo apt-get -y install --only-upgrade bash
