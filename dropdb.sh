#!/bin/bash



while [ true ]
do 
ls databases
echo "enter the database name"
read dbname

if [[ -d ./databases/$dbname && ! -z $dbname ]];
         then
            rm -r ./databases/$dbname  
            echo "database Deleted !";
            select c in "go back to main menu" "exit"
            do
            case $REPLY in
            1 ) . ./maindb.sh ;;
            2 ) exit ;;
            esac
            done

        else 
            echo "$dbname database Doesn't exist"
            select c in "go back to main menu " "try again"
            do
            case $REPLY in
            1 ) . ./maindb.sh ;;
            2 ) . ./dropdb.sh ;;
            esac
            done
        fi
done

 

