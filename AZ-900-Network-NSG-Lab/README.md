# My AZ-900 Portfolio Project: Network Security Group (NSG) Configuration

## Project Overview & Objective

This repository contains the files for my second hands-on lab, focusing on **Network Security** and the crucial role of **Network Security Groups (NSG)** in an Azure environment. This is a core component of the AZ-900 certification.

My goal was to use **Infrastructure as Code (IaC)** to diagnose and resolve an intentional security block, confirming my responsibilities on the network layer.

### The Challenge: What I had to Do

The core task was to ensure network accessibility to the already-deployed web server:

1. **Diagnosis:** Confirm that the Nginx web server (Port 80) is **inaccessible** via the Public IP address.
2. **Verification:** List the current NSG rules to understand **why** the traffic is blocked.
3. **Correction:** Implement a new, high-priority NSG rule using **Azure CLI** to allow inbound HTTP traffic on Port 80.
4. **Validation:** Confirm that the web server is now accessible.

---

## My Technical Approach

I used a single, repeatable Bash script ('deploy-network.sh') that groups the Azure CLI commands to handle the diagnostic and correction cycle.

### How I Implemented It

| Step | AZ CLI Command Summary | Technical Rationale |
| :--- | :--- | :--- |
| **Initial Access Test** | 'curl --connect-timeout 5 http://[IP]' | Confirmed the **security block** and the inability to establish a TCP connection on Port 80. |
| **Rule Listing** | 'az network nsg rule list' | Explicitly showed that the only default inbound rule was **Port 22 (SSH)**, validating the "Deny All" security principle. |
| **NSG Correction** | 'az network nsg rule create' | Created a new rule (`allow-http`, Priority 100) to explicitly **override** the implicit deny rule, opening the network boundary for web traffic. |
| **Final Access Test** | 'curl http://[IP]' | Validated the successful implementation of the new NSG rule by receiving the Nginx welcome page. |

### Core Learning: Understanding NSG

As part of this exercise, I confirmed the importance of the NSG:

* **In Azure Networking:** The NSG is essential. It acts as a **firewall** applied at the network card (NIC) level to control inbound and outbound traffic.
* **Primary Role:** **Securing the IaaS resource.** By default, it denies non-essential traffic, enforcing the **least privilege** security model.
* **Responsibility:** **I must configure the NSG** to allow specific services (like HTTP/80 or HTTPS/443), confirming this is part of my responsibility when managing a VM.

---

## Problem Solving: Execution & Validation

I completed this lab **without encountering any technical errors**, proving the robustness of the IaC script and the clarity of the NSG configuration.

| State | Command Result | Proof of Competency |
| :-- | :-- | :-- |
| **Initial State** | `Connection timed out` | Confirmed the **NSG was correctly enforcing the security policy** (blocking traffic). |
| **Final State** | `Welcome to Azure! My name is my-vm.` | Confirmed **successful deployment and precedence** of the new explicit NSG rule (`allow-http`, Priority 100). |

**Takeaway:** This confirmed that I can efficiently diagnose network security issues and apply corrective measures using controlled IaC commands.

## Cost Management & Clean-Up

To ensure this deployment does not incur ongoing costs, I use the Resource Group deletion command:

### Deletes IntroAzureRG, including the VM, disk, IP address, NSG, and all associated costs.
az group delete --name IntroAzureRG --no-wait -y