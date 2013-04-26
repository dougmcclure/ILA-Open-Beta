#!/bin/bash
# Provision main SCAA box for the multi-box scenario1 
# Used for demonstrating IBM Log Analytics Milestone Driver 1
# Main ILA driver and Remote APP+LFA Operations
#
#Doug McClure
#v1.0 4/12/13 Extract the driver1 LFA from main ILA box and place in $SHARED_DIR/lfa
#             Provision the SCAA driver 1 with WebSphere Liberty collection, log sources and saved searches
###############################################################################################################
#Uncomment this to see verbose install
set -x

#how long does this provisioning script take?
SCRIPT_START=$(date +%s)
echo Started : $(date)

#variables
GROUP_NAME="scla"
USERNAME="scla"
PASSWORD="scla"
BASE_DIR="/opt/scla"
INSTALL_DIR="$BASE_DIR/driver1"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"
#Main Open Beta Driver
VAGRANT_BOX_1="10.10.10.2"
#Remote LFA box
VAGRANT_BOX_2="10.10.10.3"

######
#
# Build out the multi-box scenario1
#
#####
#
echo "[SCAA] Copy LFA Files to shared directory"
#
# These files will be updated, possibly different with the milestone 2 driver as we're on LFA 6.3 at that time
#
# copy them to shared prereq dir - grp2 for the second box to pick up
#
mkdir -p $SHARED_DIR/grp2/lfa/unity_images
mkdir -p $SHARED_DIR/grp2/lfa/work_files/Configurations/Data_Collector

cp $INSTALL_DIR/setupScripts/ITM_Log_Agent_Setup.sh $SHARED_DIR/grp2/lfa
cp $INSTALL_DIR/unity_images/LFA_ITM_FP9.tar.gz $SHARED_DIR/grp2/lfa/unity_images
cp $INSTALL_DIR/unity_images/6.2.3.2-TIV-ITM_LFA-IF0002.tar $SHARED_DIR/grp2/lfa/unity_images
cp $INSTALL_DIR/work_files/Configurations/Data_Collector/* $SHARED_DIR/grp2/lfa/work_files/Configurations/Data_Collector/

echo "[SCAA] LFA Files Ready for Copying to Remote Systems from shared directory"

echo "Install WebSphere Liberty Demo Configuration"

#copy WebSphere Liberty configration files to sampleScenario directory included with milestone driver 1

sudo -u $USERNAME cp -R $SHARED_DIR/LibertyDemo $INSTALL_DIR/sampleScenarios

#must be in this directory to execute perl script

cd $INSTALL_DIR/sampleScenarios/

#install WebSphere Liberty Demo configurations (collection, log sources, saved searches)

sudo -u $USERNAME perl CreateSampleScenario.pl 9988 unityadmin unityadmin LibertyDemo/LibertyDemo.def


#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0