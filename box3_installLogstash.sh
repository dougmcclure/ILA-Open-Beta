#!/bin/bash
# Vagrant provisioning script for Remote LFA Box
# Used for demonstrating IBM Log Analytics Milestone Driver 1
# Remote LFA Operations
#
#Doug McClure
#v1.0 4/15/13 Base CentOS 6.4 box for Logstash
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
INSTALL_DIR="/opt/logstash"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"
#Main Open Beta Driver
VAGRANT_BOX_1="10.10.10.2"
#Remote LFA box
VAGRANT_BOX_2="10.10.10.3"
#Logstash
VAGRANT_BOX_3="10.10.10.4"

echo "[SCAA] Turning off SELINUX on this CentOS Box"

#turn off selinux
# echo 0 > /usr/sbin/selinux/enforce (only turns off until reboot)
# sudo /usr/sbin/setenforce 0
#must edit /etc/sysconfig/selinux to perm turn off
#chagne SELINUX=permissive to SELINUX=disabled

sudo /usr/sbin/setenforce 0
sudo cp $SHARED_DIR/selinux /etc/sysconfig/selinux

echo "[SCAA] SELINUX Turned Off"

echo "[SCAA] Changing /etc/redhat-release to spoof IIM"
#change the /etc/redhat-release

sudo cp $SHARED_DIR/redhat-release /etc/redhat-release

echo "[SCAA] /etc/redhat-release changed"

echo "Install PRE-REQs for logstash1"
#update the driver package for LFA

echo "[SCAA] Install PREREQ for logstash1 box"

#
# this should install the following:
# Thanks to c835722 for help here.
#
#yum -y install compat-libstdc++-33
#yum -y install redhat-lsb
#yum -y install compat-libstdc++-33.i686
#yum -y install ksh.x86_64
#

#sudo yum -y localinstall $PREREQ_DIR/grp1/*.rpm

#logstash requirements - move to a pre-req download and provision script 

#sudo yum -y install java-1.6.0-openjdk.x86_64
#sudo yum -y install java-1.6.0-openjdk-devel

sudo yum -y localinstall $PREREQ_DIR/grp3/*.rpm


echo "[SCAA] Change iptables rules to allow SCAA to always work" 

#to turn it off for this sesssion 
sudo service iptables stop

#to turn it off perm
# sudo chkconfig iptables off

echo "[SCAA] Fixed iptables rules to allow SCAA to work" 

echo "[SCAA] Creating Install User and Group"
#create scla user and group

groupadd $GROUP_NAME

useradd -m -g $GROUP_NAME $USERNAME
echo $PASSWORD | passwd $USERNAME --stdin

echo "[SCAA] Install User and Group Created"

echo "[SCAA] Create Directories"

# create base and install directory
#/opt/scla/driver1/lfa

sudo mkdir $INSTALL_DIR


#get latest logstash jar
#add custom ouput to scaa

cp $SHARED_DIR/grp3/SCAA-logstash-1.1.10-flatjar.jar $INSTALL_DIR

sudo chown -R $USERNAME:$GROUP_NAME $INSTALL_DIR

#set up ssl cert

sudo mkdir /etc/ssl

sudo openssl req -x509 -subj "/C=US/ST=Georgia/L=Marietta/O=IT/OU=DEV/CN=www.dougmcclure.net/emailAddress=me@dougmcclure.net" -newkey rsa:2048 -keyout /etc/ssl/logstash.key -out /etc/ssl/logstash.pub -nodes -days 365

cp /etc/ssl/logstash.pub $SHARED_DIR/grp3


#simple conf file to spin up syslog input for each system to point to
#some basic filtering
#output to scaa 

#will need to turn off scaa GR api authentication
#will need to configure rsyslog on each box

#example of taking one of the Websphere logs (trace) through Lumberjack (on box2) into Lumberjack LS input into SCAA with full flow. (source type + index, etc....)





#https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar
#http://logstash.objects.dreamhost.com/release/logstash-1.1.9-flatjar.jar



#how to start up and manage logstash using an init script????
#http://cookbook.logstash.net/recipes/using-init/


#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0
