#!/bin/bash
# File: deploy.sh
# Purpose: My deployment script for a Linux VM (Ubuntu) with Nginx (IaaS)
# This script automates the creation and configuration of the web server.

# --- 0. Variables for Consistency (Ajouté pour la qualité IaC) ---
RG_NAME="IntroAzureRG"
LOCATION="westeurope"
VM_NAME="my-vm"

# --- Task 1: Create Resource Group ---
echo "--- 1. Creating my main Resource Group: $RG_NAME ---"
    az group create \
        --name $RG_NAME \
        --location $LOCATION

# --- Task 2: Create Linux VM ---
echo "--- 2. Creating my Linux VM '$VM_NAME' with Standard_B1s size ---"
# Using Standard_B1s to ensure capacity availability and optimize costs.
    az vm create \
        --resource-group $RG_NAME \
        --name $VM_NAME \
        --size Standard_B1s \
        --public-ip-sku Standard \
        --image Ubuntu2204 \
        --admin-username azureuser \
        --location $LOCATION \
        --generate-ssh-keys

# --- Task 3: Install Nginx via Custom Script Extension ---
echo "--- 3. Installing Nginx (My responsiblity in IaaS) via custom Script Extension ---"

# This confirms that web server installation is a required post-deployment action I must handle in IaaS.
    az vm extension set \
        --resource-group $RG_NAME \
        --vm-name $VM_NAME \
        --name customScript \
        --publisher Microsoft.Azure.Extensions \
        --version 2.1 \
        --settings '{"fileUris":["https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh"]}' \
        --protected-setting '{"commandToExecute": "./configure-nginx.sh"}'

echo "--- DEPLOYMENT COMPLETE ---"

# Retrieve Public IP Address for verification
    IP_ADDRESS=$(az vm show --resource-group $RG_NAME --name $VM_NAME --query "publicIpAddress" --output tsv)

echo "My VM's Public IP Address is: $IP_ADDRESS"
echo "I can verify the Nginx installation by checking: http://$IP_ADDRESS"

echo "CLEANUP: I must run this command to avoid costs:"
echo "az group delete --name $RG_NAME --no-wait -y"