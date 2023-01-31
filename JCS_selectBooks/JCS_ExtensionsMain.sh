#!/bin/bash
############################################################################
#SCRIPT: JCS_ExtensionsMain.sh
#PURPOSE:   To create a file with all extensions that are present
#           in the AllBooks file with the number of occurrences of each
############################################################################
#
# Only arg - File to be read 
#

# check number of arguments, must be 1
if [[ ! $# -eq 3 ]]
  then
    echo "JCS_ExtensionsMain.sh - Inform the File with All Books file names"
    echo "JCS_ExtensionsMain.sh - A File Name to receive the Extensions"
    echo "JCS_ExtensionsMain.sh - A File Name to receive the Rejected Extensions"
    echo "JCS_ExtensionsMain.sh - Script will terminate"
    exit 1
fi

# Saving arguments
file2beRead=$1
extensionsFile=$2
rejectedExtensionsFile=$3

# Verifying arguments
if [ ! -f "$file2beRead" ]; then
  echo "JCS_ExtensionsMain.sh - File $file2beRead does not exist."
  echo "JCS_ExtensionsMain.sh - the script will terminate"  
  exit 1
fi

if [ ! -f "$extensionsFile" ]; then
  echo "JCS_ExtensionsMain.sh - File $extensionsFile does not exist."
  echo "JCS_ExtensionsMain.sh - It will be created"  
  touch $extensionsFile
fi

if [ ! -f "$rejectedExtensionsFile" ]; then
  echo "JCS_ExtensionsMain.sh - File $rejectedExtensionsFile does not exist."
  echo "JCS_ExtensionsMain.sh - It will be created"  
  touch $rejectedExtensionsFile
fi

# Here arguments are OK
echo
echo "JCS_ExtensionsMain.sh - file2beRead             = " $file2beRead
echo "JCS_ExtensionsMain.sh - extensionsFile          = " $extensionsFile
echo "JCS_ExtensionsMain.sh - rejectedExtensionsFile  = " $rejectedExtensionsFile
echo

############################################################################
#   Calling getExtensions
############################################################################
echo "JCS_ExtensionsMain.sh - ========== getExtensions will be called =============="
getExtensions  $file2beRead  $extensionsFile  $rejectedExtensionsFile

if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   sort extensions by name
############################################################################
echo "JCS_ExtensionsMain.sh - ========== sort extensions by name =============="
sort ~/Documents/TXT/selectBooks/selectedBooks_Extensions.txt > ~/Documents/TXT/selectBooks/selectedBooks_ExtensionsSortedByName.txt

if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   sort extensions by number of occurrences 
############################################################################
echo "JCS_ExtensionsMain.sh - ========== sort extensions by number of occurrences =============="
sort -n --key=2.1 --key=1.2 ~/Documents/TXT/selectBooks/selectedBooks_Extensions.txt > ~/Documents/TXT/selectBooks/selectedBooks_ExtensionsSortedByOccurrences.txt
#cat ~/Documents/TXT/selectBooks/selectedBooks_ExtensionsSortedByOccurrences.txt

if [ $? -ne 0 ] 
then
    exit 1
fi

############################################################################
#   list the rejected extensions
############################################################################
#echo "JCS_ExtensionsMain.sh - ========== list the rejected extensions =============="
#cat ~/Documents/TXT/selectBooks/selectedBooks_RejectedExtensions.txt

if [ $? -ne 0 ] 
then
    exit 1
else
    exit 0
fi
