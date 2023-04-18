#!/bin/bash
############################################################################
#               Preparing for removeDuPlicates2
#
# Purpose:  Generates 2 output files.
#           The most important of them will be used
#           in the next program to detect eBook eneplicities and
#           to that end will be used the fields
#           file SIZE and FileName.
#           By identifying the eneplicities we will be able to
#           delete the duplicate records.
#
# Input:    Read the AllBooks file
#
# Output:
#   1 - file composed by Number + Record read.
#   2 - file composed by Number + Size in bytes of the
#       proper book + FileName of the book extracted
#       from the record read.
#
# OBS:  Number is a counter of the lines read in the AllBooks file
############################################################################

############################################################################
#             Helper Constants
############################################################################
scriptName="JCS_RemoveDuplicates.sh"
argumentsFile="$HOME/sh_JCS/JCS_RemoveDuplicatesArguments.txt"
argumentsFile2="$HOME/sh_JCS/JCS_RemoveDuplicates2Arguments.txt"
argumentsFile3="$HOME/sh_JCS/JCS_RemoveDuplicates3Arguments.txt"

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
#   Preparing variables with the file names for pgm RemoveDuPlicates2
############################################################################
echo "$scriptName - Parameters read from File = $argumentsFile"

mapfile -t < "$argumentsFile"

for i in "${!MAPFILE[@]}"; 
do  
  case "$i" in
        0)  checkParameterSize
            AllBooks=${MAPFILE[$i]}
           ;;
        1)  checkParameterSize
            removeDuplicates_CompleteRec=${MAPFILE[$i]}
           ;;
        2)  checkParameterSize
            removeDuplicates_NumSizeFile=${MAPFILE[$i]}
           ;;
        *)  echo "$scriptName - Inform 3 File names:" 
            echo "$scriptName - 1-File with a list of all books"            
            echo "$scriptName - 2-File that will receive the CompleteRec"
            echo "$scriptName - 3-File that will receive the NumSizeFile"
            echo "$scriptName - Script will terminate"
            exit 1
           ;;
  esac
  
done

# Verifying arguments
if [ ! -f "$AllBooks" ]; then
  echo "$scriptName - File $AllBooks does not exist."
  echo "$scriptName - the script will terminate"  
  exit 1
fi

if [ ! -f "$removeDuplicates_CompleteRec" ]; then
  echo "$scriptName - File $removeDuplicates_CompleteRec does not exist."
  echo "$scriptName - It will be created"  
  touch "$removeDuplicates_CompleteRec"
fi

if [ ! -f "$removeDuplicates_NumSizeFile" ]; then
  echo "$scriptName - File $removeDuplicates_NumSizeFile does not exist."
  echo "$scriptName - It will be created"  
  touch "$removeDuplicates_NumSizeFile"
fi

# Here arguments are OK
echo
echo "$scriptName - AllBooks                     = " "$AllBooks"
echo "$scriptName - removeDuplicates_CompleteRec = " "$removeDuplicates_CompleteRec"
echo "$scriptName - removeDuplicates_NumSizeFile = " "$removeDuplicates_NumSizeFile"
echo

############################################################################
#   Calling removeDuPlicates2
############################################################################
echo "$scriptName - ========== calling 'removeDuPlicates2' =============="
removeDuplicates2 "$AllBooks" \
                  "$removeDuplicates_CompleteRec" \
                  "$removeDuplicates_NumSizeFile"

if [ $? -ne 0 ] 
then
    echo "$scriptName - ========== 'removeDuPlicates2  E  R  R  O  R' =============="
    exit 1
fi

############################################################################
#   Preparing variables to the SORT and to removePlural
############################################################################
echo "$scriptName - Parameters read from File = $argumentsFile2"

mapfile -t < "$argumentsFile2"

for i in "${!MAPFILE[@]}"; 
do
  case "$i" in
        0)  checkParameterSize
            removeDuplicates_NumSizeFileSorted=${MAPFILE[$i]}
           ;;
        1)  checkParameterSize
            eniplicities_Duplicates=${MAPFILE[$i]}
           ;;
        2)  checkParameterSize
            eniplicities_Without_Duplicates=${MAPFILE[$i]}
           ;;
        *)  echo "$scriptName - Inform 3 File names:" 
            echo "$scriptName - 1 - File that will receive the Sorted NumSizeFile"
            echo "$scriptName - 2 - File that will receive the eniplicities_Duplicates"
            echo "$scriptName - 3 - File that will receive the eniplicities_Without_Duplicates"
            echo "$scriptName - Script will terminate"
            exit 1
           ;;
  esac
  
done

# Verifying arguments
if [ ! -f "$removeDuplicates_NumSizeFileSorted" ]; then
  echo "$scriptName - File $removeDuplicates_NumSizeFileSorted does not exist."  
  echo "$scriptName - It will be created"  
  touch "$removeDuplicates_NumSizeFileSorted"
  exit 1
fi

if [ ! -f "$eniplicities_Duplicates" ]; then
  echo "$scriptName - File $eniplicities_Duplicates does not exist."
  echo "$scriptName - It will be created"  
  touch "$eniplicities_Duplicates"
