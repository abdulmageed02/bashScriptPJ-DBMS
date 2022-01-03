#!/bin/bash

shopt -s extglob
export LC_COLLATE=C

while true
do
  
    echo "Enter table name: " 
    read tblname   
    if [[ $tblname =~ ^[a-z|A-Z]+$ ]]; then
            if [[ -f ./databases/$1/$tblname ]]; then
                 echo "table already existed choose another name"
                 # rg3o 3la el table menu  #lsa h3mlo 
                 . ./connectdb.sh $1
                 continue;
             fi
    else 
        continue;
    fi
while true
do
echo "how many cols is your table? "
read coln
  if [[ $coln =~ ^[0-9]$ ]]; then
  break;
  fi
done
counter=1
PK=""
sep="|"
lsep="\n"
hdata="ColName"$sep"Type"$sep"key"

    while [ $counter -le $coln ]
    do
        while true 
        do
        echo "Col No $counter name:"
        read colname
        if [[ $colname =~ ^[a-z|A-Z]+$ ]]; then
        break;
        fi
        done

        echo "Col No $counter Type:"
        select T in "int" "string"
        do
             case $T in 
                int ) coltype="int";break ;;
                string ) coltype="string";break ;;
                * ) echo "invalid choice, pick again" ;;
            esac
        done

        if [[ $PK == "" ]]; then
            echo -e "Make this col a PrimaryKey ? "
            select var in "yes" "no"
            do
            case $var in
             yes ) PK="PK";
             hdata+=$lsep$colname$sep$coltype$sep$PK;
             break;;
             no )
             hdata+=$lsep$colname$sep$coltype$sep""
              break;;
             * ) echo "Wrong Choice, pick again" ;;
            esac
            done
        else
            hdata+=$lsep$colname$sep$coltype$sep""
        fi
        if [[ $counter == $coln ]]; then
         temp=$temp$colname
        else
          temp=$temp$colname$sep
        fi
        let counter++
    done
  #touch ./databases/$1/.$tblname
  echo -e $hdata  >> ./databases/$1/.$tblname
  #touch ./databases/$1/$tblname
  echo -e $temp >> ./databases/$1/$tblname 
  if [[ $? == 0 ]]
    then
              echo "Table Created successively"
              temp="";  # empty the var so if another table to be inserted the data dont be overlapped
              select x in "create new table" "go to table menu"
              do
              case $REPLY in 
              1 ) . ./CreateTable.sh $1 ;;
              2 ) . ./connectdb.sh $1 ;;
              * ) echo "invalid choice pick again"
              esac
              done

    
  else
    echo "Error creating table"
              select x in "Try again" "go to table menu"
              do
              case $REPLY in 
              1 ) . ./CreateTable.sh $1 ;;
              2 ) . ./connectdb.sh $1 ;;
              * ) echo "invalid choice pick again"
              esac
              done
  fi

done
        