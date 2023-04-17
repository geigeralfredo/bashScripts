#!/bin/bash
#---------------------------------------------------------------------------
#SCRIPT: JCS_SelectBooks.sh (JCS = Job Control Script)
#
#Purpose:   Calls:
#           JCS_CreateAllBooksFileArgs.sh
#           JCS_SelectBooksArgs.sh
#
#Parameters: No parameters
#---------------------------------------------------------------------------

############################################################################
#             Helper Constants
############################################################################
scriptName="JCS_SelectBooks.sh"

############################################################################
#   Calling JCS_CreateAllBooks.sh
############################################################################
echo "$scriptName - ========== calling 'JCS_CreateAllBooks.sh' ==========="
mapfile -t < ~/sh_JCS/JCS_CreateAllBooksArguments.txt
JCS_CreateAllBooks.sh "${MAPFILE[@]}"

if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   Calling selectBooks
############################################################################
echo "$scriptName - ========== calling 'selectBooks' ==========="
mapfile -t < ~/sh_JCS/JCS_SelectBooksArguments.txt

for i in "${!MAPFILE[@]}"; 
do
  echo "Parameter $i is ${MAPFILE[$i]}"
done

selectBooks "${MAPFILE[@]}"

############################################################################
#   Moving file selectedBooksTotals.txt
############################################################################
mapfile -t < ~/sh_JCS/JCS_SelectBooksArguments2.txt

for i in "${!MAPFILE[@]}"; 
do
  echo "Parameter $i is ${MAPFILE[$i]}"  
  
  case "$i" in
        0)  file2BeMoved=${MAPFILE[0]}
            echo "${MAPFILE[0]}"
           ;;
        1)  destDir=${MAPFILE[1]}
            echo "${MAPFILE[1]}"
           ;;
        *)  echo "$scriptName - Two (2) arguments must be informed:"
            echo "$scriptName - - 1) The file name to be moved."
            echo "$scriptName - - 2) The destination directory."
            echo "$scriptName - Script will terminate."
            exit 1
           ;;
  esac
  
done

# Received arguments
echo
echo "$scriptName - file2BeMoved = " "$file2BeMoved"
echo "$scriptName - destDir      = " "$destDir"
echo

# Verifying if file exists
if [ ! -f "$file2BeMoved" ]; then
    echo "$scriptName - File $file2BeMoved does not exist."
    echo "$scriptName - So it will not be moved."
    echo "$scriptName - Script will terminate"
    exit 1
  else
    echo "$scriptName - Moving file $file2BeMoved"
    mv "$file2BeMoved" "$destDir"
fi

if [ $? -ne 0 ] 
then
    echo "$scriptName - ==============  E  R  R  O  R  =================="
    exit 1
else
    echo "$scriptName - ==============  ALL IS WELL !!  =================="
    exit 0
fi
