#!/bin/sh

echo -e "o\nn\np\n1\n\n+10gb\nw\n" | fdisk /dev/sda #crear particion de 10gb 
echo -e "\t\t\t\t\t\n\t\t\t\t\t\t\nyes\n\t\t\t\t\t\n"| cfdisk #hacerboot sda1#
clear                                                         #limpiar 
echo -e "n\np\n2\n\n+1gb\nt\n2\n82\n\nw\n" | fdisk /dev/sda   #crear particion swap
echo -e "n\np\n3\n\n\n\nw\n" | fdisk /dev/sda                 #crear particion con los gb que quedan 
mkfs.ext4 /dev/sda1                                           #formatear ext4 la / 
mkfs.ext4 /dev/sda3                                           #formatear ext4 la /home
mkswap /dev/sda2                                            
swapon /dev/sda2                                              #swap
mount /dev/sda1 /mnt                                          #monta /
mkdir /mnt/home                                               #montar home
mount /dev/sda3 /mnt/home                                           
pacstrap /mnt base base-devel                                 #instalar base    
genfstab -U /mnt >> /mnt/etc/fstab                                  
cat << EOF |arch-chroot /mnt                                  #entrar en chroot
echo localhost > /etc/hostname
pacman --noconfirm -S grub
grub-install /dev/sda 
grub-mkconfig -o /boot/grub/grub.cfg
echo "root\nroot\n"|passwd
pacman -Syu
EOF
reboot
