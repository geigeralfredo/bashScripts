#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: JCS_SelectBooks.sh (JCS = Job Control Script)
#
#Purpose:   Calls:
#           JCS_CreateAllBooksFileArgs.sh
#           JCS_SelectBooksArgs.sh
#
#Parameters: No parameters
#---------------------------------------------------------------------
############################################################################
#   Calling JCS_CreateAllBooksFile.sh
############################################################################
echo "JCS_SelectBooks.sh - ========== calling 'JCS_CreateAllBooksFile.sh' ==========="
mapfile -t < ~/sh_JCS/JCS_CreateAllBooksArguments.txt
source JCS_CreateAllBooks.sh "${MAPFILE[@]}"

if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   Calling selectBooks
############################################################################
echo "JCS_SelectBooks.sh - ========== calling 'selectBooks' ==========="
mapfile -t < ~/sh_JCS/JCS_SelectBooksArguments.txt

for i in ${!MAPFILE[@]}; 
do
  echo "element $i is ${MAPFILE[$i]}"
done

selectBooks "${MAPFILE[@]}"

############################################################################
#   Moving file selectedBooksTotals.txt
############################################################################
file2BeMoved="/home/alfredo/Documents/TXT/selectBooks/BookLists/selectedBooksTotals.txt"
destDir="/home/alfredo/Documents/TXT/selectBooks/"

# Verifying if file exists
if [ ! -f "$file2BeMoved" ]; then
    echo "JCS_SelectBooks.sh - File $file2BeMoved does not exist."
    echo "JCS_SelectBooks.sh - So it will not be moved."  
  else
    echo "JCS_SelectBooks.sh - Moving file $file2BeMoved"
    mv $file2BeMoved $destDir
fi

if [ $? -ne 0 ] 
then
    exit 1
else
    exit 0
fi
