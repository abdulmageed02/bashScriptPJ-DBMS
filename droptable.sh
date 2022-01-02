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
         break;
    else
         echo "Error Dropping Table $tName"
         break;
  fi
 else 
 echo "table doesnt exist"
 fi
 done
. ./connectdb.sh $1