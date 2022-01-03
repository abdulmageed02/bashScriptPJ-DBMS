#!/bin/bash

while true 
do
echo -e "Enter Table Name: \c"
  read tName

  #echo $tName - $1
  if [ -f ./databases/$1/$tName ]; then
  rm ./databases/$1/$tName ./databases/$1/.$tName  2>>er.logs
    if [[ $? == 0 ]]
    then
         echo "Table Dropped Successfully"
              select x in "Drop new table?" "go to table menu"
              do
              case $REPLY in 
              1 ) . ./droptable.sh $1 ;;
              2 ) . ./connectdb.sh $1 ;;
              * ) echo "invalid choice pick again"
              esac
              done
    else
         echo "Error Dropping Table $tName"
         break;
  fi
 else 
 echo "table doesnt exist"
          select x in "Try again?" "go to table menu"
              do
              case $REPLY in 
              1 ) . ./droptable.sh $1 ;;
              2 ) . ./connectdb.sh $1 ;;
              * ) echo "invalid choice pick again"
              esac
              done
 fi
 done
 
. ./connectdb.sh $1