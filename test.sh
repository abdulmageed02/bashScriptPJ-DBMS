#!/bin/bash

while [ true ]
do
tput setaf 2; echo "enter the table name "
read name 

    while [ true ]
    do 
    FILE=./databases/$1/$name
        if [ -f $FILE ];
         then
        tput setaf 2; echo "Please enter Record id  " # Ask for col name hna , after it use awk to check on first record col name if there is a match move on if not ask for anew col name 
        
        read  id  
        let id=$id+1   # awl record shayl el col name
        rn=`awk 'END { print NR } ' ./databases/$1/$name`

         if [ $id -gt 0 -a $id -le $rn ];
         then
         tput setaf 2;echo "The Record selected : "
         sed -n "$id"p ./databases/$1/$name 
         select choice in 'enter new record' 'go back to table menu' 
         do
         case $REPLY in 
        1 ) break ;;
        2 ) . ./connectdb.sh $1 ;break;;
        * ) tput setaf 1;echo " pick 1 or 2 please" ;;
        esac
        done
        else 
            tput setaf 1;echo " That Record Doesn't exist";
       fi
      else 
      tput setaf 1; echo "that table doesn't exist"      
            continue 2;   
        fi
        done
	break ;
done
