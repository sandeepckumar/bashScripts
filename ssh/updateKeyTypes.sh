#!/bin/bash

###################################################################
#Script Name	:   updateKeyTypes.sh                                                                                           
#Description	:   Updates sshd config with given public key types                                                                              
#Args           :   path to the config file |Keytype                                                                                       
#Author       	:   Sandeep C Kumar                                                
#Email         	:   sandeepkchenna@gmail.com                                           
###################################################################

CONF=$1
KEY=$2
PATTERN="PubkeyAcceptedKeyTypes"
LKEY=`echo $KEY | tr '[:upper:]' '[:lower:]'`

[ "$1" != "" ] && { CONF="$1"; }
[ "$2" == "" ] && { echo "Error: keytype is missing!"; exit 1; }
[ ! -f "$CONF" ] && { echo "ERROR: file doesn't exist!"; exit 1; }

STR=`grep -i $PATTERN $CONF`

if [[ "$STR" != *"$LKEY" ]]; then
    sed "/^$PATTERN/s/$/,$LKEY/" $CONF && { echo "SUCESS: the key $LKEY has been added to the file."; exit 0; }
else
    echo "WARN: provided key is already present in the file.";
fi 










