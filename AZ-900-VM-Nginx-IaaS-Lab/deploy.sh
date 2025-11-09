#!/bin/bash
# File: deploy.sh
# Purpose: My deployment script for a Linux VM (Ubuntu) with Nginx (IaaS)
# This script automates the creation and configuration of the web server.

# --- Task 1: Create Resource Group ---
echo "--- 1. Creating my main Resource Group: IntroAzureRG ---"
az group create \
    --name IntroAzureRG \
    --location westeurope

# --- Task 2: Create Linux VM ---
echo "--- 2. Creating my Linux VM 'my-vm' with Standard_B1s size ---"
# Using Standard_B1s to ensure capacity availability and optimize costs.
az vm create \
    --resource-group "IntroAzureRG" \
    --name my-vm \
    --size Standard_B1s \
    --public-ip-sku Standard \
    --image Ubuntu2204 \
    --admin-username azureuser \
    --location westeurope \
    --generate-ssh-keys

# --- Task 3: Install Nginx via Custom Script Extension ---
echo "--- 3. Installing Nginx (My responsiblity in IaaS) via custom Script Extension ---"
# This confirms that web server installation is a required post-deployment action I must handle in IaaS.
az vm extension set \
    --resource-group "IntroAzureRG" \
    --vm-name my-vm \
    --name customScript \
    --publisher Microsoft.Azure.Extensions \
    --version 2.1 \
    --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
    --protected-setting '{"commandToExecute": "./configure-nginx.sh"}'

echo "--- DEPLOYMENT COMPLETE ---"

# Retrieve Public IP Address for verification
IP_ADDRESS=$(az vm show --resource-group IntroAzureRG --name my-vm --query "publicIpAddress" --output tsv)
echo "My VM's Public IP Address is: $IP_ADDRESS"
echo "I can verify the Nginx installation by checking: http://$IP_ADDRESS"

echo "CLEANUP: I must run this command to avoid costs:"
echo "az group delete --name IntroAzureRG --no-wait -y"