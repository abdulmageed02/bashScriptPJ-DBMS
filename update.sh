#!/bin/bash

while [ true ]
do
echo "enter the table name "
read name 

    while [ true ]
    do 
    FILE=./databases/$1/$name
        if [ -f $FILE ];
         then
         
                while true
                do
                echo "Please enter Colname "
                read  coln  
             
               FIELDN=$(awk 'BEGIN{FS="|"}{if(NR==1) { for( i=1;i<=NF;i++) if($i=="'$coln'")print i }}' ./databases/$1/$name)
               
                    if [[ -z $(awk 'BEGIN{FS="|"}{if ($1=="'$coln'")print $1}' ./databases/$1/.$name) ]];then
                    echo 'invalid col name'
                    break;
                    else
                        while true 
                        do
                        echo "select col value requird "
                        read colv
                       
                        if [[ ! -z $(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'") print $0}' ./databases/$1/$name) ]];then
                            
                            echo -e "insert new value for the current col value: "
                                read NewV
###################################################  New value validation checking either its string or int also checking on pk as new value
HN=$FIELDN+1
type=$( awk 'BEGIN{FS="|"}{if(NR=='$HN') print $2}' ./databases/$1/.$tblname)
 if [[ $type == "int" ]]; then
     while ! [[ $NewV =~ ^[1-9]*$ || -z $NewV  ]]; do
       echo -e "invalid DataType !!"
        echo -e "insert new value for the current col value: "
             read NewV
      done
   fi
###################################
   if [[ $type == "string" ]]; then
     while ! [[ $NewV =~ ^[a-z|A-Z]+$ || -z $NewV ]]; do
       echo -e "invalid DataType !!"
       echo -e "insert new value for the current col value: "
             read NewV
      done
   fi
   ###########################
   Key=$( awk 'BEGIN{FS="|"}{if(NR=='$HN') print $3}' ./databases/$1/.$tblname)
    if [[ $Key == "PK" ]]; then
      PKC=""
            while [[ -z $PKC ]] ; do
            
            FN=$(awk 'BEGIN{FS="|"}{ for( i=1;i<=NF;i++) {if($i=="'$NewV'"){print i;break;}}}' ./databases/$1/$tblname)
            
            if [[ ! -z $FN ]];then
            PKC=$(cut -d "|" -f $FN ./databases/$1/$tblname | grep $NewV) 
           
                if [[  $NewV == $PKC ]];then
                    echo " duplicated primary key, please insert new value"
                     echo -e "insert new value for the current col value: "
                        read NewV
                    PKC=""
                  else
                  break 2;
                fi
                else
              break;
            fi
          done
      fi

####################################################
                                RECORDN=$(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print NR}}' ./databases/$1/$name) 
                                OldV=$(awk 'BEGIN{FS="|"}{if(NR=='$RECORDN'){for(i=1;i<=NF;i++){if(i=='$FIELDN') print $i}}}'   ./databases/$1/$name) 
                                echo $oldValue
                                sed -i ''$RECORDN's/'$OldV'/'$NewV'/g' ./databases/$1/$name
                                echo "Row Updated Successfully"
                                 . ./connectdb.sh $1
                        else
                        echo "not match with $colv"
                        fi
                        done
                    fi
                done
        
        else
        echo "this table doesnt exist"
        break;
        fi
    done
done