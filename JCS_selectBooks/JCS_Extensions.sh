#!/bin/bash
#--------------------------------------------------------------------
#SCRIPT: JCS_Extensions.sh (JCS = Job Control Script)
#
#Purpose:   Calls:
#           JCS_ExtensionsMain.sh
#
#Parameters: No parameters
#---------------------------------------------------------------------
############################################################################
#   Calling JCS_ExtensionsMain.sh
############################################################################
echo "JCS_Extensions.sh - ========== calling 'JCS_ExtensionsMain.sh' ==========="
mapfile -t < ~/sh_JCS/JCS_ExtensionsArguments.txt
source JCS_ExtensionsMain.sh "${MAPFILE[@]}"

if [ $? -ne 0 ] 
then
    exit 1
fi