fi

if [ ! -f "$eniplicities_Without_Duplicates" ]; then
  echo "$scriptName - File $eniplicities_Without_Duplicates does not exist."
  echo "$scriptName - It will be created"  
  touch "$eniplicities_Without_Duplicates"
fi

# Received arguments
echo
echo "$scriptName - removeDuplicates_NumSizeFileSorted = " "$removeDuplicates_NumSizeFileSorted"
echo "$scriptName - eniplicities_Duplicates            = " "$eniplicities_Duplicates"
echo "$scriptName - eniplicities_Without_Duplicates    = " "$eniplicities_Without_Duplicates"
echo

############################################################################
#   Calling sort over the 3rd field
#   LC_ALL=C must be used for special chars be classified before any
#   letter
############################################################################
echo "$scriptName - ========== LC_ALL=C sort -k 3,3 -k 2n =============="
LC_ALL=C sort -k 3,3 -k 2n  "$removeDuplicates_NumSizeFile" > "$removeDuplicates_NumSizeFileSorted"

if [ $? -ne 0 ] 
then
    echo "$scriptName - ========== 'LC_ALL=C sort -k 3,3 -k 2n   E  R  R  O  R' =============="
    exit 1
fi

############################################################################
#       calling eniplicities
#
# Purpose:  Identify the eneplicities and put those records
#           in a file.
#
# Input :   file composed by Number + Size in bytes of the
#           proper book + FileName of the book extracted
#
# Output:   - File with the duplicate records.
#           - File with no duplicities
############################################################################
echo "$scriptName - ========== calling 'eniplicities' =============="
eniplicities "$removeDuplicates_NumSizeFileSorted" \
            "$eniplicities_Duplicates" \
            "$eniplicities_Without_Duplicates"
    
if [ $? -ne 0 ] 
then
    echo "$scriptName - ========== 'eniplicities  E  R  R  O  R' =============="
    exit 1
fi

############################################################################
#   Preparing variables to the SORT and to DuplicateBooksLocation
############################################################################
echo "$scriptName - Parameters read from File = $argumentsFile3"

mapfile -t < "$argumentsFile3"

for i in "${!MAPFILE[@]}"; 
do
  case "$i" in
        0)  checkParameterSize
            eniplicities_DuplicatesSorted=${MAPFILE[$i]}
           ;;
        1)  checkParameterSize
            duplicateBooksLocation=${MAPFILE[$i]}
           ;;
        *)  echo "$scriptName - Inform 2 File names:" 
            echo "$scriptName - 1 - File that will receive the eniplicities_DuplicatesSorted"
            echo "$scriptName - 2 - File that will receive the duplicateBooksLocation"
            echo "$scriptName - Script will terminate"
            exit 1
           ;;
  esac
  
done

# Verifying arguments
if [ ! -f "$eniplicities_DuplicatesSorted" ]; then
  echo "$scriptName - File $eniplicities_DuplicatesSorted does not exist."  
  echo "$scriptName - It will be created"  
  touch "$eniplicities_DuplicatesSorted"
  fi

if [ ! -f "$duplicateBooksLocation" ]; then
  echo "$scriptName - File $duplicateBooksLocation does not exist."
  echo "$scriptName - It will be created"  
  touch "$duplicateBooksLocation"
fi

# Received arguments
echo
echo "$scriptName - eniplicities_DuplicatesSorted = " "$eniplicities_DuplicatesSorted"
echo "$scriptName - duplicateBooksLocation        = " "$duplicateBooksLocation"
echo

############################################################################
#   Calling sort over the 1st field
#   LC_ALL=C must be used for special chars be classified before any
#   letter
############################################################################
echo "$scriptName - ========== LC_ALL=C sort -k 1,1 =============="
LC_ALL=C sort -k 1,1  "$eniplicities_Duplicates" > "$eniplicities_DuplicatesSorted"

if [ $? -ne 0 ] 
then
    echo "$scriptName - ========== 'sort  E  R  R  O  R' =============="
    exit 1
fi

############################################################################
#               calling DuplicateBooksLocation 
#
# Purpose:  Make a match between 2 files.
#           1 - The 1st contain the dir location where all books are
#           2 - The 2nd contain the duplicate records of all books
#           These 2 files have a field at the beginning that will be
#           used to make the match. It is a sequence number that identify
#           each book.
#
# Input :   The 2 files described above
#
# Output:   File with the duplicate books with their directory
#           location.
#############################################################################
echo "$scriptName - ========== calling 'DuplicateBooksLocation' =============="
DuplicateBooksLocation "$removeDuplicates_CompleteRec" \
                        "$eniplicities_DuplicatesSorted" \
                        "$duplicateBooksLocation"
    
if [ $? -ne 0 ] 
then
    echo "$scriptName - ========== 'DuplicateBooksLocation  E  R  R  O  R' =============="
    exit 1
else
    echo "$scriptName - ========== 'ALL IS WELL !!' =============="
    exit 0
fi
