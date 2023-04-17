#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: JCS_Extensions.sh (JCS = Job Control Script)
#
#Purpose:   Sanity checking parameters
#           Calls: JCS_ExtensionsMain.sh
#
#---------------------------------------------------------------------

############################################################################
#             Helper Constants
############################################################################
scriptName="JCS_Extensions.sh"

############################################################################
#           Prepare to receive arguments
############################################################################
mapfile -t < ~/sh_JCS/JCS_ExtensionsArguments.txt

for i in "${!MAPFILE[@]}"; 
do  
  case "$i" in
        0)  AllBooks=${MAPFILE[0]}
            echo "${MAPFILE[0]}"
           ;;
        1)  selectedBooks_Extensions=${MAPFILE[1]}
            echo "${MAPFILE[1]}"
           ;;
        2)  selectedBooks_RejectedExtensions=${MAPFILE[2]}
            echo "${MAPFILE[2]}"
           ;;
        3)  selectedBooks_ExtensionsSortedByName=${MAPFILE[3]}
            echo "${MAPFILE[3]}"
           ;;
        4)  selectedBooks_ExtensionsSortedByOccurrences=${MAPFILE[4]}
            echo "${MAPFILE[4]}"
           ;;
        *)  echo "$scriptName - Inform 5 File names:" 
            echo "$scriptName - Inform the File with All Books file names"
            echo "$scriptName - A File Name to receive the Extensions"
            echo "$scriptName - A File Name to receive the Rejected Extensions"
            echo "$scriptName - A File Name to receive the ExtensionsSortedByName"
            echo "$scriptName - A File Name to receive the ExtensionsSortedByOccurrences"
            echo "$scriptName - Script will terminate"
            exit 1
           ;;
  esac
  
done

# Verifying arguments
if [ ! -f "$AllBooks" ]; then
  echo "$scriptName - Input File $AllBooks does not exist."
  echo "$scriptName - the script will terminate"  
  exit 1
fi

if [ ! -f "$selectedBooks_Extensions" ]; then
  echo "$scriptName - Output File $selectedBooks_Extensions does not exist."
  echo "$scriptName - It will be created"  
  touch "$selectedBooks_Extensions"
fi

if [ ! -f "$selectedBooks_RejectedExtensions" ]; then
  echo "$scriptName - Output File $selectedBooks_RejectedExtensions does not exist."
  echo "$scriptName - It will be created"  
  touch "$selectedBooks_RejectedExtensions"
fi

if [ ! -f "$selectedBooks_ExtensionsSortedByName" ]; then
  echo "$scriptName - Output File $selectedBooks_ExtensionsSortedByName does not exist."
  echo "$scriptName - It will be created"  
  touch "$selectedBooks_ExtensionsSortedByName"
fi

if [ ! -f "$selectedBooks_ExtensionsSortedByOccurrences" ]; then
  echo "$scriptName - Output File $selectedBooks_ExtensionsSortedByOccurrences does not exist."
  echo "$scriptName - It will be created"  
  touch "$selectedBooks_ExtensionsSortedByOccurrences"
fi

# Here arguments are OK
echo
echo "$scriptName - AllBooks                                    = " "$AllBooks"
echo "$scriptName - selectedBooks_Extensions                    = " "$selectedBooks_Extensions"
echo "$scriptName - selectedBooks_RejectedExtensions            = " "$selectedBooks_RejectedExtensions"
echo "$scriptName - selectedBooks_ExtensionsSortedByName        = " "$selectedBooks_ExtensionsSortedByName"
echo "$scriptName - selectedBooks_ExtensionsSortedByOccurrences = " "$selectedBooks_ExtensionsSortedByOccurrences"
echo

############################################################################
#           calling 'JCS_ExtensionsMain.sh'
############################################################################
echo "$scriptName - ========== calling 'JCS_ExtensionsMain.sh' ==========="
JCS_ExtensionsMain.sh "${MAPFILE[@]}"
