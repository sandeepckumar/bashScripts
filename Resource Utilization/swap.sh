#!/bin/bash

###################################################################
#Script Name	:   swap.sh                                                                                           
#Description	:   Prints swap utlization of all running process and sorts with given args.                                                                              
#Args           :   pid (default) | kb | name                                                                                        
#Author       	:   Sandeep C Kumar                                                
#Email         	:   sandeepkchenna@gmail.com                                           
###################################################################

SCRIPT_NAME=`basename $0`;

SORT="kb"; # first parameter {pid|kb|name}, default : kb

[ "$1" != "" ] && { SORT="$1"; }

[ ! -x `which mktemp` ] && { echo "ERROR: mktemp not installed!"; exit; }

MKTEMP=`which mktemp`;
TMP=`${MKTEMP} -d`;

[ ! -d "${TMP}" ] && { echo "ERROR: creating temp dir failed!"; exit; }

>$TMP/${SCRIPT_NAME}.pid;
>$TMP/${SCRIPT_NAME}.kb;
>$TMP/${SCRIPT_NAME}.name;

SUM=0;
OVERALL=0;

echo "${OVERALL}" > ${TMP}/${SCRIPT_NAME}.overall;
echo;
echo -n "Processing.."

for DIR in `find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+"`; do
    PID=`echo $DIR | cut -d / -f 3`
    PROGNAME=`ps -p $PID -o cmd --no-headers | cut -c1-100`

    for SWAP in `grep Swap $DIR/smaps 2>/dev/null | awk '{ print $2 }'`; do 
        let SUM=$SUM+$SWAP
        done

    if (( $SUM > 0 )); then 
        echo -n ".";
        echo -e "${PID}\t${SUM}\t${PROGNAME}" >> ${TMP}/${SCRIPT_NAME}.pid;
        echo -e "${SUM}\t${PID}\t${PROGNAME}" >> ${TMP}/${SCRIPT_NAME}.kb;
        echo -e "${PROGNAME}\t${SUM}\t${PID}" >> ${TMP}/${SCRIPT_NAME}.name;
    fi

    let OVERALL=$OVERALL+$SUM
    SUM=0
done

echo;

echo "${OVERALL}" > ${TMP}/${SCRIPT_NAME}.overall;
echo;
echo "Overall swap usage: ${OVERALL} KB";
echo "==================================================";
case "${SORT}" in 
    name )
        echo -e "name\tkb\tpid";
        echo "==================================================";
        cat ${TMP}/${SCRIPT_NAME}.name | sort -r;
        ;;
    kb )
        echo -e "kb\tpid\tname";
        echo "==================================================";
        cat ${TMP}/${SCRIPT_NAME}.kb | sort -rh;
        ;;
    pid | * )
        echo -e "pid\tkb\tname";
        echo "==================================================";
        cat ${TMP}/${SCRIPT_NAME}.pid | sort -rh;
        ;;
esac;
echo;

rm -rf "${TMP}/"