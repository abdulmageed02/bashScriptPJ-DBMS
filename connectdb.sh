#!/bin/bash
PS3= 'Make your choice> ' 2>/dev/null

while [ true ]
do 
if [[ $# == 0 ]];then
    echo "enter the database name"
    read dbname
    else
    dbname=$1
    fi  

if [ -d ./databases/$dbname ];
         then
            echo " current database is $dbname"
            select choice in 'Create table' 'List tables' 'insert into table' 'Drop table' 'select & update/delete from table' 'list table data'  'choose another database' 'go to main menu'
            do
            case $REPLY in
            1 ) . ./CreateTable.sh $dbname
            ;;
            2 )  ls databases/$dbname
            ;;
            3 ) . ./insertintotable.sh $dbname
            ;;
            4 ) . ./droptable.sh $dbname
            ;;
            5 ) . ./selectrec.sh $dbname
            ;;
            6 ) . ./listtabledata.sh $dbname
            ;;
            9 ) . ./connectdb.sh
            ;;
            10 ) . ./maindb.sh
            ;;
            * ) echo "invalid choice, pick again please ";;
            esac
            done
        
        else 
            echo "$name database Doesn't exist"
            sleep 3
            . ./maindb.sh
        fi
        done
