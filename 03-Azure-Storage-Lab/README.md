# 🗄️ My AZ-900 Portfolio Project: Azure Storage Account & Redundancy

## Project Overview & Objective

This document details my third hands-on lab, focusing on **Azure Storage**, a core Platform as a Service (PaaS) offering. The lab demonstrates the fundamental process of deploying and configuring a **Storage Account** for unstructured data.

My primary goal was to use **Infrastructure as Code (IaC)** to deploy the service and highlight key AZ-900 concepts like redundancy and access tiers.

### The Challenge: What I had to Do

The core task was to deploy and configure a globally accessible storage solution:

1. **Deployment:** Create a new Storage Account using the recommended **StorageV2** kind.
2. **Redundancy Choice:** Select a specific redundancy option (**Standard_LRS**) and understand its implications.
3. **Container Management:** Create a Blob Container and configure its public access level, demonstrating control over security boundaries.
4. **Documentation:** Detail the differences between the four primary Azure Storage types.

---

## My Technical Approach

I used a single, repeatable Bash script (`deploy.azcli`) to sequence the Azure CLI commands required for provisioning the entire storage infrastructure.

### How I Implemented It

| Step | AZ CLI Command Summary | Technical Rationale |
| :--- | :--- | :--- |
| **Storage Account Creation** | 'az storage account create' with `--sku Standard_LRS` | This command deploys the central resource. `Standard_LRS` (Local-Redundant Storage) guarantees three copies of data within a single datacenter, providing durability at the lowest cost. |
| **Container Creation (Initial)** | 'az storage container create' with `--public-access off` | Created the initial logical grouping for blobs with the **most secure** setting (Private/Off), requiring authentication for all access. |
| **Permission Modification** | 'az storage container set-permission' with `--public-access blob` | Explicitly changed the access level to **Blob Public Access**, allowing anonymous read access to the blobs (files) themselves, but not to the container list. |

### Core Learning: Understanding Redundancy 

This exercise reinforced the critical AZ-900 concepts related to Storage Redundancy:

| Option | Copies | Datacenters | Primary Use Case |
| :--- | :--- | :--- | :--- |
| **LRS** (Local) | 3 | 1 | Lowest cost, non-critical data. |
| **ZRS** (Zone) | 3 | 2-3 Zones | Data resiliency against datacenter failure within a region. |
| **GRS** (Geo) | 6 (3 Primary + 3 Secondary) | 2 Regions | Highest durability; protection against regional outages. |

## Problem Solving: Uniqueness

The primary technical constraint in this lab is the **global uniqueness** of the Storage Account name.

| Constraint | Solution Implemented | Proof of Competency |
| :-- | :-- | :-- |
| **Storage Name Uniqueness** | `STORAGE_NAME="mystoragecrema$(openssl rand -hex 4)"` | Implemented a dynamic name generation using Bash (`openssl rand -hex 4`) to ensure the account name is unique every time the script is run, preventing deployment failure. |

**Takeaway:** This confirmed my ability to manage fundamental Azure PaaS services, control critical security features (Public Access), and understand the trade-offs involved in selecting a redundancy option.

## Cost Management & Clean-Up

To ensure no residual costs remain, the separate `destroy.azcli` script is used:

### Deletes the StorageLabRG, including the Storage Account, its containers, all stored data, and associated costs.
```bash
az group delete --name StorageLabRG --yes --no-wait