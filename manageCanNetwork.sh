#!/bin/bash
case $1 in
	start)
		echo "start"
		/sbin/ip link set can0 up type can bitrate 250000
		/sbin/ip link set can1 up type can bitrate 250000
		;;
	reload)
		echo "reload"
		/sbin/ip link set can0 down 
		/sbin/ip link set can1 down
		/sbin/ip link set can0 up type can bitrate 250000
		/sbin/ip link set can1 up type can bitrate 250000
		;;
	stop)
		echo "stop"
		/sbin/ip link set can0 down
		/sbin/ip link set can1 down
		;;
*)
		echo "erreur"
		;;
esac
