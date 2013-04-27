#!/bin/bash
# Vagrant systems pre-requisite provisioning script 
# for SCAA OpenBeta Systems Provisioning
#
#
#Doug McClure
#v1.0 4/12/13 Pull all of the yum install stuff into this provisioning script so they're all 
#             downloaded and stored to shared folder enabling one big yum -y localinstall 
#             $SHARED_DIR/prereq/[grp1|grp2]/* within the main provisioning script.
#
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
INSTALL_DIR="$BASE_DIR/driver1"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"
#Main Open Beta Driver
VAGRANT_BOX_1="10.10.10.2"
#Remote LFA box
VAGRANT_BOX_2="10.10.10.3"


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
# for Vagrant box #1 & box2 (driver1, liberty1)
sudo yum -y install compat-libstdc++-33 --downloadonly --downloaddir=$PREREQ_DIR/grp1
sudo yum -y install redhat-lsb --downloadonly --downloaddir=$PREREQ_DIR/grp1
sudo yum -y install compat-libstdc++-33.i686 --downloadonly --downloaddir=$PREREQ_DIR/grp1
sudo yum -y install ksh.x86_64 --downloadonly --downloaddir=$PREREQ_DIR/grp1

# for Vagrant box #2 (liberty1)
sudo yum -y install java-1.6.0-openjdk.x86_64 --downloadonly --downloaddir=$PREREQ_DIR/grp2
sudo yum -y install unzip --downloadonly --downloaddir=$PREREQ_DIR/grp2

# for Vagrant box #2 (liberty1)
# 5Kb download
wget -O $PREREQ_DIR/grp2/OnlinePollingSampleServer.zip https://www.ibm.com/developerworks/mydeveloperworks/blogs/wasdev/resource/samples/OnlinePollingSampleServer.zip
# about 11MB download
wget -O $PREREQ_DIR/grp2/db-derby-10.8.3.0-lib.zip http://apache.mirrors.pair.com/db/derby/db-derby-10.8.3.0/db-derby-10.8.3.0-lib.zip

#this may work assuming there's no cached cookie, etc. on my system allowing me to ack their T&C's for download, otherwise pre-download and place in $PREREQ_DIR:
# about 31MB download
wget -O $PREREQ_DIR/grp2/wlp-developers-runtime-8.5.next.beta.jar https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.next.beta2/wlp-developers-runtime-8.5.next.beta.jar

#this may work assuming there's no cached cookie, etc. on my system allowing me to ack their T&C's for downloadotherwise pre-download and place in $PREREQ_DIR:
#about 53MB download
wget -O $PREREQ_DIR/grp2/wlp-developers-extended-8.5.next.beta.jar https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/8.5.next.beta2/wlp-developers-extended-8.5.next.beta.jar

#future box3

#future box4


#how long does this provisioning script take?

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Ended : $(date)
echo Script Total Time : $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0