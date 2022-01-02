#!/bin/bash

while [ true ]
do
echo "enter the table name "
read tblname 

if [[ -f ./databases/$1/$tblname ]]; then
   # awk 'BEGIN{FS="|"} {print $0} ' ./databases/$1/$tblname
   column -t -s '|' ./databases/$1/$tblname
    . ./connectdb.sh
    else
    echo 'table doesnt exist'
    fi
done

