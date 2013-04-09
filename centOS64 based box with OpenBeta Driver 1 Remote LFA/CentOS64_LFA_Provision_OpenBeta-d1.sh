#!/bin/bash
# Vagrant provisioning script for Remote LFA Box
# Used for demonstrating IBM Log Analytics Milestone Driver 1
# Remote LFA Operations
#
#Doug McClure
#v1.0 4/6/13 Base CentOS 6.4 box with OpenBeta Driver 1 LFA
#v1.1 4/8/13 Enhancements for multi-box scenario #1 - one master ILA box + one remote LFA box
#
#
#Uncomment this to see verbose install
set -x

#variables
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

#only needed for the Puppet Labs CentOS 6.4 box (assume any CentOS/RedHat 6 box) 
#Thanks to c835722!

echo "[ILA] centros64 fix changes start"

yum -y install redhat-lsb
yum -y install compat-libstdc++-33.i686
yum -y install ksh.x86_64 

#for syncing files between boxes
yum -y install rsync

echo "[ILA] centros64 fix changes end" 

echo "[ILA] Change iptables rules to allow ILA to always work" 

#to turn it off for this sesssion 
sudo service iptables stop

#to turn it off perm
# sudo chkconfig iptables off

echo "[ILA] Fixed iptables rules to allow ILA to work" 

echo "[ILA] Creating Install User and Group"
#create scla user and group

groupadd $GROUP_NAME

useradd -m -g $GROUP_NAME $USERNAME
echo $PASSWORD | passwd $USERNAME --stdin

echo "[ILA] Install User and Group Created"

echo "[ILA] Create Directories"
# create base and install directory

mkdir -p $INSTALL_DIR

echo "[ILA] Directories Created"

echo "[ILA] Copy LFA Files to Install Directory"

#Requirement: Be able to automate the collection and installation of the LFA files from the main ILA box
#
#Create ssh passwordless login between remote lfa box and main scla box so we can automate rsych w/o password prompt

sudo -u $USERNAME ssh-keygen -t rsa -f /home/$USERNAME/.ssh/id_rsa -P ""

#BROKEN: Ideally this command would work to copy public key to remote server but I can't figure out how to automate it w/o having to interact with it
#
#sudo -u $USERNAME ssh-copy-id -i /home/$USERNAME/.ssh/id_rsa.pub $USERNAME@$VAGRANT_BOX_1

#ATTEMPTED WORKAROUND hacked a script I found on net that did similar

PUBKEY="/home/scla/.ssh/id_rsa.pub"
PUBKEYCODE=`cat $PUBKEY`
echo "Copying your public key to $VAGRANT_BOX_1... "

ssh -q $USERNAME@$VAGRANT_BOX_1 "mkdir /home/scla/.ssh 2>/dev/null; chmod 700 /home/scla/.ssh; echo "$PUBKEYCODE" >> /home/scla/.ssh/authorized_keys; chmod 644 /home/scla/.ssh/authorized_keys"

echo "Public key has been copied to $VAGRANT_BOX_1"

#BROKEN: Use rsync to copy the needed LFA files from remote driver1 box to remote lfa box
#
# getting errors with this still...

sudo -u $USERNAME rsync -avz -e "ssh -o StrictHostKeychecking=no" $USERNAME@$VAGRANT_BOX_1:/vagrant/lfa/ $INSTALL_DIR

echo "[ILA] Driver Copied to Install Directory"

echo "[ILA] Install LFA"
#install 

#lfa directory created by rsync transfer (I think...)

cd $INSTALL_DIR/lfa

#sudo needed / root needed??

sudo -u $USERNAME ./ITM_Log_Agent_Setup.sh $INSTALL_DIR/lfa $INSTALL_DIR/lfa   #<-- creates an install dir under IBM-LFA-6.23

#Log will be present under $INSTALL_DIR/unity_itm_logagent_setup_$(date +%m%d%y%S).log

#make sure all files are owned by install user/group (scla)

sudo chown -R $USERNAME:$GROUP_NAME $BASE_DIR

echo "[ILA] Driver Installed"

#initial testing/install it was installed as root and started up the LFA as root, if this still happens need to 
#kill the LFA process that's running as root and restart as scla

#$INSTALL_DIR/lfa/IBM-LFA-6.23/bin/itmcmd agent -o default_workload_instance stop lo
#$INSTALL_DIR/lfa/IBM-LFA-6.23/bin/itmcmd agent -o default_workload_instance start lo

#
#
#Scenario idea - simulate remote application/middleware logs being monitored by this LFA and shipped to ILA box
#
#alternate might be to install the community edition of WebSphere or new Liberty profile, or community version of DB2?
#
#

# - would need to ensure that the proper source, collection and log sources are configured on main ILA box first before logs placed into directory LFA monitors
#-- Create a new script here that can be run on the remote system? or run locally on the remote system?
#Build a logfile, source, collection via scripts from driver1


#
#config files to send logs to remote SCLA host

#/opt/scla/driver1/lfa/IBM-LFA-6.23/config/lo

#[scla@localhost lo]$ ls -l
#total 16
#-rwxr-xr-x 1 scla scla 3381 Apr  8 16:21 lfadb2.conf
#-rwxr-xr-x 1 scla scla  141 Apr  8 16:21 lfadb2.fmt
#-rwxr-xr-x 1 scla scla 3381 Apr  8 16:21 lfawas.conf
#-rwxr-xr-x 1 scla scla  141 Apr  8 16:21 lfawas.fmt

#in the .conf file, update with the remote ILA box

#ServerLocation=EIF_SERVER_IP
#ServerPort=EIF_SERVER_PORT

# - this could be simulated by uploading some of my WebSphere and DB2 logs here and placing them into the monitored directories by LFA

#LogSources=/opt/scla/driver1/lfa/logsources/was/*
#copy sample WAS file into monitored dir

#LogSources=/opt/scla/driver1/lfa/logsources/db2/*
#copy sample DB2 file into monitored dir



end
