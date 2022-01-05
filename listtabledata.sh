#!/bin/bash

while [ true ]; do
    echo "enter the table name "
    read tblname

    if [[ -f ./databases/$1/$tblname ]]; then
        # awk 'BEGIN{FS="|"} {print $0} ' ./databases/$1/$tblname
        column -t -s '|' ./databases/$1/$tblname
        . ./connectdb.sh
    else
        echo 'table doesnt exist'
        select choice in 'List new Table?' 'go back to table menu'; do
            case $REPLY in
            1) break ;;
            2) . ./connectdb.sh $1 ;;
            *) echo " invalid choice, pick again please" ;;
            esac
        done

    fi
done
