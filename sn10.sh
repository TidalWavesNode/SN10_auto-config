#!/bin/bash

# SN10 Script

echo "Starting SN10 setup script..."

# Installation (System update, upgrade, and installation of pm2)
read -p "This script will setup and run a miner on Bittensor ubnet 10 Map-Reduce-Subnet. Continue? (y/n): " answer
# Convert the answer to lowercase
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

# Check if the answer is 'no'
if [[ $answer == "n" || $answer == "no" ]]; then
    echo "Exiting the script."
    exit 0
fi

# If the answer is not 'no', the script will continue
echo "Lets get started..."

read -p "Update, upgrade system, and install pm2? (y/n): " answer
if [[ $answer == "y" ]]; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install nodejs npm -y
    sudo npm i -g pm2
fi

# Clone the repository from Github and Install Dependencies
read -p "Clone the SN10 repository and install dependencies? (y/n): " answer
if [[ $answer == "y" ]]; then
    git clone https://github.com/dream-well/map-reduce-subnet
    cd map-reduce-subnet || exit
    sudo apt install python3-pip -y
    python3 -m pip install -e ./
fi

# Build rust binary
read -p "Build rust binary? (y/n): " answer
if [[ $answer == "y" ]]; then
    cd ~/map-reduce-subnet/neurons || exit
    sudo apt install rustc -y
    sudo apt install cargo -y
    sudo apt-get install libsqlite3-dev -y
    cargo build --release
fi

# Generate miner wallets (coldkey/hotkey)
read -p "Generate coldkey/hotkey? (y/n): " answer
if [[ $answer == "y" ]]; then
    btcli w new_coldkey
    btcli w new_hotkey
fi

# BACKUP YOUR PRIVATE KEYS OUTSIDE THE SERVER!!!!
read -p "Have you backed up your private keys? (y/n): " answer
if [[ $answer != "n" ]]; then
    echo "Please back up your private keys before proceeding."
    exit 1
fi

# Fund your cold wallet with enough TAO to cover Recycling (Registration Fee)
read -p "Get wallet address to fund your coldkey? (y/n): " answer
if [[ $answer == "y" ]]; then
    btcli wallet list
fi

read -p "Has the wallet been funded with TAO? (y/n): " answer
if [[ $answer != "n" ]]; then
    echo "Please fund your wallet before proceeding."
    exit 1
fi

# Attempt registration of the hotkey
read -p "Attempt registration of the hotkey? (y/n): " answer
if [[ $answer == "y" ]]; then
    btcli s register --subtensor.network finney --netuid 10
    # Note: This step may take several attempts before registering successfully
fi

# Start Miner with default parameters
read -p "Start Mining Subnet 10 with default parameters? (y/n): " answer
if [[ $answer == "y" ]]; then
    pm2 start miner.py --name SN10MINER --interpreter python3 -- --netuid 10 --subtensor.network finney --wallet.name default --wallet.hotkey default --logging.debug --auto_update patch
fi

echo "SN10 setup script completed."

# Monitor the PM2 processes
pm2 monit
