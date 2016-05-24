#!/bin/ash
#
# © 2016 Meta Mesh Wireless Communities. All rights reserved.
# Licensed under the terms of the MIT license.
#
# AUTHORS
# * Jason Khanlar
#

# Check for --list-all, otherwise proceed

while getopts ":-:" opt; do
    if [ $OPTARG = "list-all" ]; then
        mac1=DC
        mac2=9F
        mac3=DB
        mac4=00
        mac5=00
        mac6=00

        ip1=100
        ip2=64
        ip3=0
        ip4=0

        for ip2 in `seq 0 255`;do
            mac4=$(printf "%02X\n" $ip2)

            ip2=$(expr $ip2 % 64 + 64)

            # Format IP address
            ip="$ip1.$ip2.$ip3.$ip4"

            # Format MAC address
            mac="$mac1:$mac2:$mac3:$mac4:$mac5:$mac6"

            # Pad with space
            space=`printf '%*s' "$((15 - ${#ip}))"`

            # Output matching IP address and MAC address
            echo "$ip $space=> $mac"
        done

        exit
    fi
done

# Proceed if not --list-all

# Get # of arguments passed to this script
args=$#

# # of arguments should be 1 or 6
# 1 -> DC:9F:DB:CE:13:57 -or- DC-9F-DB-CE-13-57
# 6 -> DC 9F DB CE 13 57

if [ $args -eq 1 -a ${#1} -eq 17 ]; then
    # Split 1 argument into 6 separate arguments, 1 for each octet
    # and pass the 6 arguments to a new instance of this script
    $0 `echo $1 | tr ":-" " "`
    # After the new instance completes, make sure to end this one
    exit 0
elif [ $args -eq 6 ]; then
    mac1=$(echo $1|tr '[a-z]' '[A-Z]')
    mac2=$(echo $2|tr '[a-z]' '[A-Z]')
    mac3=$(echo $3|tr '[a-z]' '[A-Z]')
    mac4=$(echo $4|tr '[a-z]' '[A-Z]')
    mac5=$(echo $5|tr '[a-z]' '[A-Z]')
    mac6=$(echo $6|tr '[a-z]' '[A-Z]')
else
    echo "Usage: $0 <MAC address>"
    echo "Usage: $0 --list-all"
    echo
    echo "examples:"
    echo "  $0 DC:9F:DB:CE:13:57"
    echo "  $0 DC-9F-DB-CE-13-57"
    echo "  $0 DC 9F DB CE 13 57"
    echo "  $0 dc 9f db ce 13 57"
    exit 1
fi

# Ensure nothing

# Convert last three hexadecimal octets to decimal values
ip1=100
ip2=$(printf "%d" "0x$mac4")
ip3=$(printf "%d" "0x$mac5")
ip4=$(printf "%d" "0x$mac6")

ip2=$((ip2%64 + 64))

echo "$ip1.$ip2.$ip3.$ip4"
