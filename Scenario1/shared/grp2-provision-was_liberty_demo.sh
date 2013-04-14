#!/bin/bash
# Vagrant systems pre-requisite provisioning script 
# Used for demonstrating IBM Log Analytics Milestone Driver 1
# Main ILA driver and Remote LFA Operations
#
#Doug McClure
#v1.0 4/12/13 Pull all of the yum install stuff into this provisioning script so they're all 
#             downloaded and stored to shared folder enabling one big yum -y localinstall 
#             $SHARED_DIR/* within the main provisioning script.
#
#####################################################################################################
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


#Install WebSphere Liberty
#
#pre-reqs this should install the following:
#for WebSphere Liberty : yum -y install java
#for sample app : yum -y install unzip

sudo yum -y localinstall $PREREQ_DIR/grp2/*.rpm


#Install WebSphere Liberty
#
#WebSphere Liberty must be pre-downloaded and packages placed in the shared directory
##https://www.ibm.com/developerworks/mydeveloperworks/blogs/wasdev/entry/download_wlp_eap?lang=en_us
#
#The early access version provided has two files
#wlp-developers-runtime-8.5.next.beta.jar
#wlp-developers-extended-8.5.next.beta.jar


#install first WebSphere Liberty Package
sudo -u $USERNAME java -jar $PREREQ_DIR/grp2/wlp-developers-runtime-8.5.next.beta.jar --acceptLicense $BASE_DIR

#install the extended content for WebSphere Liberty
sudo -u $USERNAME java -jar $PREREQ_DIR/grp2/wlp-developers-extended-8.5.next.beta.jar --acceptLicense $BASE_DIR/wlp/

echo "[SCAA] WebSphere Liberty Installed"

#
#Sample WebSphere Liberty Application - Online Polling
#
#Website describing this sample app: https://www.ibm.com/developerworks/mydeveloperworks/blogs/wasdev/entry/online_polling_sample?lang=en_us
#
#WebSphere Liberty Docs
#https://www.ibm.com/developerworks/mydeveloperworks/blogs/wasdev/resource/doc/liberty_v85next_beta.pdf?lang=en_us
#http://www.redbooks.ibm.com/redbooks/pdfs/sg248076.pdf
    
  
#Unzip in the WebSphere Liberty path

sudo -u $USERNAME unzip $PREREQ_DIR/grp2/OnlinePollingSampleServer.zip -d $BASE_DIR

#
#The sample app needs the derby.jar file
#

#Unzip derby

sudo -u $USERNAME unzip $PREREQ_DIR/grp2/db-derby-10.8.3.0-lib.zip -d $BASE_DIR

#copy derby.jar to the Online Polling app from /opt/scla/db-derby-10.8.3.0-lib/lib/derby.jar to /opt/scla/wlp/usr/servers/OnlinePollingSampleServer/derby/lib

sudo -u $USERNAME cp $BASE_DIR/db-derby-10.8.3.0-lib/lib/derby.jar $BASE_DIR/wlp/usr/servers/OnlinePollingSampleServer/derby/lib

#put a new server.xml file in Liberty that includes lower level logging
#/opt/scla/wlp/usr/servers/OnlinePollingSampleServer/logs/ messages.log, console.log, trace.log, start.log
#/opt/scla/wlp/usr/servers/OnlinePollingSampleServer/derby.log

sudo -u $USERNAME cp $SHARED_DIR/grp2/server.xml $BASE_DIR/wlp/usr/servers/OnlinePollingSampleServer/

#start the sample app, available here: http://10.10.10.3:9080/OnlinePollingSampleWeb/VoteServlet

sudo -u $USERNAME $BASE_DIR/wlp/bin/server start OnlinePollingSampleServer

echo "[SCAA] WebSphere Sample App Installed and Started"


# copy new LFA configs to watch Liberty logs for the OnlinePollingSampleServer
#/opt/scla/driver1/lfa/IBM-LFA-6.23/config/lo/lfademo.conf & lfademo.fmt
#
#NOTE: the .conf file has the main SCAA IP address and port hardcoded. Update as needed!
#ServerLocation=EIF_SERVER_IP
#ServerPort=EIF_SERVER_PORT

sudo -u $USERNAME cp $SHARED_DIR/grp2/lfademo* $INSTALL_DIR/lfa/IBM-LFA-6.23/config/lo

# restart the LFA to pick up the new configs

$INSTALL_DIR/lfa/IBM-LFA-6.23/bin/itmcmd agent -o default_workload_instance stop lo

$INSTALL_DIR/lfa/IBM-LFA-6.23/bin/itmcmd agent -o default_workload_instance start lo

#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0