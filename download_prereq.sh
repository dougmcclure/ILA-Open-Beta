#!/bin/bash
# Vagrant systems pre-requisite provisioning script 
# for SCAA OpenBeta Systems Provisioning
#
#
#Doug McClure
#v1.0 4/12/13 Pull all of the yum install stuff into this provisioning script so they're all 
#             downloaded and stored to shared folder enabling one big yum -y localinstall 
#             $SHARED_DIR/prereq/[common|box2]/* within the main provisioning script.
#
#v1.1 4/24/13 first pass for SCAA Milestone Driver 2 
#######################################################################################################
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
INSTALL_DIR="$BASE_DIR/driver"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"

################################################################################################
#GOAL: Download prereq stuff once and have it available for any subsequent vagrant ups so 
#      we can build those follow on systems faster
#
# This yum plugin allows for downloading the rpm files, then use yum localinstall command from
#
#–downloadonly : don’t update, just download an rpm file
#–downloaddir=/path/to/dir : specifies an alternate directory to store packages such as /tmp
#
################################################################################################

sudo yum install -y yum-downloadonly

#
#Total of ~200MB in packages to download (121 packages)
#
# for Vagrant box #1 & box2 (driver, liberty)
sudo yum -y install compat-libstdc++-33 --downloadonly --downloaddir=$PREREQ_DIR/common
sudo yum -y install redhat-lsb --downloadonly --downloaddir=$PREREQ_DIR/common
#check into why this isn't d/l with the above - this adds /usr/bin/lsb-release needed for M2 driver.
sudo yum -y install redhat-lsb-core-4.0-7.el6.centos.i686 --downloadonly --downloaddir=$PREREQ_DIR/common
sudo yum -y install compat-libstdc++-33.i686 --downloadonly --downloaddir=$PREREQ_DIR/common
sudo yum -y install ksh.x86_64 --downloadonly --downloaddir=$PREREQ_DIR/common

# for Vagrant box #2 (liberty)
sudo yum -y install java-1.6.0-openjdk.x86_64 --downloadonly --downloaddir=$PREREQ_DIR/box2
sudo yum -y install unzip --downloadonly --downloaddir=$PREREQ_DIR/box2

# for Vagrant box #2 (liberty)
# 5Kb download
wget -O $PREREQ_DIR/box2/OnlinePollingSampleServer.zip https://www.ibm.com/developerworks/mydeveloperworks/blogs/wasdev/resource/samples/OnlinePollingSampleServer.zip
# about 11MB download
wget -O $PREREQ_DIR/box2/db-derby-10.8.3.0-lib.zip http://apache.mirrors.pair.com/db/derby/db-derby-10.8.3.0/db-derby-10.8.3.0-lib.zip

#this may work assuming there's no cached cookie, etc. on my system allowing me to ack their T&C's for download, otherwise pre-download and place in $PREREQ_DIR:
# about 31MB download
wget -O $PREREQ_DIR/box2/wlp-developers-runtime-8.5.next.beta.jar https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.next.beta2/wlp-developers-runtime-8.5.next.beta.jar

#this may work assuming there's no cached cookie, etc. on my system allowing me to ack their T&C's for downloadotherwise pre-download and place in $PREREQ_DIR:
#about 53MB download
wget -O $PREREQ_DIR/box2/wlp-developers-extended-8.5.next.beta.jar https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.next.beta2/wlp-developers-extended-8.5.next.beta.jar

#future box3

#future box4


#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0