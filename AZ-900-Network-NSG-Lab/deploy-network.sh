#!/bin/bash
# File: deploy-network.sh
# Purpose: My script to demonstrate and solve the Network Security Group (NSG) challenge.
# This validates the understanding of inbound access rules in AZ-900.
# Prerequisite: VM 'my-vm' and RG 'IntroAzureRG' must be active and running Nginx.

# --- Task 0: Variables for Consistency ---
RG_NAME="IntroAzureRG"
VM_NAME="my-vm"
NSG_NAME="my-vmNSG"

# --- Task 1: Access you web server ---
echo "--- 1. DIAGNOSTICS: Attempting Web Access to demonstrate initial failure ---"

# 1a. Get IP Address and store it in a variable
    IPADDRESS="$(az vm list-ip-addresses \
            --resource-group "$RG_NAME" \
            --name $VM_NAME \
            --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
            --output tsv)"

echo "VM Public IP Address: $IPADRESS"

# 1b. Attempt to access the web server (Expected: Connection timed out)
echo "Attempting to access web server on Port 80 (Expected: Timeout)..."
    curl --connect-timeout 5 http://$IPADDRESS

# --- Task 2: List the current network security group rules ---
echo ""
echo "--- 2. DIAGNOSTICS: Listing NSG Rules to identify the block ---"

# 2a. List NSG rules in readable table format
echo "Current NSG Rules (Note Port22/SSH is allowed, Port80 is blocked)"
    az network nsg rule list \
        --resource-group "$RG_NAME" \
        --nsg-name $NSG_NAME \
        --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
        --output table

echo "RESULT: Only SSH is open. HTTP (Port 80) is implicitly denied."
echo "------------------------------------------------------------------------------------------------------"

# --- Task 3: Create the network security rule ---
echo "--- 3. SOLUTION: Creating NSG rule 'allow-http' to open Port 80 ---"

# 3a. Create the new rule to allow inbound access on port 80 with high priority (100)
    az network nsg rule create \
        --resource-group "$RG_NAME" \
        --nsg-name $NSG_NAME \
        --name allow-http \
        --protocol tcp \
        --priority 100 \
        --destination-port-range 80 \
        --access Allow

# 3b. Verification of the new rules
echo "Rules updated. New Rule List (Note priority 100 rule is now present):"
    az network nsg rule list \
        --resource-group "$RG_NAME" \
        --nsg-name $NSG_NAME \
        --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
        --output table

# --- Task 4: Access your web server again ---
echo "--- 4. VERIFICATION: Retrying Web Access (Expected: Success message) ---"

# Pause to allow the NSG rule to fully propagate, as noted in the exercise
sleep 10

# Retry the curl command (Expected: Success message)
    curl --connect-timeout 5 http://$IPADDRESS

echo "------------------------------------------------------------------------------------------------------"
echo "VERIFICATION COMPLETE: Web server access confirmed via port 80."
echo "CLEANUP INSTRUCTIONS: Delete the Resource Group '$RG_NAME' via the Azure portal to avoid costs."
    az group delete --name IntroAzureRG --no-wait -y