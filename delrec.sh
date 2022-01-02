#!/bin/bash

while true 
do
echo "enter the table name "
read name 
if [[ -f ./databases/$1/$name ]]; then

while [ true ]
do 

echo "enter the record id number"
read num
let num=$num+1   # --> 34an awl record dh el shayl el colnames
#rn=`wc -l ~/database/test`
rn=`awk 'END { print NR } ' ./databases/$1/$name`

if [ $num -gt 0 -a $num -le $rn ];
         then
            sed -i "$num"d ./databases/$1/$name
            echo "Record Deleted !"
            sleep 3
            . ./connectdb.sh
        else 
            echo " That Record Doesn't exist";
        fi
        done

else
    echo 'table doesnt exist'
fi
done


