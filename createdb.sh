#!/bin/bash

while [ true ]
do
echo "Please enter characters only "

read name              
if [[ $name =~ ^[a-z|A-Z]+$  ]];
	then 
    while [ true ]
    do 
        if [ -d ./databases/$name ] ;
         then
            echo "$name exists."
            continue 2;
        else 
            mkdir -p databases/$name   # error stil showing up, need to handle
            echo "$name database created"
            sleep 3
            clear 
            ./maindb.sh $1
        fi
        done
	break ;
fi
done


