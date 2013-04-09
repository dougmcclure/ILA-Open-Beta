#!/bin/bash
# Vagrant provisioning script for
# IBM Log Analytics Milestone Driver
#
#Doug McClure
#v1.0 3/24/13
#
#
#Uncomment this to see verbose install
set -x

# filename for driver
DRIVER_NAME="IBM_LogAnalyticsWE_Beta_20130321_1359.tar.gz"
GROUP_NAME="scla"
USERNAME="scla"
PASSWORD="scla"

echo "[ILA] Turning off SELINUX on this CentOS Box"

#turn off selinux
# echo 0 > /usr/sbin/selinux/enforce (only turns off until reboot)
# sudo /usr/sbin/setenforce 0
#must edit /etc/sysconfig/selinux to perm turn off
#chagne SELINUX=permissive to SELINUX=disabled

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

echo "[ILA] Creating Install User and Group"

#create scla user and group

groupadd $GROUP_NAME

useradd -m -g $GROUP_NAME $USERNAME
echo $PASSWORD | passwd $USERNAME --stdin

echo "[ILA] Install User and Group Created"

echo "[ILA] Create Install Directory"

# create install directory

mkdir /opt/scla
mkdir /opt/scla/driver1

echo "[ILA] Install Directories Created"


echo "[ILA] Copy ILA Driver to Install Directory"

#copy driver from /vagrant

cp /vagrant/$DRIVER_NAME /opt/scla

echo "[ILA] Driver Copied to Install Directory"

echo "[ILA] Explode the Tarball"

tar zxf /opt/scla/$DRIVER_NAME -C /opt/scla/

echo "[ILA] Driver Exploded"

echo "[ILA] Change Ownership"

chown -R scla:scla /opt/scla

echo "[ILA] Install Driver"

#install

#some weird errors at the start that seem harmless - logfile permissions to write?
#/opt/scla/install.sh: line 34: install.log: Permission denied

sudo -u $USERNAME /opt/scla/install.sh -s /vagrant/vagrant_smcl_silent_install.xml

#some weird errors at the end that seem harmless?
#/opt/scla/install.sh: line 34: install.log: Permission denied

echo "[ILA] Driver Installed"

echo "[ILA] Install IBM Log Analytics Sample Data"
#add the install of sample scenario

echo "[ILA] Need to change to the directory to install data"

cd /opt/scla/driver1/sampleScenarios/

perl CreateSampleScenario.pl

echo "[ILA] IBM Log Analytics Sample Data Installed"


end
