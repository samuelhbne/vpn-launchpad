#!/bin/bash

RESOURCE="vpngroup"
VM="vpnserver"
VLPHOME="$HOME/.vpn-launchpad"

echo "Cleaning up "
#Delete the resource group and vm
echo "Deleting $VM....."
az vm delete -n $VM -g $RESOURCE -y
echo "Deleting resource group $RESOURCE....."
az group delete -n $RESOURCE -y

cd ~/.ssh
rm -rf *
rm -rf $VLPHOME
