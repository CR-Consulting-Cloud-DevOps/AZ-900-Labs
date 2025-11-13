# 🚀 AZ-900 IaC Portfolio / Azure Cloud Fundamentals

This repository contains a series of Infrastructure as Code (IaC) Labs using the **Azure CLI** to demonstrate the fundamental concepts of Microsoft Azure and validate understanding of key services (VM, Network, Storage).

Each lab is structured using a consistent pattern: a deployment script, a destruction script, and a detailed analytical document (`README.md`).

## 🛠️ Global Lab Table of Contents

| Folder | Azure Service | Key AZ-900 Competencies Demonstrated |
| :--- | :--- | :--- |
| **01-Azure-VM-Nginx-Lab** | **Compute (IaaS) & Nginx** | Linux VM deployment, IP management, Custom Script Extension usage, handling capacity constraints (SKU errors). |
| **02-Azure-Network-NSG-Lab** | **Networking (NSG) & Security** | Diagnosis and correction of an existing security issue (NSG), understanding implicit rules and priority precedence. |
| **03-Azure-Storage-Lab** | **Azure Storage (PaaS)** | Storage Account (StorageV2) deployment, understanding redundancy (LRS), and managing public access (Blob). |

---

## 🏃 How to Execute the Labs

1.  **Prerequisite:** Ensure the Azure CLI is installed and you are logged in (`az login`).
2.  **Execution:** Navigate into the desired lab folder (e.g., `cd 01-Azure-VM-Nginx-Lab`).
3.  **Deployment:** `bash deploy.azcli` (or specific deploy script name)
4.  **Cleanup:** `bash destroy.azcli` (or specific destroy script name)