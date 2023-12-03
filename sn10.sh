#!/bin/bash

# SN10 Script

echo "Starting Bittensor Subnet 10 setup script..."

# Installation (System update, upgrade, and installation of pm2)
read -p "Update, upgrade system, and install pm2? (y/n): " answer
if [[ $answer == "y" ]]; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install nodejs npm -y
    sudo npm i -g pm2

else
echo "User declined the step. Exiting the script."
exit 1
    
fi

# Clone the repository from Github and Install Dependencies
read -p "Clone the SN10 repository and install dependencies? (y/n): " answer
if [[ $answer == "y" ]]; then
    git clone https://github.com/dream-well/map-reduce-subnet
    cd map-reduce-subnet || exit
    sudo apt install python3-pip -y
    python3 -m pip install -e ./

else
echo "User declined the step. Exiting the script."
exit 1

fi

# Build rust binary
read -p "Build rust binary? (y/n): " answer
if [[ $answer == "y" ]]; then
    cd ~/map-reduce-subnet/neurons || exit
    sudo apt install rustc -y
    sudo apt install cargo -y
    sudo apt-get install libsqlite3-dev -y
    cargo build --release

else
echo "User declined the step. Exiting the script."
exit 1

fi

# Generate miner coldkey wallet (coldkey)
read -p "Generate coldkey? (y/n): " answer
if [[ $answer == "y" ]]; then
    btcli w new_coldkey

else
echo "User declined the step. Exiting the script."
exit 1

fi

# Generate miner coldkey wallet (coldkey)
read -p "Generate hotkey? (y/n): " answer
if [[ $answer == "y" ]]; then
    btcli w new_hotkey

else
echo "User declined the step. Exiting the script."
exit 1

fi

# BACKUP YOUR PRIVATE KEYS OUTSIDE THE SERVER!!!!
read -p "Back up the private keys displayed above? (y/n): " answer
if [[ $answer != "y" ]]; then
    echo "Always ensure you have backed up your PRIVATE KEYS somewhere secure!"

else 
echo "User declined the step. Exiting the script."
exit 1

fi

# Fund your cold wallet with enough TAO to cover Recycling (Registration Fee)
read -p "Get wallet address to fund your coldkey? (y/n): " answer
if [[ $answer == "y" ]]; then
    btcli wallet list

else
echo "User declined the step. Exiting the script."
exit 1

fi

read -p "Before proceeding ensure the wallet been funded with TAO? (y/n): " answer
if [[ $answer != "y" ]]; then
    echo "Time to attempt to register your hotkey"
    exit 1
fi

# Attempt registration of the hotkey
read -p "Attempt registration of the hotkey? (y/n): " answer
if [[ $answer == "y" ]]; then
    btcli s register --subtensor.network finney --netuid 10
    # Note: This step may take several attempts before registering successfully

else
echo "User declined the step. Exiting the script."
exit 1

fi

# Start Miner with default parameters
read -p "Start Mining Subnet 10 with default parameters? (y/n): " answer
if [[ $answer == "y" ]]; then
    pm2 start miner.py --name SN10MINER --interpreter python3 -- --netuid 10 --subtensor.network finney --wallet.name default --wallet.hotkey default --logging.debug --auto_update patch

else
echo "User declined the step. Exiting the script."
exit 1

fi

echo "SN10 setup script completed."

# Monitor the PM2 processes
pm2 monit
