#!/bin/bash

## Define all parameters
#Audio fromat of your net master instance
RATE=44100

#Radio parameters
FREQ=98.0
PS="OND-CRT" #8 char max
RT="Radio Ondes Courtes" #64 char max


cleanup()
{
	echo "kill en cours"
	sudo kill $PIPE_PID
	sleep 1
	kill $JACK_PID
	sleep 1
	echo "Transmition terminée"
}

trap 'cleanup; exit' SIGINT SIGTERM


jackd -d net &
JACK_PID=$!
sleep 1
jack-stdout -q system:capture_1 system:capture_2 | sox -r $RATE -b 16 -c 2 -e signed -t raw - -t wav - | sudo ~/PiFmRds/src/pi_fm_rds -freq $FREQ -rt "$RT" -ps "$PS" -audio - &
PIPE_PID=$!

echo " jack_pid=$JACK_PID et pipe_pid=$PIPE_PID"
while :
do
	sleep 60
done
