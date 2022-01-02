#!/bin/bash


  echo -e "Table Name: "
  read tblname
  if ! [[ -f ./databases/$1/$tblname ]]; then
    echo "Table $tblname isn't existed ,choose another Table"  # need to be added in while loop 
    sleep 2
    . ./connectdb.sh $1
  fi

  coln=`awk 'END{print NR}' ./databases/$1/.$tblname`
  sep="|"
  lsep="\n"

  for (( i = 2; i <= $coln; i++ )); do 
    
    colname=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' ./databases/$1/.$tblname)
    coltype=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' ./databases/$1/.$tblname)
    colKey=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' ./databases/$1/.$tblname)
    echo -e "$colname ($coltype) = \c" 
    read data

      # Validate Input
    if [[ $coltype == "int" ]]; then
     while ! [[ $data =~ ^[0-9]*$ || -z $data  ]]; do
       echo -e "invalid DataType !!"
        echo -e "$colname ($coltype) = \c"
       read data
      done
   fi

    if [[ $coltype == "string" ]]; then
     while ! [[ $data =~ ^[a-z|A-Z]+$ || -z $data ]]; do
       echo -e "invalid DataType !!"
        echo -e "$colname ($coltype) = \c"
       read data
      done
   fi

  # if [[ $colKey == "PK" ]]; then  #yet to handle 


##############################



    #inserting data as rows
    if [[ $i == $coln ]]; then
      row=$row$data
    else
      row=$row$data$sep
    fi
  done # end of for loop!

  echo -e $row >> ./databases/$1/$tblname
  if [[ $? == 0 ]] # check on the process of entering rows 
  then
    echo "Data Inserted Successfully"
  else
    echo "Error Inserting Data into Table $tblname"
  fi
  row=""
  echo "going to table menu" 
  sleep 2
  # make case to insert new data or go back 
  . ./connectdb.sh
