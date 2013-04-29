#!/bin/bash
# Vagrant provisioning script for SCAA OpenBeta Drivers
#
#Doug McClure
#v1.0 3/24/13
#v1.1 4/4/13  Enhancements + changes from c835722 for getting things to work on a CentOS 6.4 box
#v1.2 4/8/13  Enhancements for multi-box scenario #1 - one master SCAA box + one remote LFA box
#v1.3 4/10/13 Added a script timer
#v1.4 4/11/13 Added steps to install original sampleScenario data plus new WebSphere Liberty Demo 
#			  configurations (for multi-box scenario)
#v1.5 4/12/13 Moving all download steps out of this provisioning script and into separate provisioning script
#v1.6 4/25/13 Updates for Milestone Driver #2
########################################################################################################
#System Reference:
#box1-driver: 10.10.10.2
#box2-liberty: 10.10.10.3
#
#
###################
#Uncomment this to see verbose install
set -x

#how long does this provisioning script take?
SCRIPT_START=$(date +%s)
echo Started : $(date)

# filename for driver
#driver2 for open beta is IBM_LogAnalyticsWE_Beta_20130424_0448.tar.gz

DRIVER_NAME="IBM_LogAnalyticsWE_Beta_20130424_0448.tar.gz"
GROUP_NAME="scla"
USERNAME="scla"
PASSWORD="scla"
BASE_DIR="/opt/scla"
INSTALL_DIR="$BASE_DIR/driver"
SHARED_DIR="/opt/scla/shared"
PREREQ_DIR="/opt/scla/shared/prereq"

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
#compat-libstdc++-33, redhat-lsb, redhat-lsb-core-4.0-7.el6.centos.i686 compat-libstdc++-33.i686, ksh.x86_64
#

#sudo yum install -y yum-downloadonly

#sudo yum -y install compat-libstdc++-33 --downloadonly --downloaddir=$PREREQ_DIR/grpM2
#sudo yum -y install redhat-lsb --downloadonly --downloaddir=$PREREQ_DIR/grpM2
#check into why this isn't d/l with the above - this adds /usr/bin/lsb-release needed for M2 driver.
#sudo yum -y install redhat-lsb-core-4.0-7.el6.centos.i686 --downloadonly --downloaddir=$PREREQ_DIR/grpM2
#sudo yum -y install compat-libstdc++-33.i686 --downloadonly --downloaddir=$PREREQ_DIR/grpM2
#sudo yum -y install ksh.x86_64 --downloadonly --downloaddir=$PREREQ_DIR/grpM2

### is there a way to lay down without yum going online to do dep checks? just using rpm command maybe??

sudo yum -y localinstall $PREREQ_DIR/common/*.rpm

#add this to pre-req script!!
#ISCLA908E ERROR: lsb_release binary is not installed on the system ...
#Installation of IBM Log Analytics Workgroup Edition requires lsb_release b
#Install RPM Package for LSB (Linux Standard Base) and re-try installation

#sudo yum -y install redhat-lsb-core-4.0-7.el6.centos.i686

echo "[SCAA] Change iptables rules to allow SCAA to always work" 

#to turn it off for this sesssion to turn it off perm --> sudo chkconfig iptables off
#
#if you do a vagrant suspend or halt then you'll have to rerun this command again (assuming you're not provisioning again)
#
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

echo "[SCAA] Explode the Tarball"

tar -C $BASE_DIR -zxf $SHARED_DIR/box1-files/$DRIVER_NAME 

echo "[SCAA] Driver Exploded"

echo "[SCAA] Change Ownership"

sudo chown -R $USERNAME:$GROUP_NAME $BASE_DIR

echo "[SCAA] Install Driver"
#install

#some weird errors at the start that seem harmless - logfile permissions to write?
#/opt/scla/install.sh: line 34: install.log: Permission denied

sudo -u $USERNAME $BASE_DIR/install.sh -s $SHARED_DIR/box1-files/vagrant_smcl_silent_install_v2.xml

#some weird errors at the end that seem harmless?
#/opt/scla/install.sh: line 34: install.log: Permission denied

echo "[SCAA] Driver 2 Installed"

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