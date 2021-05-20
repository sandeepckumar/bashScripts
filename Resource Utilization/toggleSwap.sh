#!/bin/bash

###################################################################
#Script Name	:   swap.sh                                                                                           
#Description	:   Toggles swap (Executes only when there is enough free memory)                                                                              
#Args           :   -none-                                                                                       
#Author       	:   Sandeep C Kumar                                                
#Email         	:   sandeepkchenna@gmail.com                                           
###################################################################

curr_mem=$(free)
mem_avail="$(echo "$curr_men" | grep 'Mem:')"
free_mem="$(echo $mem_avail | awk '{print $4}')"
cache="$(echo $mem_avail | awk '{print $7}')"
buff="$(echo $mem_avail | awk '{print $6}')"
total_avail=$((free_mem + cache + buff))
used_swap="$(echo "$curr_mem" | grep 'Swap:' | awk '{print $3}')

echo -e "Total Free memory:\t$total_avail kB $((total_free / 1024)) MB\nUsed swap:\t$used_swap kB $((used_swap / 1024)) MB"

if [[ $used_swap -eq 0 ]]; then
    echo "Swap is not in use."
elif [[ $used_swap -lt $total_avail ]]; then
    echo "Clearing swap... Please be patient"
    swapoff -a
    swapon -a
else
    echo "Error: Not enough memory to swap."
    exit 1
fi