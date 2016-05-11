#!/bin/ash
#
# © 2016 Meta Mesh Wireless Communities. All rights reserved.
# Licensed under the terms of the MIT license.
#
# AUTHORS
# * Jason Khanlar
#
# DESCRIPTION
# - Outputs total number of stations connected to all network devices of a node

# http://mywiki.wooledge.org/BashFAQ/024
count=0
iw dev | \
grep Interface | \
{
  while IFS= read -r line;do
    dev="$(echo $line|cut -d " " -f 2)"
    stations="$(iw dev $dev station dump|grep Station|wc -l)"
    count=$(expr $count + $stations)
  done
  cat $count
}
