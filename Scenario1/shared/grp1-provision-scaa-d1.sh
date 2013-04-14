#!/bin/bash
# Vagrant provisioning script for SCAA OpenBeta Driver 1
#
#Doug McClure
#v1.0 3/24/13
#v1.1 4/4/13  Enhancements + changes from c835722 for getting things to work on a CentOS 6.4 box
#v1.2 4/8/13  Enhancements for multi-box scenario #1 - one master SCAA box + one remote LFA box
#v1.3 4/10/13 Added a script timer
#v1.4 4/11/13 Added steps to install original sampleScenario data plus new WebSphere Liberty Demo 
#			  configurations (for multi-box scenario)
#v1.5 4/12/13 Moving all download steps out of this provisioning script and into separate provisioning script
########################################################################################################
#Uncomment this to see verbose install
set -x

#how long does this provisioning script take?
SCRIPT_START=$(date +%s)
echo Started : $(date)

# filename for driver
#driver1 for open beta is IBM_LogAnalyticsWE_Beta_20130321_1359.tar.gz
#driver 1 placed in $PREREQ_DIR/grp1
DRIVER_NAME="IBM_LogAnalyticsWE_Beta_20130321_1359.tar.gz"
GROUP_NAME="scla"
USERNAME="scla"
PASSWORD="scla"
BASE_DIR="/opt/scla"
INSTALL_DIR="$BASE_DIR/driver1"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"
#Main Open Beta Driver
VAGRANT_BOX_1="10.10.10.2"
#Remote App+LFA box
VAGRANT_BOX_2="10.10.10.3"

echo "[SCAA] Turning off SELINUX on this CentOS Box"

#turn off selinux

sudo /usr/sbin/setenforce 0
sudo cp $SHARED_DIR/selinux /etc/sysconfig/selinux

echo "[SCAA] SELINUX Turned Off"

echo "[SCAA] Changing /etc/redhat-release to spoof IIM"
#change the /etc/redhat-release

sudo cp $SHARED_DIR/redhat-release /etc/redhat-release

echo "[SCAA] /etc/redhat-release changed"

echo "[SCAA] Install PREREQ for SCAA Box"

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

#to turn it off for this sesssion to turn it off perm --> sudo chkconfig iptables off

sudo service iptables stop

echo "[SCAA] Fixed iptables rules to allow SCAA to always work" 

echo "[SCAA] Creating Install User and Group"
#create scla user and group

groupadd $GROUP_NAME
useradd -m -g $GROUP_NAME $USERNAME
echo $PASSWORD | passwd $USERNAME --stdin

echo "[SCAA] Install User and Group Created"

echo "[SCAA] Create Directories"
# create base and install directories

sudo mkdir -p $INSTALL_DIR

echo "[SCAA] Directories Created"

#sudo cp $SHARED_DIR/grp1/$DRIVER_NAME $BASE_DIR

#echo "[SCAA] Driver Copied to Install Directory"

echo "[SCAA] Explode the Tarball"

tar -C $BASE_DIR -zxf $SHARED_DIR/grp1/$DRIVER_NAME 

echo "[SCAA] Driver Exploded"

echo "[SCAA] Change Ownership"

sudo chown -R $USERNAME:$GROUP_NAME $BASE_DIR

echo "[SCAA] Install Driver"
#install

#some weird errors at the start that seem harmless - logfile permissions to write?
#/opt/scla/install.sh: line 34: install.log: Permission denied

#when the next driver for open beta is available, the silent install file must be updated for new ports

#silent response file for SCAA must be in the $PREREQ_DIR/grp1 directory

sudo -u $USERNAME $BASE_DIR/install.sh -s $SHARED_DIR/grp1/vagrant_smcl_silent_install.xml

#some weird errors at the end that seem harmless?
#/opt/scla/install.sh: line 34: install.log: Permission denied

echo "[SCAA] Driver 1 Installed"

echo "[SCAA] Install SCAA Sample Data"

#add the install of Daytrader sample scenario

echo "[SCAA] Need to change to the directory to install data"

cd $INSTALL_DIR/sampleScenarios/

sudo -u $USERNAME perl CreateSampleScenario.pl

echo "[SCAA] SCAA Sample Data Installed"


echo "how long does this provisioning script take?"

SCRIPT_STOP=$(date +%s)
SCRIPT_TOTAL_TIME=$(expr $SCRIPT_STOP - $SCRIPT_START)
echo Script Started: $SCRIPT_START
echo Script Ended: $(date)
echo Script Total Time: $(date -d "1970-01-01 $SCRIPT_TOTAL_TIME sec" +%H:%M:%S)

exit 0