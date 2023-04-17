#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: JCS_CreateAllBooks.sh (JCS = Job Control Script)
#
#Purpose:   Reads the file with the arguments that will be passed to
#           JCS_CreateAllBooksMain.sh script
#
#Parameters: 1) Diretory with the book collection (mandatory)
#            2) Directory where to write the AllBooks file (also mandatory)
#---------------------------------------------------------------------

############################################################################
#             Helper Constants
############################################################################
scriptName="JCS_CreateAllBooks.sh"

mapfile -t < ~/sh_JCS/JCS_CreateAllBooksArguments.txt

for i in "${!MAPFILE[@]}"; 
do  
  case "$i" in
        0)  BookCollection=${MAPFILE[0]}
            echo "${MAPFILE[0]}"
           ;;
        1)  BookLists=${MAPFILE[1]}
            echo "${MAPFILE[1]}"
           ;;
        2)  create_y_n=${MAPFILE[2]}
            echo "${MAPFILE[1]}"
           ;;
        *)      echo "$scriptName - Three (3) arguments must be informed:"
                echo "$scriptName - - 1) The book collection Diretory, plus"
                echo "$scriptName - - 2) The directory to write Book lists file."
                echo "$scriptName - - 3) [create=yes] or [create=no]."
                echo "$scriptName - Script will terminate."
            exit 1
           ;;
  esac
  
done

# Verifying arguments
if [ ! -d "$BookCollection" ]; then
  echo "$scriptName - Directory $BookCollection does not exist."
  echo "$scriptName - the script will terminate"  
  exit 1
fi

if [ ! -d "$BookLists" ]; then
  echo "$scriptName - Directory $BookLists does not exist."
  echo "$scriptName - the script will terminate"  
  exit 1
fi

if  [ "$create_y_n" != "create=yes" ] && [ "$create_y_n" != "create=no" ]; then
  echo "$scriptName - 3rd parameter possible values are 'create=yes' or 'create=no'."
  echo "$scriptName - the script will terminate"  
  exit 1
fi

# Here arguments are OK
echo
echo "$scriptName - BookCollection = " "$BookCollection"
echo "$scriptName - BookLists      = " "$BookLists"
echo "$scriptName - create_y_n     = " "$create_y_n"
echo

############################################################################
#             Calling script JCS_CreateAllBooksMain.sh
############################################################################
echo "$scriptName - =============== Calling script JCS_CreateAllBooksMain.sh ================== "
JCS_CreateAllBooksMain.sh "$BookCollection" "$BookLists" "$create_y_n"
