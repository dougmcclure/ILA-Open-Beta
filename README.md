Readme
--------------------
Installing IBM's Smart Cloud Analytics for Applications (SCAA, aka Log Analytics).  

To install and run the single box scenario :

1. Install Virtualbox (https://www.virtualbox.org/)
2. Install Vagrant (http://www.vagrantup.com/)
3. Download the git repo using either ```git clone https://github.com/dougmcclure/ILA-Open-Beta.git``` or download the repo as a .zip file and unzip
4. Download SCAA OpenBeta Driver 2 (https://www.ibm.com/developerworks/servicemanagement/bsm/log/downloads.html) and place in the /shared/box1-files directory of the repo
5. Open a terminal or Windows command shell and navigate to the box1 repo directory. Issue the ```vagrant up``` command.

Review the blog post here (http://t.co/CbBvu5gLzG) from the "Configured Patterns" section for a guided demo.

Review the blog post here (http://t.co/CbBvu5gLzG) from the "Configured Patterns" section for a guided demo.

To install and run the multi box scanario add the additional step(s) :

6. Open a new terminal or Windows command shell and navigate to the box2 repo directory. Issue the ```vagrant up``` command.

Review the blog post here (http://t.co/CbBvu5gLzG) from the "Launch Websphere Liberty Sample Application" section for a guided demo.

## Note: They are not keeping old milestone drivers available during the open beta. This means the above won't work unless you've got a copy of M1 already. The refresh for milestone 2 driver is available in the M2 Driver Support + Clean Up branch. I am awaiting some validation testing by others before merging.



Roadmap
------------
Experiments with SCAA and DevOps, IT Operations and Automation Tools

Current Scenarios: <-- add your ideas as enhancements (under issues)

    [COMPLETE] automatically spin up a box and install SCAA OpenBeta Driver 1
    [COMPLETE] automatically spin up multiple networked boxes (host-only private network)
    automatically spin up multiple networked boxes in common deployment and usage patterns

    [COMPLETE - merged 4.23.13] WebSphere Liberty/OnlinePollingServer App --> LFA Push --> SCAA (using CentOS 6.4 Base Box) --> Please see blog for more info: http://t.co/CbBvu5gLzG

    Open Beta Milestone 2 Refresh
    App/OS <-- New LFA Remote Pull --> SCAA
    App/OS --> Syslog --> SCAA
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
