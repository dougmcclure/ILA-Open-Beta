## Scenario2 Overview (pre-blog):

### This scenario demonstrates a number of key building block concepts for local log collection, edge processing, shipping and optimized use of the SCAA Generic Annotator.

Scenario 2 introduces the use of rsyslog (a common component of many linux distros) on each box. Syslog offers many different architectural patterns for log collection, processing, shipping and relay. I'll be talking about a few of these patterns for syslog usage with SCAA over a few of the scenarios. In scenario2 specifically, we'll be using each box's rsyslog installation to act as a local log consolidator. We'll take all of the normal /var/log/* logs on each box plus the application logs on that box (box1 - a few SCAA logs, box2 - liberty logs) and mashing them up into a single aggregated logfile. A customized rsyslog template is applied to that file to format the log messages in an optimized KVP format suitable for processing by SCAA's Generic Annotator. The consolidated file is then shipped off to SCAA for processing using the local box LFA. SCAA is provisioned with the proper source type, collection, log sources and quick searches to be allow you to quickly interact with each box's logs.

Readme
--------------------
Installing IBM's Smart Cloud Analytics for Applications (SCAA, aka Log Analytics).  

To install and run the single box scenario :

<<<<<<< HEAD
1. Install Virtualbox (https://www.virtualbox.org/) (tested with 4.2.12 on Win7)
2. Install Vagrant (http://www.vagrantup.com/) (tested with 1.2.2 on Win7)
=======
1. Install Virtualbox (https://www.virtualbox.org/) (tested using 4.2.12 on Windows 7)
2. Install Vagrant (http://www.vagrantup.com/) (tested using v1.2.2 on Windows 7)
>>>>>>> origin/Scenario2
3. Download the git repo using either ```git clone https://github.com/dougmcclure/ILA-Open-Beta.git``` or download the repo as a .zip file and unzip
4. Download SCAA OpenBeta Driver 2 (https://www.ibm.com/developerworks/servicemanagement/bsm/log/downloads.html) and place in the /shared/box1-files directory of the repo
5. Open a terminal or Windows command shell and navigate to the box1 repo directory. Issue the ```vagrant up``` command.

Review the blog post here (http://t.co/CbBvu5gLzG) from the "Configured Patterns" section for a guided demo.

To install and run the multi box scanario add the additional step(s) :

6. Open a new terminal or Windows command shell and navigate to the box2 repo directory. Issue the ```vagrant up``` command.

Review the blog post here (http://t.co/CbBvu5gLzG) from the "Launch Websphere Liberty Sample Application" section for a guided demo.





Roadmap
------------
Experiments with SCAA and DevOps, IT Operations and Automation Tools

Current Scenarios: <-- add your ideas as enhancements (under issues)

    [COMPLETE] automatically spin up a box and install SCAA OpenBeta Driver 1
    [COMPLETE] automatically spin up multiple networked boxes (host-only private network)
    [COMPLETE] WebSphere Liberty/OnlinePollingServer App --> LFA Push --> SCAA (using CentOS 6.4 Base Box) --> Please see blog for more info: http://t.co/CbBvu5gLzG
    [COMPLETE] Open Beta Milestone 2 Refresh (merged 5/3/13)
    
    Scenario2 - App Logs + /var/log/* --> Local Syslog --> Aggregated Log --> LFA --> SCAA (early preview in the Scenario2 branch)
    Scenario3 - App Logs + /var/log/* --> Central Syslog --> SCAA
    App/OS <-- New LFA Remote Pull --> SCAA (need M3 driver fixes)
    App/OS --> Alternate LogShippers --> SCAA
    App --> log4j --> SCAA
    Netcool/OMNIBus Events --> SCAA
    LFA Cluster(s) --> SCAA
    "SCAA LogCloud" -- OpenStack Based Log Analytics Cloud Environment

Operational Best Practices Development: <-- add your ideas as enhancements (under issues)

Current Experiments: <-- add your ideas as enhancements (under issues)

    centOS58 based box with OpenBeta Driver 1: How to build a CentOS58 based box and provision it with ILA Open Beta Driver 1
    centOS64 based box with OpenBeta Driver 1: How to build a CentOS64 based box and provision it with ILA Open Beta Driver 1
    centOS64 based box with OpenBeta Driver 1 Remote LFA: How to build a CentOS 64 based box and provision it with the ILA Open Beta Driver 1 LFA
    How to build a RedHat 6.4 base box
    How to use that RedHat 6.4 base box with ILA
    Chef based provisioning

This work is offered as-is for community use. My ideas and contributions are my own. All materials are posted by me as an individual and are not an expression of support, acceptance or approval of my employer IBM. All materials are to be used within a testing environment and should not be considered worthy of production use without further review and optimization.
