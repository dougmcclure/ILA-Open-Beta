#!/bin/bash
# Vagrant provisioning script for
# IBM Log Analytics Milestone Driver 1
#
#Doug McClure
#v1.0 3/24/13
#v1.1 4/4/13 Enhancements + changes from c835722 for getting things to work on a CentOS 6.4 box
#v1.2 4/8/13 Enhancements for multi-box scenario #1 - one master ILA box + one remote LFA box
#
#
#Uncomment this to see verbose install
set -x

# filename for driver
#driver1 for open beta is IBM_LogAnalyticsWE_Beta_20130321_1359.tar.gz
DRIVER_NAME="IBM_LogAnalyticsWE_Beta_20130321_1359.tar.gz"
GROUP_NAME="scla"
USERNAME="scla"
PASSWORD="scla"
BASE_DIR="/opt/scla"
INSTALL_DIR="$BASE_DIR/driver1"
#Main Open Beta Driver
VAGRANT_BOX_1="10.10.10.2"
#Remote LFA box
VAGRANT_BOX_2="10.10.10.3"

echo "[ILA] Turning off SELINUX on this CentOS Box"

#turn off selinux

sudo /usr/sbin/setenforce 0
sudo cp /vagrant/selinux /etc/sysconfig/selinux

echo "[ILA] SELINUX Turned Off"

echo "[ILA] Changing /etc/redhat-release to spoof IIM"
#change the /etc/redhat-release

sudo cp /vagrant/redhat-release /etc/redhat-release

echo "[ILA] /etc/redhat-release changed"

echo "[ILA] Install compat-libstdc++-33 for LFA"
#update the driver package for LFA

yum -y install compat-libstdc++-33

echo "[ILA] compat-libstdc++-33 Installed"

#only needed for the Puppet Labs CentOS 6.4 box (assume any CentOS/RedHat 6 box) 
#Thanks to c835722!

echo "[ILA] centros64 fix changes start"

yum -y install redhat-lsb
yum -y install compat-libstdc++-33.i686
yum -y install ksh.x86_64 

echo "[ILA] centros64 fix changes end" 

#for syncing files between boxes
yum -y install rsync

echo "[ILA] Change iptables rules to allow ILA to always work" 

#to turn it off for this sesssion 
sudo service iptables stop

#to turn it off perm
# sudo chkconfig iptables off

echo "[ILA] Fixed iptables rules to allow ILA to always work" 

echo "[ILA] Creating Install User and Group"
#create scla user and group

groupadd $GROUP_NAME
useradd -m -g $GROUP_NAME $USERNAME
echo $PASSWORD | passwd $USERNAME --stdin

echo "[ILA] Install User and Group Created"

echo "[ILA] Create Directories"
# create base and install directories

mkdir -p $INSTALL_DIR

echo "[ILA] Directories Created"

echo "[ILA] Copy ILA Driver to Install Directory"
#copy open beta driver from host /vagrant directory

cp /vagrant/$DRIVER_NAME $BASE_DIR

echo "[ILA] Driver Copied to Install Directory"

echo "[ILA] Explode the Tarball"

tar zxf $BASE_DIR/$DRIVER_NAME -C $BASE_DIR

echo "[ILA] Driver Exploded"

echo "[ILA] Change Ownership"

chown -R $USERNAME:$GROUP_NAME $BASE_DIR

echo "[ILA] Install Driver"
#install

#some weird errors at the start that seem harmless - logfile permissions to write?
#/opt/scla/install.sh: line 34: install.log: Permission denied

#when the next driver for open beta is available, the silent install file must be updated for new ports

sudo -u $USERNAME $BASE_DIR/install.sh -s /vagrant/vagrant_smcl_silent_install.xml

#some weird errors at the end that seem harmless?
#/opt/scla/install.sh: line 34: install.log: Permission denied

echo "[ILA] Driver Installed"

######
#
# Uncomment below if you want to build out the multi-box scenarios
#
#####
#
#echo "[ILA] Copy LFA Files to host /vagrant/lfa directory"
#
#mkdir -p /vagrant/lfa/unity_images
#mkdir -p /vagrant/lfa/work_files/Configurations/Data_Collector
#
#cp $INSTALL_DIR/setupScripts/ITM_Log_Agent_Setup.sh /vagrant/lfa
#cp $INSTALL_DIR/unity_images/LFA_ITM_FP9.tar.gz /vagrant/lfa/unity_images
#cp $INSTALL_DIR/unity_images/6.2.3.2-TIV-ITM_LFA-IF0002.tar /vagrant/lfa/unity_images
#cp $INSTALL_DIR/work_files/Configurations/Data_Collector/* /vagrant/lfa/work_files/Configurations/Data_Collector/

#when the remote LFA box is provisioned, an rsync connection via ssh will copy all of the files over

#echo "[ILA] LFA Files Ready for Copying to Remote Systems from host /vagrant/lfa directory"

end
