#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:"

servicios=("man-db" "sendmail" "systemd-timesyncd" "systemd-tmpfiles-setup" "systemd-update-utmp" "systemd-tmpfiles-setup-dev" "systemd-sysusers" "systemd-remount-fs" "systemd-fsck-root" "apt-daily")

<<COMMENT
for S in "${servicios[@]}"
do
	inactive=$(systemctl status $S | grep Active: | grep inactive)
	#echo $S $inactive
	echo "Desabling service "$S
	#######systemctl status $S
done


#Disable dhcpd.config
interfaz=$( ip a | grep 2: | cut -d":" -f 2 | cut -d" " -f 2)
echo $interfaz

interfaces_file=("\n" "auto lo" "iface lo inet loopback\n" "allow-hotplug $interfaz\n" "iface $interfaz inet static" 
			"\taddress 192.168.1.100/24" "\tnetwork 192.168.1.0" "\tbroadcast 192.168.1.255" 
			"\tgateway 192.168.1.1")
echo "Adding configuration to /etc/network/interfaces to get static ip"
for I in "${interfaces_file[@]}"
do
	empty=$(cat /etc/network/interfaces | grep "$I")
	if [ ! -z "empty" ];
	then
		echo -e $I >> /etc/network/interfaces
	fi

done
echo "Disabling dhcpcd.service"
#########systemctl status dhcpcd
COMMENT

#Disabling Kermel Modules
modulos=("ip_tables" "fixed" "uio_pdrv_genirq" "i2c_bcm2835" "snd_bcm2835" "bcm2835_v4l2" 
		"bcm2835_isp" "raspberrypi_hwmon" "vc_sm_cma" "vc4")
BLACKLIST="/etc/modprobe.d/blacklist.conf"
if [ ! -f $BLACKLIST ]
then
	echo "" >> $BLACKLIST
fi

for M in "${modulos[@]}"
do
	##AÑADIR MODULOS A /ETC/MODPROBE.D/BLACKLIST.CONF
	echo -e $M >> $BLACKLIST
done

<<COMMENT
#Config /boot/config.txt
config=$(cat /boot/config.txt)
cambios=("disable-splash=1" "dtoverlay=disable-bt" "boot_delay=0")
#Disable rainbow screen
#Disable bluetooth connection
#Set to 0 delay on boot
for C in "${cambios[@]}"
do
	empty=$(echo $config | grep $C)
	if [ -z "$empty" ];
	then
		echo $C >> /boot/config.txt
		echo "Added "$C "to /boot/config.txt"
	fi

done

#Config /boot/cmdline.txt
cmdline=$(cat /boot/cmdline.txt)
slash=$(cat /boot/cmdline.txt | grep slash)
cmdline_result=()
quite=$(cat /boot/cmdline.txt | grep quite)
#echo $quite
#Si no esta quite ya añadido
if [ -z "$quite" ];
then
	if [ ! -z "$slash"];
	then
		#SLASH existe por lo que hay que borrarlo y añadir quite
		#Con esto se elimina el texto que aparece en la pantalla de boot
		echo no null
		for I in $(seq 1 $(echo $cmdline | wc -w))
		do
			word=$(echo $cmdline | cut -d " " -f$I)
			#echo $word
			if [ $word != "slash" ]
			then
				cmdline_result="${cmdline_result} ${word}"
				#echo $cmdline_result
			else
				echo "Remove slash from /coot/cmdline.txt"
			fi
		done

		cmdline_result="${cmdline_result} quite"
		echo $cmdline_result > /boot/cmdline.txt
	else

		cmdline_result="${cmdline} quite"
		echo $cmdline_result > /boot/cmdline.txt

	fi
	echo "Added quite to /coot/cmdline.txt"
fi
COMMENT
