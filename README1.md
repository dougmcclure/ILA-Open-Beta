Readme
--------------------
## Please see my blog (http://t.co/CbBvu5gLzG) for the most up to date guide for installing and using Scenario 1.

The following is a draft of the readme for the planned first release of Scenario1 for evaluating IBM's Smart Cloud Analytics for Applications (SCAA, aka Log Analytics).  

1. install virtualbox
2. install vagrant
3. create a host directory for box1 (SCAA OpenBeta D1 Box) - vagrant init then replace Vagrantfile with one from ../shared/box1
4. create a host directory for box2 (SCAA OpenBeta D1 Application + LFA Box)- vagrant init then replace Vagrantfile with one from ../shared/box2
5. create a host shared directory at same level as host directories for box1 & box2 [mounts to /opt/scla/shared on vagrant up]
6. download files from git repot into host shared directory 
7. verify these are in place (other dir/files are added during vagrant up)
 - /shared - contains all vagrant provisioning shell scripts, two files for building base boxes and below directories
 - /shared/box1 - contains Vagrantfile for building box1, copy into the directory you created for box1
 - /shared/box2 - contains Vagrantfile for building box2, copy into the directory you created for box2
 - /shared/grp1 - Contains box1 silent install file, will contain OpenBeta driver1, LibertyDemo folder 
 - /shared/grp1/LibertyDemo - contains files for provisioning OpenBeta driver1 for WebShpere Liberty demo
 - /shared/grp2 - contains LFA configuration files for WebSphere Liberty files, server.xml file to increase logging on WebSphere Liberty
 - /shared/prereq - contains to directories: grp1- all files downloaded for building basics for box1 & box2, grp2- all files needed to build box2 plus WebSphere Liberty and a sample app
 - /shared/prereq/grp1 - files downloaded by download-prereq.sh script, used in building box1 & box2
 - /shared/prereq/grp2 - files downloaded by download-prereq.sh script, used in building box2
8. download SCAA OpenBeta Driver 1 and place in /shared/grp1 directory
9. decide on deployment topology: deployment options - stand alone, scenario1, scenario2, scenario3
 - **standalone-** box1 only with SCAA OpenBeta driver 1 installed using sample DayTrader WebSphere and DB2 logs
 - **scenario1-** box1 (as above) plus box2 with WebSphere Liberty 8.5.next installed using a sample Online Polling application. Using SCAA OpenBeta driver 1 LFA to send application logs to SCAA
 - **scenario2-** future
 - **scenatio3-** future
10. decide if you'll be starting with a standalone SCAA OpenBeta driver 1 scenario will be deployed or the multi-box sample application scenario will be deployed. If just stand alone, then you can comment out the grp1-provision-scenario1.sh provisioning script in box1's Vagrantfile.
 **standalone:** from the directory created for box1, issue vagrant up command
If this is the first time, the following happens
 - the base box is downloaded and spun up assigning an IP Address (10.10.10.2 by default), creating shared folders, etc.
 - provisioning script download_prereq.sh is run which installs one yum plugin package and then downloads all of the other required packages into a local directory. NOTE: This script also downloads WebSphere Liberty 8.5 early access version and a sample application for Liberty (as well as Apache Derby pre-req for that sample app). Verify that you see the two WebSphere Liberty .jars successfully downloaded. If you do not plan on running scenario1 you can comment out those downloads. It's recommended that after the first successful vagrant up for box1 that the download_prereq.sh is commented out in the box1 Vagrantfile. This will allow any subsequent boxes to be spun up and provisioned much quicker.
 - provisioning script grp1-provision-scaa-d1.sh is run which does the actual installation of the required pre-requisites for SCAA OpenBeta driver 1, installs SCAA OpenBeta driver 1 and the DayTrader sample scenario.
 Upon completion of all provisioning scripts, SCAA OpenBeta driver 1 is available at http://10.10.10.2:9988/Unity and will have saved searches available for use.
 **scenario1 box1:**  from the directory created for box1, issue vagrant up command
 If this is the first time, the following happens
 - the base box is downloaded and spun up assigning an IP Address (10.10.10.2 by default), creating shared folders, etc.
 - provisioning script download_prereq.sh is run which installs one yum plugin package and then downloads all of the other required packages into a local directory. This script also downloads WebSphere Liberty 8.5 early access version and a sample application for Liberty (as well as Apache Derby pre-req for that sample app). Verify that you see the two WebSphere Liberty .jars successfully downloaded
 - provisioning script grp1-provision-scaa-d1.sh is run which does the actual installation of the required pre-requesites for SCAA OpenBeta driver 1, installs SCAA OpenBeta driver 1 and the DayTrader sample scenario.
 - provisioning script grp1-provision-scenario1.sh is run (if scenario1 is desired) which extracts the LFA from SCAA OpenBeta driver 1 and places it into the ../shared/grp2/lfa directory, copies the LibertyDemo sample scenario into the proper location and then installs the LibertyDemo elements into SCAA OpenBeta driver 1
 Upon completion of all provisioning scripts, SCAA OpenBeta driver 1 is available at http://10.10.10.2:9988/Unity and will have saved searches available for use.
 It's recommended that after the first successful vagrant up for box1 that the download_prereq.sh is commented out in the box1 Vagrantfile. This will allow any subsequent boxes to be spun up and provisioned much quicker.
 **scenario1 box2:** from the directory created for box2, issue vagrant up command
 - the base box is imported and spun up assigning an IP Address (10.10.10.3 by default), creating shared folders, etc.
 - if needed, the provisioning script download_prereq.sh is available to run if uncommented in Vagrantfile. If run this installs one yum plugin package and then downloads all of the other required packages into a local directory. This script also downloads WebSphere Liberty 8.5 early access version and a sample application for Liberty (as well as Apache Derby pre-req for that sample app). Verify that you see the two WebSphere Liberty .jars successfully downloaded
 - provisioning script grp2-provision-scaa-d1-LFA-only.sh is run which does the actual installation of the required pre-requesites for SCAA OpenBeta driver 1 LFA.
 - provisioning script grp2-provision-was_liberty_demo.sh is run installs WebSphere Liberty 8.5.next, installs the OnlinePollingSample server app and a new server.xml file with lower level logging enabled. The files for the LFA to monitor the OnlinePollingSample server app are installed and the LFA is restarted. At this time log records are ready to send to SCAA OpenBeta driver 1 on box1.
11. Launch SCAA OpenBeta driver 1 by launching your Firefox 17 browser pointing to http://10.10.10.2:9988/Unity and logging in with unityadmin:unityadmin.
12. Launch the Online Polling Sample server app in your browser at http://10.10.10.3:9080/OnlinePollingSampleWeb/VoteServlet.
13. Initialize the Online Polling Sample server app by selecting one of the two options.
14. Cast some votes in the sample app.
15. In the SCAA browser window, click on the 'Liberty_Trace_Log' Quick Search.
16. Review and interact with the results. Look at the 'Discovered Patterns' that are automatically created through analysis of the log records.
17. Click on the 'DT_WAS_SystemOut' Quick Search.
18. Review and interact with the results. Look at the 'Configured Patterns' that are developed as part of the WebSphere Insight Packs. 
19. Provide feedback!!


This work is offered as-is for community use. My ideas and contributions are my own. All materials are posted by me as an individual and are not an expression of support, acceptance or approval of my employer IBM. All materials are to be used within a testing environment and should not be considered worthy of production use without further review and optimization.
