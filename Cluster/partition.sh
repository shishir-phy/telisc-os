#!/bin/bash

# 1 # Create a GPT partition table
# 2 # Create a prtition for EFI(512MB,FAT32)
# 3 # Create partition for /boot(512MB)
# 4 # Create partition for /usr(8G)
# 5 # Create partition for /var(8G)
# 6 # Create sub-volume of /var for /var(2G)
# 7 # Create sub-volume of /var for /var/run(2G)
# 8 # Create sub-volume of /var for /var/log(4G)
# 9 # Create partition /etc(2G)
#10 # Create partition /tmp(20G)
#11 # Create partition /srv/nfsroot(20G)
#12 # Create sub-volume of /srv/nfsroot for /srv/nfsroot(4G)
#13 # Create sub-volume of /srv/nfsroot for /srv/nfsroot/var(8G)
#14 # Create sub-volume of /srv/nfsroot for /srv/nfsroot/usb(8G)
#15 # Create partition /srv(2G)
#16 # Create sub-volume of /srv for /srv/http(1G)
#17 # Create sub-volume of /srv for /srv/smtp(1G)
#18 # Create partition /srv/boot(512MB)
#19 # Create partition / (4G)

lsblk
read -p "Enter the name of the disk[ex. sda] " disk
echo "Disk $disk selected"

#disk=sdb

# 1 # Create a GPT partition table
parted -s /dev/$disk mklabel gpt

# 2 # Create a prtition for EFI(512MB,FAT32)
parted -s -a optimal /dev/$disk mkpart ESP fat32 2048s 263MB
parted -s /dev/$disk name 1 'esp'
parted -s /dev/$disk set 1 esp on

# 3 # Create partition for /boot(512MB)
parted -s -a optimal /dev/$disk mkpart primary btrfs 263MB 775MB
parted -s /dev/$disk name 2 'boot'

# 4 # Create partition for /usr(8G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 775MB 8967MB
parted -s /dev/$disk name 3 'usr'

# 5 # Create partition for /var(2G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 8967MB 11015MB
parted -s /dev/$disk name 4 'var'

# 6 # Create partition for /var/run(2G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 11015MB 13063MB
parted -s /dev/$disk name 5 'var_run'

# 7 # Create sub-volume of /var for /var/log(4G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 13063MB 17159MB
parted -s /dev/$disk name 6 'var_log'

# 8 # Create partition /etc(2G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 17159MB 19207MB
parted -s /dev/$disk name 7 'etc'

# 9 # Create partition /tmp(20G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 19207MB 39687MB
parted -s /dev/$disk name 8 'tmp'

#10 # Create partition for /srv/nfsroot(4G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 39687MB 43783MB
parted -s /dev/$disk name 9 'nfsroot'

#11 # Create partition for /srv/nfsroot/var(8G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 43783MB 51975MB
parted -s /dev/$disk name 10 'nfsroot_var'

#12 # Create partition for /srv/nfsroot/usr(8G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 51975MB 60167MB
parted -s /dev/$disk name 11 'nfsroot_usr'

#13 # Create partition for /srv/http(1G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 60167MB 61191MB
parted -s /dev/$disk name 12 'srv_http'

#14 # Create partition for /srv/smtp(1G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 61191MB 62215MB
parted -s /dev/$disk name 13 'srv_smtp'

#15 # Create partition /srv/boot(512MB)
parted -s -a optimal /dev/$disk mkpart primary btrfs 62215MB 62727MB
parted -s /dev/$disk name 14 'srv_boot'

#16 # Create partition for /clusterapps(50G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 62727MB 113927MB
parted -s /dev/$disk name 15 'clusterapps'

#17 # Create partition / (4G)
parted -s -a optimal /dev/$disk mkpart primary btrfs 113927MB 118023MB
parted -s /dev/$disk name 16 'root'

#18 # Create partition for /home (remaining)
parted -s -a optimal /dev/$disk mkpart primary btrfs 118023MB 100%
parted -s /dev/$disk name 17 'home'

######## FORMATTING #########

mkfs.fat -F 32 /dev/${disk}1

for i in {2..17}
do
   mkfs.btrfs -f /dev/${disk}$i
done

######## MOUNTING ###########

mount /dev/${disk}16 /mnt
mkdir -p /mnt/esp
mount /dev/${disk}1 /mnt/esp
mkdir -p /mnt/boot
mount /dev/${disk}2 /mnt/boot
mkdir -p /mnt/usr
mount /dev/${disk}3 /mnt/usr
mkdir -p /mnt/var
mount /dev/${disk}4 /mnt/var
mkdir -p /mnt/var/run
mount /dev/${disk}5 /mnt/var/run
mkdir -p /mnt/var/log
mount /dev/${disk}6 /mnt/var/log
mkdir -p /mnt/etc
mount /dev/${disk}7 /mnt/etc
mkdir -p /mnt/tmp
mount /dev/${disk}8 /mnt/tmp
mkdir -p /mnt/srv/nfsroot
mount /dev/${disk}9 /mnt/srv/nfsroot
mkdir -p /mnt/srv/nfsroot/var
mount /dev/${disk}10 /mnt/srv/nfsroot/var
mkdir -p /mnt/srv/nfsroot/usr
mount /dev/${disk}11 /mnt/srv/nfsroot/usr
mkdir -p /mnt/srv/http
mount /dev/${disk}12 /mnt/srv/http
mkdir -p /mnt/srv/smtp
mount /dev/${disk}13 /mnt/srv/smtp
mkdir -p /mnt/srv/arch
mount /dev/${disk}14 /mnt/srv/arch
mkdir -p /mnt/clusterapps
mount /dev/${disk}15 /mnt/clusterapps
mkdir -p /mnt/home
mount /dev/${disk}17 /mnt/home

echo "DONE!!"
