#!/bin/bash
# Vagrant provisioning script for Remote LFA Box
# Used for demonstrating IBM Log Analytics Milestone Driver 1
# Remote LFA Operations
#
#Doug McClure
#v1.0 4/6/13 Base CentOS 6.4 box with OpenBeta Driver 1 LFA
#v1.1 4/8/13 Enhancements for multi-box scenario #1 - one master SCAA box + one remote LFA box
#v1.2 4/10/13 Fully install the LFA, Install WebSphere Liberty Profile and Sample Liberty App
#v1.3 4/11/13 Set Liberty sample app logging level by replacing server.xml file, install LFA configs 
#            (lfademo.conf/fmt) to watch Liberty messages & trace logs, restart LFA to take configs
#v1.4 4/12/13 Moving all download steps out of this provisioning script and into separate provisioning script 
#
#
# README:
# - Websphere Liberty Early Access Version must be downloaded and stored in the $SHARED_DIR
# - The early access version provided has two files  wlp-developers-runtime-8.5.next.beta.jar 
#   and wlp-developers-extended-8.5.next.beta.jar
#   I put some direct wget links in as comments that might work for getting these files if 
#   they get through the T&C ack needed via a web browser download
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
INSTALL_DIR="$BASE_DIR/driver1"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"
#Main Open Beta Driver
VAGRANT_BOX_1="10.10.10.2"
#Remote LFA box
VAGRANT_BOX_2="10.10.10.3"

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

echo "Install PRE-REQs for SCAA"
#update the driver package for LFA

echo "[SCAA] Install PREREQ for SCAA Remote LFA Box"

#
# this should install the following:
# Thanks to c835722 for help here.
#
#yum -y install compat-libstdc++-33
#yum -y install redhat-lsb
#yum -y install compat-libstdc++-33.i686
#yum -y install ksh.x86_64
#

sudo yum -y localinstall $PREREQ_DIR/grp1/*.rpm


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

mkdir -p $INSTALL_DIR/lfa

chown -R $USERNAME:$GROUP_NAME $BASE_DIR

echo "[SCAA] Directories Created"

sudo -u $USERNAME cp -R $SHARED_DIR/grp2/lfa/ $INSTALL_DIR

chown -R $USERNAME:$GROUP_NAME $BASE_DIR

#<-- creates an install dir under lfa/IBM-LFA-6.23

cd $INSTALL_DIR/lfa

sudo -u $USERNAME ./ITM_Log_Agent_Setup.sh $INSTALL_DIR/lfa/ $INSTALL_DIR/lfa/

echo "[SCAA] Driver 1 LFA Installed"

#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0
