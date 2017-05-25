#!/bin/bash

## 

#### Dependencies : ####
## piFmRds [https://github.com/ChristopheJacquet/PiFmRds]
## netcat
## jackd2
## jack-stdout
## sox
####

#### Usage : ####
## Launch this script
## Create a netjack master on the network
## Send some sound
##  -- Enjoy your FM radio !
## Send piFmRds rds update commands to [pi-IP]:16123 via netcat
##  -- Enjoy your rds text !

## Define all parameters
#Audio fromat of your net master instance
#RATE=44100 # Now grabbed from netjack

#Radio parameters
FREQ=107.7
PS="INIT" #8 char max
RT="Netjack-PiFm on $HOSTNAME Up&Workin" #64 char max
NC_RDS_PORT=16123

#PiFmRds path :
PIFM=/home/pi/PiFmRds/src/pi_fm_rds


cleanup()
{
	echo "kill en cours"
#	sudo kill $PIPE_PID
#	sleep 1
#	kill $JACK_PID
#	sleep 1
	kill $NC_PID
	sleep 1
	killall jackd
	rm /tmp/rds_ctl
	echo "Transmition terminée"
}


init()
{
	trap 'cleanup; exit 0' SIGINT SIGTERM
	mkfifo /tmp/rds_ctl
	nc -l -p $NC_RDS_PORT > /tmp/rds_ctl &
	NC_PID=$!
	#jackd -d net -l 2 2> /dev/null; echo "Jackd PID: "$! | tee -a ~/.log/jack/jackpifm.log | grep --line-buffered "Master name :" | while read line; do
	
	trap 'cleanup; exit 0' SIGINT SIGTERM
	while true; do
		run
		echo "Somthing is wrong here... retry in 10 sec"
		sleep 10
	done

	echo "This is the end, my only friend ..."
	cleanup
	
	exit 1
}


run()
{
	echo "Starting jack"
#	jackd -d net -l 2 2>/dev/null | tee -a ~/.log/jack/jackpifm.log | grep --line-buffered "Master name :" | while read line; do
	jackd -d net -l 4 -P 2 -C 0 2>/dev/null | tee -a /var/log/jackpifm.log | grep --line-buffered "Sample rate : " | grep --line-buffered -o [[:digit:]]* | while read RATE; do
#		echo $line
		#sleep 1
		#jack_samplerate 2> /dev/null
		echo "Samplerate : "
		echo $RATE
		sleep 1
		jack-stdout -q system:capture_1 system:capture_2 | sox -r $RATE -b 16 -c 2 -e signed -t raw - -t wav - | $PIFM -freq $FREQ -rt "$RT" -ps "$PS" -ctl /tmp/rds_ctl -audio -
		killall jackd
	done

}


trap 'cleanup; exit 0' SIGINT SIGTERM
init




