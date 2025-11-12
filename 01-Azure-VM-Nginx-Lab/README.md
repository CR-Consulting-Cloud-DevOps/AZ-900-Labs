# My AZ-900 Portfolio Project: IaaS Linux VM Deployment

## Project Overview & Objective

This repository contains the files for my first hands-on lab demonstrating the **Infrastructure-as-a-Service (IaaS)** model on Microsoft Azure, a core component of the AZ-900 certification.

My goal was not just to follow the steps, but to **automate the process** and clearly understand my responsibilities under the IaaS model.

### The Challenge: What I had to Do

The core task was to provision a complete, functional web server environment from scratch:

1. **Provision:** Use **Azure CLI** (Infrastructure as Code) to create a Resource Group and a Linux Virtual Machine (Ubuntu 2204).
2. **Configure:** Install the **Nginx** web server on the running VM.
3. **Validate:** Confirm that the web server is accessible via the Public IP address.

---

## My Technical Approach

I used a single, repeatable Bash script ('deploy.sh') that groups the Azure CLI commands, turning the manual exercise into an tomated deployment.

### How I Implemented It

| Step | AZ CLI Command Summary | Technical Rationale |
| :--- | :--- | :--- |
| **Resource Group** | 'az group create' | Created a logical container for billing and lyfecycle management. |
| **VM Creation** | 'az vm create' | Deployed the core compute resource, choosing the OS (Ubuntu) and size ('Standard_B1s'). **This defines the IaaS boundary.** |
| **Nginx Setup** | 'az vm extension set' | Used the **Custom Script Extension** to execute a remote configuration script. This step confirms that the web server installation is **my responsibility** in IaaS |

### Core Learning: Understanding Nginx

As part of this exercise, I realized the importance of Nginx:

* **In IaaS:** Nginx is essential. Since Azure provides only the bare metal (VM), **I must install it** to serve web traffic.
* **Primary Role:** Nginx receives user HTTP requests and processes them.
* **Advanced Role:** It is widely used in production environments as a **Reverse Proxy** or **Load Balancer** to manage and distribute traffic.

---

## Problem Solving: Dealing with Azure Capacity

During the execution of the 'az vm create' command, I encountered the **SkuNotAvailable error**.

| Problem Encountered | Solution Implemented |
| :-- | :-- |
| The command failed because the default requested VM size (SKU) was **temporarily out of capacity** in the chosen region ('westeurope'). | I **explicitly set the VM size to 'Standard_B1s'** in the 'deploy.sh' script, which is less in demand, resolving the resource constraint issue. |

**Takeaway:** This confirmed confirmed that even with IaC, the user must handle capacity constraints by selecting appropriate VM sizes and regions.

## Cost Management & Clean-Up

To ensure this VM does not incur ongoing costs, I use the Resource Group deletion command:

### Deletes IntroAzureRG, including the VM, disk, IP address, and all associated costs.
az group delete --name IntroAzureRG --no-wait -y