#!/bin/bash
#---------------------------------------------------------------------------
#SCRIPT: JCS_SelectBooks.sh (JCS = Job Control Script)
#
#Purpose:   Calls:
#           JCS_CreateAllBooksFileArgs.sh
#           JCS_SelectBooksArgs.sh
#
#---------------------------------------------------------------------------
#         Helper Constants
#---------------------------------------------------------------------------
scriptName="JCS_SelectBooks.sh"
argumentsFile="$HOME/sh_JCS/JCS_CreateAllBooksArguments.txt"
argumentsFile2="$HOME/sh_JCS/JCS_SelectBooksArguments.txt"
argumentsFile3="$HOME/sh_JCS/JCS_SelectBooksArguments2.txt"

#---------------------------------------------------------------------------
#         checkParameterSize function
#---------------------------------------------------------------------------
checkParameterSize ()
{
    parameter=${MAPFILE[$i]}

    if [ ${#parameter} == 0 ]; then
      echo "$scriptName - parameter $i has no information."
      echo "$scriptName - Script will terminate."
      exit 1
    fi
    echo "$scriptName - ${MAPFILE[$i]}"
}

############################################################################
#   Calling JCS_CreateAllBooks.sh
############################################################################
echo "$scriptName - ========== calling 'JCS_CreateAllBooks.sh' ==========="
mapfile -t < "$argumentsFile"

JCS_CreateAllBooks.sh "${MAPFILE[@]}"

if [ $? -ne 0 ] 
then
    echo "$scriptName - ======== JCS_CreateAllBooks.sh    E  R  R  O  R  ============"
    exit 1
fi

############################################################################
#   Calling selectBooks
############################################################################
echo "$scriptName - ========== calling 'selectBooks' ==========="
mapfile -t < "$argumentsFile2"

for i in "${!MAPFILE[@]}"; 
do
  echo "$scriptName - Parameter $i is ${MAPFILE[$i]}"

  case "$i" in
        0)  checkParameterSize 
        ;;
        1)  checkParameterSize 
        ;;
        2)  checkParameterSize 
        ;;
        3)  checkParameterSize 
        ;;
        4)  checkParameterSize 
        ;;
        5)  checkParameterSize 
        ;;
        6)  checkParameterSize 
        ;;
        7)  checkParameterSize 
        ;;
        *)  echo "$scriptName - Eight (8) arguments must be informed:"
            echo "$scriptName - - 1) -b"
            echo "$scriptName - - 2) BookCollection directory"
            echo "$scriptName - - 3) -l"
            echo "$scriptName - - 4) BookLists directory"
            echo "$scriptName - - 5) -s"
            echo "$scriptName - - 6) Subjects file name"
            echo "$scriptName - - 7) -c"
            echo "$scriptName - - 8) 'Y' or 'N'"
            echo "$scriptName - Script will terminate."
            exit 1
        ;;
  esac

done

#---------------------------------------------------------------------------
#         Calling selectBooks
#---------------------------------------------------------------------------
selectBooks "${MAPFILE[@]}"

############################################################################
#   Moving file selectedBooksTotals.txt
############################################################################
mapfile -t < "$argumentsFile3"

for i in "${!MAPFILE[@]}"; 
do
  echo "$scriptName - Parameter $i is ${MAPFILE[$i]}"  
  
  case "$i" in
        0)  checkParameterSize
            file2BeMoved=${MAPFILE[$i]}
           ;;
        1)  checkParameterSize
            destDir=${MAPFILE[$i]}
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
