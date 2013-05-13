## Readme

To install IBM's Smart Cloud Analytics Log Analysis (SCALA) open beta and explore scenario2:

1. Install Virtualbox (https://www.virtualbox.org/) (tested with 4.2.12 on Win7)
2. Install Vagrant (http://www.vagrantup.com/) (tested with 1.2.2 on Win7)
3. Download the git repo using either ```git clone https://github.com/dougmcclure/ILA-Open-Beta.git``` or download the repo as a .zip file and unzip
4. Download SCAA OpenBeta Driver 2 (https://www.ibm.com/developerworks/servicemanagement/bsm/log/downloads.html) and place in the /shared/box1-files directory of the repo
5. Open a terminal or Windows command shell and navigate to the box1 repo directory. Issue the ```vagrant up``` command.
6. Open a new terminal or Windows command shell and navigate to the box2 repo directory. Issue the ```vagrant up``` command.

Review these blog posts for more information:

scenario1 http://t.co/CbBvu5gLzG
scenario2 TBD





## Roadmap

Experiments with SCAA and DevOps, IT Operations and Automation Tools

Current Scenarios: <-- add your ideas as enhancements (under issues)

    [COMPLETE] automatically spin up a box and install SCAA OpenBeta Driver 1
    [COMPLETE] automatically spin up multiple networked boxes (host-only private network)
    [COMPLETE] WebSphere Liberty/OnlinePollingServer App --> LFA Push --> SCAA (using CentOS 6.4 Base Box) --> Please see blog for more info: http://t.co/CbBvu5gLzG
    [COMPLETE] Open Beta Milestone 2 Refresh (merged 5/3/13)
    
    [COMPLETE] Scenario2 - App Logs + /var/log/* --> Local Syslog --> Aggregated Log --> LFA --> SCAA (early preview in the Scenario2 branch) (merged 5/12/13)
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

### This work is offered as-is for community use. My ideas and contributions are my own. All materials are posted by me as an individual and are not an expression of support, acceptance or approval of my employer IBM. All materials are to be used within a testing environment and should not be considered worthy of production use without further review and optimization.
