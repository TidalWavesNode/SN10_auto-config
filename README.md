## Bittensor Subnet 10 Map-Reduce Mining Setup
Shell script to install and run a Bittensor Subnet 10 Map-Reduce miner on a Linux server running Ubuntu 22.04 and above.  

This will require a VPS running Ubuntu 22.04 or higher and installs **dream-well/map-reduce-subnet**.
***

## Installation:
Log into the server using ssh (Putty for windows or terminal for Mac users) and run the following commands:
```
wget -q https://raw.githubusercontent.com/TidalWavesNode/SN10_auto-config/main/sn10.sh
bash sn10.sh
```
***

## Notes
It is recommended for the purposes of this script to leave the generated wallet names as "default".
You will need to manually write down the private keys as trying to copy them will cancel the scrtip.
Always back up your private keys in a safe and secure location!

## Prerequisites
For running a miner, you need enough resources. The minimal requirements for running a miner are

Public IP address

Network bandwidth: 1Gbps

RAM: 10GB


### Recommended hardware requirement:

Network bandwidth: 10Gbps

RAM: 32GB

Note: Higher network bandwidth and RAM can lead to more rewards.



