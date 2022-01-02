#!/bin/bash
while [ true ]
do 
echo "enter the database name"
read name
FILE= ./databases/$name
if [ -d $FILE ];
         then
            rm -r ./databases/$name 2> /dev/null ; # still gives error thats its a directory need to be handled
            echo "Deleted !";
            break;
        else 
            echo "$name database Doesn't exist"
        fi
        done

 

