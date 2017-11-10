#!/bin/bash

#Cubiecopiadora realiza imagenes para memoria SD para cubieboard A10
#Copyright (C) 2017 Leon Ramos @fulvous
#
#Este archivo es parte de Cubiecopiadora
#
#Cubiecopiadora es software libre: Puede redistribuirlo y/o 
#modificarlo bajo los terminos de la Licencia de uso publico 
#general GNU de la Fundacion de software libre, ya sea la
#version 3 o superior de la licencia.
#
#Cubiecopiadora es distribuida con la esperanza de que sera util,
#pero sin ningun tipo de garantia; inclusive sin la garantia
#implicita de comercializacion o para un uso particular.
#Vea la licencia de uso publico general GNU para mas detalles.
#
#Deberia de recibir uan copia de la licencia de uso publico
#general junto con Cubiecopiadora, de lo contrario, vea
#<http://www.gnu.org/licenses/>.
#
#This file is part of Cubiecopiadora
#
#Cubiecopiadora is free software: you can redistribute it and/or 
#modify it under the terms of the GNU General Public License 
#as published by the Free Software Foundation, either version 3 
#of the License, or any later version.
#
#Cubiecopiadora is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with Cubiecopiadora  If not, see 
#<http://www.gnu.org/licenses/>.

set -e

source include/colores.sh

PWD_F="$(pwd)"
TMP_F="tmp"
TMP_DEV="image.raw"
MOUNT_R="mnt"
OUTPUT_F="output"
KERNEL_F="linux-sunxi"
DISTRO="wheezy"

NEW_USER="meganucleo"
#WALLPPR="meganucleo_wallpaper-3840x2160.jpg"
#REPLACEW="meganucleo_wallpaper.jpg"
#WALLPAPER_FOLDER="/usr/share/backgrounds/xfce"
#WALLPAPER_FOLDER_SED="\/usr\/share\/backgrounds\/xfce"
#WALLPAPER_CONFIG_FOLDER="/home/$NEW_USER/.config/xfce4/xfce-perchannel-xml/"
#WALLPAPER_CONFIG="xfce4-desktop.xml"

##Changing root password
echo "Change Root PW"
echo root:meganucleo|chpasswd

