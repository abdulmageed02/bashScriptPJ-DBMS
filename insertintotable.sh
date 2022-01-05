#!/bin/bash

echo -e "Table Name: "
read tblname
if ! [[ -f ./databases/$1/$tblname ]]; then
  echo "Table $tblname isn't existed "
  select x in "insert another Table" "go to table menu"; do
    case $REPLY in
    1) . ./insertintotable.sh $1 ;;
    2) . ./connectdb.sh $1 ;;
    *) echo"invalid choice pick again " ;;
    esac
  done
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

  if [[ $coltype == "int" ]]; then
    while true; do
      case $data in

      +([0-9]))
        if [[ "$colKey" == "PK" ]]; then
          duplicated=0
          while [[ true ]]; do
            if [[ -z "$data" ]]; then
              echo -e "\n Error!PK can't be NULL !"
              read -p "Enter valid Primary key $colname (int) = " data

            elif
              ! [[ $data =~ ^[1-9][0-9]*$ ]]
            then

              read -p "Enter valid data type $colname (int) = " data

            else
              duplicated=$(awk -F'|' '{if('$data'==$('$i'-1)) {print $('$i'-1);exit}}' ./databases/$1/$tblname)
              if ! [[ $duplicated -eq 0 ]]; then
                echo "Error!PK already exists"
                read -p "Enter unique Primary key $colname (int) = " data
                duplicated=0
              else
                break
              fi
            fi
          done
        fi
        #######
        break
        ;;
      *)
        read -p "Enter valid Value pls, $colname (int)= " data
        ;;
      esac
    done
  fi

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

select x in "insert new data" "go to table menu"; do
  case $REPLY in
  1) . ./insertintotable.sh $1 ;;
  2) . ./connectdb.sh $1 ;;
  *) echo "invalid choice pick again" ;;
  esac
done
