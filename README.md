# netjack_pifm
TL;DR; script to route netjack audio to PiFmRds

It allow to automate jack, sox & pifmrds lauch when a netajck master is found. So you can just lauch the script (in few times, just boot your PI) and load a netjack master on the network to send your sond over air and play with RDS !

For educational purpose only, sure. Do NO hack radio frequencies, okay ? It's bad. Very bad.

# Dependencies :
* piFmRds [https://github.com/ChristopheJacquet/PiFmRds] under GPLv3. I've inclued here the binary for easy deployement.
* netcat
* jackd2
* jack_stdout
* sox
* bash

# How to
On your PI :
* git clone this repo
* cd netjack_pifm
* ./netajack_fm.sh

OR

* git clone this repo
* cd netjack_pifm
* sudo ./install.sh -i -d # This will be install this script, dependencies and enable the systemd service

On your other computer :
* Start your jack server (eg with $jack_control start)
* start the netjack master (eg with $jack_control iload netmanager)
* put some sound in the "piFm" jack client.
* ????
* Enjoy !

For change RDS info :
* read the PiFmRds doc
* use NetCat for transmit theses commands to your pi, default port 16123. You can find the pi's ip in the jack logs ;)
