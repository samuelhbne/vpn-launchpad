#!/bin/sh

DIR=`readlink -f $0`
DIR=`dirname $DIR`

while true; do
	echo "0     Init AWS credentials"
	echo "1     Create VPN node on AWS"
	echo "2     Check existing VPN server status..."
	echo "3     Remove the existing VPN server from AWS"
	echo "Other Exit vpn-launchpad"
	echo

	read -p 'Please select:	' choice

	if [ $choice -eq '0' ]; then
		echo "Init AWS configuration..."
		aws configure
	elif [ $choice -eq '1' ]; then
		echo "Create VPN node on AWS..."
		$DIR/../vlp-build
	elif [ $choice -eq '2' ]; then
		echo "Check existing VPN server status..."
		$DIR/../vlp-query
	elif [ $choice -eq '3' ]; then
		echo "Destory existing VPN server..."
		$DIR/../vlp-purge
	else
		echo "Exit vpn-launchpad..."
		exit 0
	fi
	echo "Done"
	echo
done
