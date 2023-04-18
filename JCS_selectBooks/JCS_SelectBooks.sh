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

#---------------------------------------------------------------------------
#         checkParameterSize function
#---------------------------------------------------------------------------
checkParameterSize ()
{
  if [ ${#parameter} == 0 ]; then
    echo "$scriptName - parameter $k has no information."
    echo "$scriptName - Script will terminate."
    exit 1
  fi
  echo "${MAPFILE[$k]}"
}

############################################################################
#   Calling JCS_CreateAllBooks.sh
############################################################################
echo "$scriptName - ========== calling 'JCS_CreateAllBooks.sh' ==========="
mapfile -t < ~/sh_JCS/JCS_CreateAllBooksArguments.txt
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
mapfile -t < ~/sh_JCS/JCS_SelectBooksArguments.txt

for k in "${!MAPFILE[@]}"; 
do
  echo "Parameter $k is ${MAPFILE[$k]}"

  case "$k" in
        0)  parameter=${MAPFILE[$k]}
            checkParameterSize
        ;;
        1)  parameter=${MAPFILE[$k]}
            checkParameterSize
        ;;
        2)  parameter=${MAPFILE[$k]}
            checkParameterSize
        ;;
        3)  parameter=${MAPFILE[$k]}
            checkParameterSize
        ;;
        4)  parameter=${MAPFILE[$k]}
            checkParameterSize
        ;;
        5)  parameter=${MAPFILE[$k]}
            checkParameterSize
        ;;
        6)  parameter=${MAPFILE[$k]}
            checkParameterSize
        ;;
        7)  parameter=${MAPFILE[$k]}
            checkParameterSize
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
mapfile -t < ~/sh_JCS/JCS_SelectBooksArguments2.txt

for i in "${!MAPFILE[@]}"; 
do
  echo "Parameter $i is ${MAPFILE[$i]}"  
  
  case "$i" in
        0)  file2BeMoved=${MAPFILE[0]}
            if [ ${#file2BeMoved} == 0 ]; then
              echo "$scriptName - parameter 'file2BeMoved' has no information."
              echo "$scriptName - Script will terminate."
              exit 1
            fi
            echo "${MAPFILE[0]}"
           ;;
        1)  destDir=${MAPFILE[1]}
            if [ ${#destDir} == 0 ]; then
              echo "$scriptName - parameter 'destDir' has no information."
              echo "$scriptName - Script will terminate."
              exit 1
            fi
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
