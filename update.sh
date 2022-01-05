#!/bin/bash

while [ true ]; do
  echo "enter the table name "
  read name

  while [ true ]; do
    FILE=./databases/$1/$name
    if [ -f $FILE ]; then

      while true; do
        echo "Please enter Column name "
        read coln

        FIELDN=$(awk 'BEGIN{FS="|"}{if(NR==1) { for( i=1;i<=NF;i++) if($i=="'$coln'")print i }}' ./databases/$1/$name)

        if [[ -z $(awk 'BEGIN{FS="|"}{if ($1=="'$coln'")print $1}' ./databases/$1/.$name) ]]; then
          echo 'invalid column name'
          select choice in 'Select new Column ?' 'go back to table menu'; do
            case $REPLY in
            1) break ;;
            2) . ./connectdb.sh $1 ;;
            *) echo " invalid choice, pick again please" ;;
            esac
          done

          break
        else
          while true; do
            echo "select column value requird "
            read colv
            while [[ -z $colv ]]; do
              echo "you cant search with null value, select col value requird "
              read colv
            done

            if [[ ! -z $(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'") print $0}' ./databases/$1/$name) ]]; then

              echo -e "insert new value for the current column value: "
              read NewV
              ###################################################  New value validation checking either its string or int also checking on pk as new value
              HN=$FIELDN+1
              coltype=$(awk 'BEGIN{FS="|"}{if(NR=='$HN') print $2}' ./databases/$1/.$tblname)
              colKey=$(awk 'BEGIN{FS="|"}{if(NR=='$HN') print $3}' ./databases/$1/.$tblname)

              if [[ $coltype == "int" ]]; then
                while true; do
                  case $NewV in

                  +([0-9]))
                    if [[ "$colKey" == "PK" ]]; then
                      duplicated=0
                      while [[ true ]]; do
                        if [[ -z "$NewV" ]]; then
                          echo "Error!PK can't be NULL !"
                          read -p "Enter valid Primary key" NewV

                        elif
                          ! [[ $NewV =~ ^[1-9][0-9]*$ ]]
                        then
                          echo -e "ErrorInvalid data type!  "
                          read -p "Enter valid data type" NewV

                        else
                          duplicated=$(awk -F'|' '{if('$NewV'==$('$HN'-1)) {print $('$HN'-1);exit}}' ./databases/$1/$tblname)
                          if ! [[ $duplicated -eq 0 ]]; then
                            echo "Error!PK already exists"
                            read -p "Enter unique Primary key" NewV
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
                    read -p "enter valid data type (int)" NewV
                    ;;
                  esac
                done
              fi
              ####################################################
              RECORDN=$(awk 'BEGIN{FS="|"}{for( i=1;i<=NF;i++) if($i=="'$colv'" && i=="'$FIELDN'") {print NR;exit}}' ./databases/$1/$name)

              OldV=$(awk 'BEGIN{FS="|"}{if(NR=='$RECORDN'){for(i=1;i<=NF;i++){if(i=='$FIELDN') {print $i;exit }}}}' ./databases/$1/$name)

              sed -i ''$RECORDN's/'$OldV'/'$NewV'/g' ./databases/$1/$name

              echo "Row Updated Successfully"
              . ./connectdb.sh $1
            else
              echo "not match with $colv"
              select choice in 'insert new column value ?' 'go back to table menu'; do
                case $REPLY in
                1) break ;;
                2) . ./connectdb.sh $1 ;;
                *) echo " invalid choice, pick again please" ;;
                esac
              done
            fi
          done
        fi
      done

    else
      echo "this table doesnt exist"
      select choice in 'Update new table ?' 'go back to table menu'; do
        case $REPLY in
        1) break ;;
        2) . ./connectdb.sh $1 ;;
        *) echo " invalid choice, pick again please" ;;
        esac
      done
      break
    fi
  done
done
