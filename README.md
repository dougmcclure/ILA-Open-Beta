Readme
--------------------
Installing IBM's Smart Cloud Analytics for Applications (SCAA, aka Log Analytics).  

To install and run the single box scenario :

1. Install Virtualbox (https://www.virtualbox.org/)
2. Install Vagrant (http://www.vagrantup.com/)
3. ```git clone https://github.com/dougmcclure/ILA-Open-Beta.git``` (If you don't have git installed, I think you can just download the repo as a .zip)
4. Download SCAA OpenBeta Driver 1 and place in /shared directory (updates for driver 2 soon!)
5. ```cd box1 && vagrant up```

Review the blog post here (http://t.co/CbBvu5gLzG) from the "Configured Patterns" section for a guided demo.

To install and run the multi box scanario add the additional step(s) :

6. ```cd box2 && vagrant up```

Review the blog post here (http://t.co/CbBvu5gLzG) from the "Launch Websphere Liberty Sample Application" section for a guided demo.


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
