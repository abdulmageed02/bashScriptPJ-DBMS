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


      # int validation
    if [[ $coltype == "int" ]]; then
     while ! [[ $data =~ ^[0-9]*$ || -z $data  ]]; do
       echo -e "invalid DataType !!"
        echo -e "$colname ($coltype) = \c"
       read data
      done
   fi

#String Validation
    if [[ $coltype == "string" ]]; then
     while ! [[ $data =~ ^[a-z|A-Z]+$ || -z $data ]]; do
       echo -e "invalid DataType !!"
        echo -e "$colname ($coltype) = \c"
       read data
      done
   fi


# Primary key validation
      if [[ $colKey == "PK" ]]; then
      PKC=""
            while [[ -z $PKC ]] ; do
            
            FN=$(awk 'BEGIN{FS="|"}{ for( i=1;i<=NF;i++) {if($i=="'$data'"){print i;break;}}}' ./databases/$1/$tblname)
            
            if [[ ! -z $FN ]];then
            PKC=$(cut -d "|" -f $FN ./databases/$1/$tblname | grep $data) 
           
                if [[  $data == $PKC ]];then
                    echo " duplicated primary key, please insert new value"
                    echo -e "$colname ($coltype) = \c"
                    read data
                    PKC=""
                  else
                  break 2;
                fi
                else
              break;
            fi
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

  echo -e $row >> ./databases/$1/$tblname
  if [[ $? == 0 ]] # check on the process of entering rows 
  then
    echo "Data Inserted Successfully"
  else
    echo "Error Inserting Data into Table $tblname"
  fi
  row=""
  echo "going to table menu" 

select x in "insert new data" "go to table menu"
do
case $REPLY in 
1 ) . ./insertintotable.sh $1 ;;
2 ) . ./connectdb.sh $1 ;;
* ) echo"invalid choice pick again"
esac
done

