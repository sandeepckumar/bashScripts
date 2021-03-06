#!/bin/bash

###################################################################
#Script Name	:   swap.sh                                                                                           
#Description	:   Toggles swap (Executes only when there is enough free memory)                                                                              
#Args           :   -none-                                                                                       
#Author       	:   Sandeep C Kumar                                                
#Email         	:   sandeepkchenna@gmail.com                                           
###################################################################

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

curr_mem=$(free)
mem_avail="$(echo "$curr_mem" | grep 'Mem:')"
free_mem="$(echo "$mem_avail" | awk '{print $4}')"
cache="$(echo "$mem_avail" | awk '{print $7}')"
buff="$(echo "$mem_avail" | awk '{print $6}')"
total_avail=$((free_mem + cache + buff))
used_swap="$(echo "$curr_mem" | grep 'Swap:' | awk '{print $3}')"

echo "================================================"

echo -e "${YELLOW}Free memory : $total_avail kB $((total_avail / 1024)) MB
  Used swap : $used_swap kB $((used_swap / 1024)) MB${ENDCOLOR}"

echo "================================================"

if [[ $used_swap -eq 0 ]]; then
    echo -e "${GREEN}Swap is not in use.${ENDCOLOR}"
elif [[ $used_swap -lt $total_avail ]]; then
    echo -e "${GREEN}Clearing swap... Please be patient${ENDCOLOR}"
    swapoff -a
    swapon -a
else
    echo -e "${RED}Error: Not enough memory to swap.${ENDCOLOR}"
    exit 1
fi