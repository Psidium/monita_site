#! /bin/bash

function print_data() {
   echo $1 $2 $3 | column -t -s "      "
}

function monitor_request() {
    #regex to see if number.number.number.number
    if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
    then
        command="ping -c 4"
        status_good="online"
        status_bad="offline"
    else
        command="wget"
        status_good="available"
        status_bad="unavailable"
    fi
    eval $command $1 &> /dev/null
    if [ "$?" = "0" ]
    then
        print_data $1 $(echo $command | awk '{ print $1}') $status_good
    else
        print_data $1 $(echo $command | awk '{ print $1}') $status_bad
    fi
};

if [ "$#" -le 0 ]
then
    echo At least one url/ip needed >&2
    exit 3
else
    args=$*
    if [ "$1" = "-" ]
    then
        #read from the input
        args=""
        while read line; do
            args="$args $line"
        done < /dev/stdin
    fi
    for address in $args
    do
        monitor_request $address
    done
fi
