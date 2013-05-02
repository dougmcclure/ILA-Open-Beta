#!/bin/bash
# 
# Scenario2 -> Local Box Syslog (normal /var/log/* plus Liberty) -> Consolidated KVP File -> LFA -> SCAA Generic Annotator
#
#Doug McClure
#v1.0 5/1/13 First pass for Scenario2 on box2
#
#
########################################################################################################
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
INSTALL_DIR="/opt/scla/driver"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"

#####

#box2 - new rsyslog.conf file
#- identify monitored files and creation of output file using SCAA KVP template
#- make sure output file writes to a unique file name so we can identify each box in SCAA 
#/opt/scla/scenario2/box2-syslog.log

sudo cp $SHARED_DIR/box2-files/box2-rsyslog.conf /etc/rsyslog.conf

#restart rsyslog

sudo service rsyslog restart

#delete scenario1's LFA files
#stop LFA

sudo -u $USERNAME $INSTALL_DIR/lfa/IBM-LFA-6.30/bin/itmcmd agent -o default_workload_instance stop lo

#delete scenario1 LFA files, to re-configure, change the lines that are commented out in the .conf file

sudo -u $USERNAME rm -f $INSTALL_DIR/lfa/IBM-LFA-6.30/config/lo/lfademo2*

#add new LFA config to monitor this file
#this disables scenario1's monitored files and adds the consolidated syslog file instead

sudo -u $USERNAME cp $SHARED_DIR/box2-files/lfademo3* $INSTALL_DIR/lfa/IBM-LFA-6.30/config/lo/


#make sure consolidated syslog dir/file owned by scla:scla
sudo chown -R $USERNAME:$GROUP_NAME $BASE_DIR/scenario2

#start LFA
sudo -u $USERNAME $INSTALL_DIR/lfa/IBM-LFA-6.30/bin/itmcmd agent -o default_workload_instance start lo


#####
#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0