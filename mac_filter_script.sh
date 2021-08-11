#!/bin/bash

#Script to take 2 files FILE_MAC and FILE_VLAN (each consists of lines) and search through FILE_MAC for each value from FILE_VLAN

ARRAY_VLAN=()
FILE_VLAN="./vlan_list"
FILE_MAC="./mac_list"

while read -r line
do
        # display $line or do somthing with $line
	# printf '%s\n' "$line"
	ARRAY_VLAN+=("$line")
done <"$FILE_VLAN"


ARRAY_VLAN_LENGTH=${#ARRAY_VLAN[*]}

echo $ARRAY_VLAN_LENGTH

for (( i=0; i<$ARRAY_VLAN_LENGTH; i++ ))
do
	a=${ARRAY_VLAN[i]}
	grep "$a" ./mac_list
done
