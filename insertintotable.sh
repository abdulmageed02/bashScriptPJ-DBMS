#!/bin/bash

echo -e "Table Name: "
read tblname
if ! [[ -f ./databases/$1/$tblname ]]; then
  echo "Table $tblname isn't existed ,choose another Table" # need to be added in while loop
  sleep 2
  . ./connectdb.sh $1
fi

coln=$(awk 'END{print NR}' ./databases/$1/.$tblname)
sep="|"
lsep="\n"

for ((i = 2; i <= $coln; i++)); do

  colname=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' ./databases/$1/.$tblname)
  coltype=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' ./databases/$1/.$tblname)
  colKey=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' ./databases/$1/.$tblname)
  echo -e "$colname ($coltype) = "
  read data

  # Validate Input

  # int validation
  #function intcheck {
  if [[ $coltype == "int" ]]; then
    while true; do
      case $data in

      +([0-9]))
        if [[ "$colKey" == "PK" ]]; then
          duplicated=0
          while [[ true ]]; do
            if [[ -z "$data" ]]; then
              echo "Error!PK can't be NULL !"
              read -p "Enter valid Primary key" data

            elif
              ! [[ $data =~ ^[1-9][0-9]*$ ]]
            then
              echo -e "ErrorInvalid data type!  "
              read -p "Enter valid data type" data

            else
              duplicated=$(awk -F'|' '{if('$data'==$('$i'-1)) {print $('$i'-1);exit}}' ./databases/$1/$tblname)
              if ! [[ $duplicated -eq 0 ]]; then
                echo "Error!PK already exists"
                read -p "Enter unique Primary key" data
                duplicated=0
              else
                break
              fi
            fi
          done
        fi
        break
        ;;
      *)
        echo "Error! Invalid data type!"
        read -p "enter valid data type (int)" data
        ;;
      esac
    done
  fi

  #}
  #intcheck
  #String Validation
  #function strcheck {
  if [[ $coltype == "string" ]]; then
    while ! [[ $data =~ ^[a-z|A-Z]+$ || -z $data ]]; do
      echo -e "invalid DataType !!"
      echo -e "$colname ($coltype) = \c"
      read data
    done
  fi

  #strcheck

  # Primary key validation
  #function pkcheck {

  #inserting rows into database
  if [[ $i == $coln ]]; then
    row=$row$data
  else
    row=$row$data$sep
  fi
done
# end of for loop!

echo -e $row >>./databases/$1/$tblname
if [[ $? == 0 ]]; then # check on the process of entering rows
  echo "Data Inserted Successfully"
else
  echo "Error Inserting Data into Table $tblname"
fi
row=""
echo "going to table menu"

select x in "insert new data" "go to table menu"; do
  case $REPLY in
  1) . ./insertintotable.sh $1 ;;
  2) . ./connectdb.sh $1 ;;
  *) echo"invalid choice pick again" ;;
  esac
done
