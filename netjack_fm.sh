#!/bin/bash

## TODO : wait for netjack master to launch the pipe

#### Dependencies : ####
## piFmRds [https://github.com/ChristopheJacquet/PiFmRds]
## netcat
## jackd2
## jack_stdout
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
#RATE=44100

#Radio parameters
FREQ=107.7
PS="INIT" #8 char max
RT="Netjack-PiFm on $HOSTNAME Up&Workin" #64 char max


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
	nc -l -p 16123 > /tmp/rds_ctl &
	NC_PID=$!
	echo "Starting jack"
	#jackd -d net -l 2 2> /dev/null; echo "Jackd PID: "$! | tee -a ~/.log/jack/jackpifm.log | grep --line-buffered "Master name :" | while read line; do
	jackd -d net -l 2 2> /dev/null | tee -a ~/.log/jack/jackpifm.log | grep --line-buffered "Master name :" | while read line; do
	  echo $line
	  sleep 1
	  jack_samplerate
	  echo "running ..."
	  run < /dev/null
	done
	
	#while read line; do
	#	echo "$line"
	#	run
	#done  # < (jackd -d net -l 2 | tee -a ~/.log/jack/jackpifm.log | grep "Master name :")
	
	#JACK_PID=$!
	#sleep 1
}


run()
{
	trap 'cleanup; exit 0' SIGINT SIGTERM
	jack_samplerate 2> /dev/null
	#RATE=$(jack_samplerate)
	#echo $RATE
	jack-stdout -q system:capture_1 system:capture_2 | sox -r $RATE -b 16 -c 2 -e signed -t raw - -t wav - | ~/PiFmRds/src/pi_fm_rds -freq $FREQ -rt "$RT" -ps "$PS" -ctl /tmp/rds_ctl -audio -

}


trap 'cleanup; exit 0' SIGINT SIGTERM
init