##Erasing Desktop icons
rm -f /etc/skel/Desktop/*.desktop

##Generating locales
locale-gen "en_US.UTF-8"
locale-gen "C"
locale-gen "es_MX.UTF-8"
#export LANG=C
export LANG="es_MX.UTF-8"
export LANGUAGE="es_MX.UTF-8"
export LC_ALL="es_MX.UTF-8"
dpkg-reconfigure locales

##Creando usuario meganucleo
echo "${bold}Nuevo usuario ${yellow}${NEW_USER}${reset}"
adduser --disabled-password --gecos "" $NEW_USER
echo $NEW_USER:mega1234|chpasswd
for add_grp in \
  sudo netdev audio video dialout plugdev bluetooth
do
  usermod -aG ${add_grp} ${NEW_USER} 2>/dev/null
done

#touch /home/$NEW_USER/.Xauthority
#chown $NEW_USER:$NEW_USER /home/$NEW_USER/.Xauthority
#
###Enabling desktop environment
#if [ -f /etc/init.d/nodm ] ; then
#  sed -i "s/NODM_USER=\(.*\)/NODM_USER=${NEW_USER}/" /etc/default/nodm
#  sed -i "s/NODM_ENABLED=\(.*\)/NODM_ENABLED=true/g" /etc/default/nodm
#fi

##Changing hostname
echo "${bold}Cambiando hostname ${yellow}ciclope${DATE}${reset}"
echo "ciclope$DATE" > /etc/hostname

###Fex section
#echo "Installing custom fex" 
#fex2bin /tmp/overlay/system/cubieboard-a10-cubiescreen.fex /boot/script.bin

###Xorg configuration
#echo "Installing xorg config" 
#cp /tmp/overlay/xorg.config/10-evdev.conf /usr/share/X11/xorg.conf.d/
#cp /tmp/overlay/xorg.config/exynos.conf /usr/share/X11/xorg.conf.d/
#
###Xinput calibrator
#echo "Installing xinput_calibrator" 
#cp /tmp/overlay/xorg.config/xinput_calibrator /usr/bin
#cp /tmp/overlay/xorg.config/xinput_calibrator.1.gz /usr/share/man/man1/
#
###Install wallpaper
#echo "Installing wallpaper" 
#cp /tmp/overlay/meganucleo/$WALLPPR $WALLPAPER_FOLDER/$REPLACEW
#mkdir -p $WALLPAPER_CONFIG_FOLDER
#chown -R $NEW_USER $WALLPAPER_CONFIG_FOLDER
#cat /tmp/overlay/meganucleo/$WALLPAPER_CONFIG | sed -e "s/WREPLACEW/${WALLPAPER_FOLDER_SED}\/${REPLACEw}/" > $WALLPAPER_CONFIG_FOLDER/$WALLPAPER_CONFIG
#chown -R $NEW_USER $WALLPAPER_CONFIG_FOLDER/$wALLPAPER_CONFIG


##Cargar modulo ft5x_ts al inicio
echo "${bold}Agregar a modules ${yellow}ft5x_ts${reset}"
echo "ft5x_ts" >> /etc/modules

##Quitar la informacion del sistema
echo "${bold}Quitando informacion de sistema ${reset}"
echo "Meganucleo CICLOPE" > /etc/issue
echo "Meganucleo CICLOPE" > /etc/issue.net
echo "${bold}Cambiando motd ${reset}"
rm /etc/update-motd.d/*
echo "Bienvenido a meganucleo CICLOPE ${DATE}" > /etc/motd.tail  
echo " " >> /etc/motd.tail

###Evitar que arranquen servicios
#echo "Removing services from starting"
#systemctl disable tftpd-hpa
##proftpd.service
#systemctl disable proftpd
##nfs-kernel-server.service
##nfs-common.service
#systemctl disable nfs-kernel-server
#systemctl disable nfs-common
##snmpd.service  
#systemctl disable snmpd
##samba.service
#systemctl disable nmbd
#systemctl disable samba-ad-dc
#systemctl disable smbd

###Removing first boot
#echo "Removing first boot"
#rm /root/.not_logged_in_yet
#
###Installing firewall
#echo "Installing iptables"
#cp /tmp/overlay/meganucleo/firewall/iptables.up.rules /etc/iptables.up.rules
#cp /tmp/overlay/meganucleo/firewall/if-pre-up.d-iptables /etc/network/if-pre-up.d/iptables
#chmod +x /etc/network/if-pre-up.d/iptables

###Sobreescribiendo la config de sshd
#echo "${bold}Modificando configuracion ${yellow}sshd${reset}"
#cp /sshd_config /etc/ssh/sshd_config

###Overwritting sudoers file
#echo "Overwritting sudoers file"
#cp /tmp/overlay/meganucleo/sudoers/sudoers /etc/sudoers


###Writting xsession in meganucleo user
#echo "Writting xsession file in $NEW_USER"
#cp /tmp/overlay/xorg.config/xsession /home/$NEW_USER/.xsession
#chown $NEW_USER:$NEW_USER /home/$NEW_USER/.xsession
#
###Disabling screensaver
#echo "Disabling screensaver"
#cp /tmp/overlay/meganucleo/disableDPMS.sh /home/$NEW_USER/disableDPMS.sh
#
###Installing Ciclope-scanner.desktop
#echo "Installing Ciclope-scanner launcher in $NEW_USER"
#cp /tmp/overlay/xorg.config/Ciclope-scanner.desktop /home/$NEW_USER/Desktop
#chown $NEW_USER:$NEW_USER /home/$NEW_USER/Desktop/Ciclope-scanner.desktop
#chmod 755 /home/$NEW_USER/Desktop/Ciclope-scanner.desktop


###Installing Ciclope-pyside
#echo "Installing Ciclope-pyside"
##tar -C /home/$NEW_USER -xjvf /tmp/overlay/meganucleo/ciclope/ciclope-pyside-1.0.tar.bz2
#tar -C /home/$NEW_USER -xjvf /tmp/overlay/meganucleo/ciclope/ciclope-pyside-1.0.1.tar.bz2
#chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/ciclope-pyside


##Installing fail2ban
#apt-get install fail2ban -y
#tar -zxf /tmp/overlay/meganucleo/fail2ban/fail2ban_port2222.tar.gz -C /

##Disable rsyslog I2C error
#cp /tmp/overlay/system/rsyslog.d/01-blocklist.conf /etc/rsyslog.d/01-blocklist.conf

##Installing postgresql and python tools
echo "${bold}Actualizando e instalando ${yellow}paquetes${reset}"
apt-get install -y \
  python-psycopg2 python-pyside \
  postgresql postgresql-9.4 postgresql-client-9.4 \
  postgresql-client-common postgresql-common \
  postgresql-contrib-9.4 
