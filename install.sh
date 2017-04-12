#!/bin/bash

###
# Install helper for nejack_pifmrds
# Yes, quick'n'dirty :)
###

DEP="jackd2 sox jack-stdio netcat"


## init

UNINSTALL=false
INSTALL=false
APT_DEP=false

while [[ $# -gt 0 ]]
do
	key="$1"
#	echo $1
		case $key in
			-u|--uninstall)
			UNINSTALL=true
			
			;;
			-i|--install)
			INSTALL=true
			
			;;
			-d|--dependency)
			APT_DEP=true
			
			;;
		esac
	shift
done

## Process
#echo $INSTALL
#echo $UNINSTALL
#echo $APT_DEP


if $UNINSTALL
then
	systemctl stop netjack_pifmrds
	systemctl disable netjack_pifmrds

	rm /usr/local/bin/pi_fm_rds
	rm /usr/local/bin/netjack_pifmrds
	rm /etc/systemd/system/nejack_pifmrds.service

	if $APT_DEP
	then
		apt -y remove $DEP
	fi

elif $INSTALL
then
	if $APT_DEP
	then
		apt update
		apt -y install $DEP
	fi
	
	cp ./pi_fm_rds /usr/local/bin
	cp ./netjack_pifmrds.sh /usr/local/bin/netjack_pifmrds
	cp ./netjack_pifmrds.service /etc/systemd/system
	
	systemctl enable netjack_pifmrds
	systemctl start netjack_pifmrds

else
	echo "Usage :"
	echo "sudo install.sh [-i|--install] [-u|--uninstall] [-d|--dependency]"
fi
