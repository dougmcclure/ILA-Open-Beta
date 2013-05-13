#!/bin/bash
# 
# Scenario2 -> Local Box Syslog (normal /var/log/* plus SCAA) -> Consolidated KVP File -> LFA -> SCAA Generic Annotator
#
#Doug McClure
#v1.0 5/1/13 First pass for Scenario2 on box1
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

#hot fixes for M2's GA bugs I've found

cd $INSTALL_DIR/utilities

sudo -u $USERNAME ./unity.sh -stop
sudo -u $USERNAME mv $INSTALL_DIR/unity_content/GA/GAContentPack_v1.1.0/extractors/rulesset/timeOnlySplitter/batchLogRecord_timeonly.aql $SHARED_DIR/box1-files/ORIG-batchLogRecord_timeonly.aql
sudo -u $USERNAME mv $INSTALL_DIR/unity_content/GA/GAContentPack_v1.1.0/extractors/rulesset/common/Date_BI.aql $SHARED_DIR/box1-files/ORIG-Date_BI.aql
sudo cp $SHARED_DIR/box1-files/batchLogRecord_timeonly.aql $INSTALL_DIR/unity_content/GA/GAContentPack_v1.1.0/extractors/rulesset/timeOnlySplitter
sudo cp $SHARED_DIR/box1-files/Date_BI.aql $INSTALL_DIR/unity_content/GA/GAContentPack_v1.1.0/extractors/rulesset/common
sudo chown -R scla:scla $INSTALL_DIR

#start SCAA back up. There will be a delay at this step while this happens. If problems - check /opt/scla/scenario2-startup.log
(   exec 0>&- # close stdin
    sudo -u $USERNAME ./unity.sh -start ;# start SCAA
) &> $BASE_DIR/scenario2-startup.log

#Copy SyslogDemo1 directory with files for provisioning SCAA (ST, C, LS, QS) to sampleScenario folder

sudo -u $USERNAME cp -R $SHARED_DIR/box1-files/SyslogDemo1 $INSTALL_DIR/sampleScenarios

#must be in this directory to execute perl script

cd $INSTALL_DIR/sampleScenarios/

#install SyslogDemo1 Demo configurations (collection, log sources, saved searches)

sudo -u $USERNAME perl CreateSampleScenario.pl 9988 unityadmin unityadmin SyslogDemo1/SyslogDemo1.def

#box1 - new rsyslog.conf file 
#- identify monitored files and creation of output file using SCAA KVP template
#- make sure output file writes to a unique file name so we can identify each box in SCAA 
#box1 - write file to monitored GA directory /opt/scla/driver/logsources/GAContentPack/box1-syslog.log

sudo cp $SHARED_DIR/box1-files/box1-rsyslog.conf /etc/rsyslog.conf

#restart rsyslog

sudo service rsyslog restart

#####
#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0