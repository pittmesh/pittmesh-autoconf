#!/bin/ash

# HNA Internet Script
# Author: Justin Goetz
# Disable this script if you 

# Check for current HNA Annoucement

time=`date`

if [[ "$(/sbin/uci show olsrd | /bin/grep 'Hna4\[1\]')" ]]; then
   hna=true 
else
   hna=false
fi


		# Change depending on WAN Interface!
		ping -q -c2 -I eth0 8.8.8.8 > /dev/null

		if [ $? -eq 0 ]
		then
                        if [ $hna == true ];then
			   	:
			else
				/sbin/uci add olsrd Hna4
				/sbin/uci set olsrd.@Hna4[1].netaddr=0.0.0.0
				/sbin/uci set olsrd.@Hna4[1].netmask=0.0.0.0
				/sbin/uci commit olsrd
				echo "HNA Annoucement was added at $time" >> /tmp/log/hna.log				
			fi

		else

                        if [ $hna == false ];then
			   	:
			else
				/sbin/uci delete olsrd.@Hna4[1]
				/sbin/uci commit olsrd
				echo "HNA Annoucement was removed at $time" >> /tmp/log/hna.log				
			fi


		fi
