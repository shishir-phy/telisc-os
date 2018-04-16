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


disk=sdb

# 1 # Create a GPT partition table
parted -s /dev/$disk mklabel gpt

# 2 # Create a prtition for EFI(512MB,FAT32)
parted -s -a optimal /dev/$disk mkpart ESP fat32 2048s 263MB

# 3 # Create partition for /boot(512MB)
parted -s -a optimal /dev/$disk mkpart boot btrfs 263MB 775MB

# 4 # Create partition for /usr(8G)
parted -s -a optimal /dev/$disk mkpart usr btrfs 775MB 8967MB

# 5 # Create partition for /var(2G)
parted -s -a optimal /dev/$disk mkpart var btrfs 8967MB 11015MB

# 6 # Create partition for /var/run(2G)
parted -s -a optimal /dev/$disk mkpart var_run btrfs 11015MB 13063MB

# 7 # Create sub-volume of /var for /var/log(4G)
parted -s -a optimal /dev/$disk mkpart var_log btrfs 13063MB 17159MB

# 8 # Create partition /etc(2G)
parted -s -a optimal /dev/$disk mkpart etc btrfs 17159MB 19207MB

# 9 # Create partition /tmp(20G)
parted -s -a optimal /dev/$disk mkpart tmp btrfs 19207MB 39687MB

#10 # Create partition for /srv/nfsroot(4G)
parted -s -a optimal /dev/$disk mkpart nfsroot btrfs 39687MB 43783MB

#11 # Create partition for /srv/nfsroot/var(8G)
parted -s -a optimal /dev/$disk mkpart nfsroot_var btrfs 43783MB 51975MB

#12 # Create partition for /srv/nfsroot/usr(8G)
parted -s -a optimal /dev/$disk mkpart nfsroot_usr btrfs 51975MB 60167MB

#13 # Create partition for /srv/http(1G)
parted -s -a optimal /dev/$disk mkpart srv_http btrfs 60167MB 61191MB

#14 # Create partition for /srv/smtp(1G)
parted -s -a optimal /dev/$disk mkpart srv_smtp btrfs 61191MB 62215MB

#15 # Create partition /srv/boot(512MB)
parted -s -a optimal /dev/$disk mkpart srv_boot btrfs 62215MB 62727MB

#16 # Create partition for /clusterapps(50G)
parted -s -a optimal /dev/$disk mkpart clusterapps btrfs 62727MB 113927MB

#17 # Create partition / (4G)
parted -s -a optimal /dev/$disk mkpart root btrfs 113927MB 118023MB

#18 # Create partition for /home (remaining)
parted -s -a optimal /dev/$disk mkpart home btrfs 118023MB 100%


######## MOUNTING ###########

#mount /mnt
#mkdir /mnt/esp
#mount /mnt/esp
#mkdir /mnt/boot
#mount /mnt/boot
#mkdir /mnt/usr
#mount /mnt/usr
#mkdir /mnt/var
#mount /mnt/var
#mkdir /mnt/var/run
#mount /mnt/var/run
#mkdir /mnt/var/log
#mount /mnt/var/log
#mkdir /mnt/etc
#mount /mnt/etc
#mkdir /mnt/tmp
#mount /mnt/tmp
#mkdir /mnt/srv/nfsroot
#mount /mnt/srv/nfsroot
#mkdir /mnt/srv/nfsroot/var
#mount /mnt/srv/nfsroot/var
#mkdir /mnt/srv/nfsroot/usr
#mount /mnt/srv/nfsroot/usr
#mkdir /mnt/srv/http
#mount /mnt/srv/http
#mkdir /mnt/srv/smtp
#mount /mnt/srv/smtp
#mkdir /mnt/srv/arch
#mount /mnt/srv/arch
#mkdir /mnt/clusterapps
#mount /mnt/clusterapps
#mkdir /mnt/home
#mount /mnt/home
