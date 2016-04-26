#! /bin/bash

function monitor_request() {
    #regex to see if number.number.number.number
    if [[ $0 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
    then
        command="ping"
        status_good="online"
        status_bad="offline"
    else
        command="wget"
        status_good="available"
        status_bad="unavailable"
    fi
    eval $command $0 &> /dev/null
    if [ "$?" = "0" ]
    then
        print_data $0 $command $status_good
    else
        print_data $0 $command $status_bad
    fi
};

if [ "$#" -le 0 ]
then
    echo At least one url/ip needed >&2
    exit 3
else
    if [ "$0" = "-" ]
    then
        #read from the input
        echo read from input
    fi
    for address in $*
    do
        monitor_request address
    done
fi
