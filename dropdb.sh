#!/bin/bash
while [ true ]
do 
echo "enter the database name"
read dbname

if [ -d ./databases/$dbname ];
         then
            rm -r ./databases/$dbname  
            echo "Deleted !";
            sleep 1.5
            . ./maindb.sh
        else 
            echo "$dbname database Doesn't exist"
            sleep 1.5
            select c in "go back to main menu " "try again"
            do
            case $REPLY in
            1 ) . ./maindb.sh ;;
            2 ) . ./dropdb.sh ;;
            esac
            done
        fi
done

 

