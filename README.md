# Assessment Documentation

## 1. Summary

**Project Name:** Quotes App – Secure, Highly Available Public Web Application on Azure  

**Objective:**  
Build and deploy a public web app that displays random quotes from a database, designed to handle critical PII securely.  

**Scope:**  
End-to-end infrastructure provisioning with Terraform, automation, CI/CD, application delivery, and Azure networking.  

---

## 2. Introduction

**Problem Statement:**  
Need for a highly available, secure cloud solution for a public-facing web app with secure PII data in the database.  

**Business Value:**  
Demonstrates cloud automation, scalability, and compliance.  

**Stakeholders:**  
Cloud engineering team.  

---

## 3. Requirements

### 3.1 Functional Requirements
- Web app fetches and displays a random quote.  
- Quotes database seeded automatically.  
- Custom domain + HTTPS enabled.  
- App Service runs Node.js application.  

### 3.2 Non-Functional Requirements
- **Availability:** 99.9% SLA with redundancy.  
- **Security:** PII protection, private networking, TLS 1.2+.  
- **Performance:** Fast query response from SQL.  
- **Scalability:** App Service scaling enabled.  
- **Compliance:** Follows HIPAA/GDPR-like controls.  

---

## 4. Architecture

### 4.1 High-Level Architecture Diagram

### 4.2 Components
- **Azure App Service:** Hosts Node.js app (Linux).  
- **Azure SQL Database:** Stores quotes (critical PII).  
- **Azure Application Gateway:** Provides WAF, TLS termination, routing.  
- **Azure Key Vault:** Stores secrets & certificates.  
- **Private Endpoints + DNS Zones:** Secure app service and database connectivity.  
- **Terraform:** Infrastructure as Code (IaC).  
- **GitHub Actions:** CI/CD pipeline for automation.  

---

## 5. Infrastructure Design

### 5.1 Networking
Virtual Network with 4 subnets:  
- Web Subnet (App Gateway)  
- App Subnet (App Service)  
- DB Subnet (Private Endpoint)  
- Management Subnet (Management VMs)  

### 5.2 Security
- No public SQL access (private endpoint only).  
- Web App public access disabled → only App Gateway entry point.  
- Managed Identity for App Service to access SQL DB.  
- TLS 1.2 enforced end-to-end.  

### 5.3 Terraform Project Structure

---

## 6. CI/CD & Automation

### 6.1 GitHub Actions Workflow
- **Deploy Infra:** Terraform apply.  
- **Build:** Node.js app containerized and pushed to ACR.  
- **App Server:** Pulls uploaded container from ACR via Identity.  
- **Database Seed:** SQL script run via pipeline.  

### 6.2 Secrets Management
- GitHub secrets → Azure Key Vault → Terraform.  

---

## 7. Testing & Validation
- **Connectivity Tests:** `curl` via App Gateway → returns quote.  
- **Database Tests:** Seeded quotes query returns data.  
- **Security Tests:** App Service not directly accessible, only via Gateway.  
- **TLS Tests:** HTTPS enforced with valid certificate.  

---

## 8. Best Practices & Standards Applied
- Infrastructure as Code with Terraform.  
- Network isolation with private endpoints.  
- Zero hardcoded credentials (Managed Identity + Key Vault).  
- High availability with App Gateway & App Service scaling.  
- PII data secured with encryption in transit and at rest.  

---

## 9. Risks & Mitigations
- **Misconfigured Networking:** Private DNS zone linking tested.  
- **Secret Leakage:** All secrets stored in Key Vault.  
- **Scaling Costs:** Auto-scaling thresholds defined.  

---

## 10. Conclusion & Next Steps
- Successfully deployed a production-ready architecture.  
- **Future Improvements:**  
  - Add monitoring (App Insights, Log Analytics).  
  - Enable autoscaling.  
  - Implement disaster recovery (Geo-replication).  
  - Add WAF and Azure Front Door for global resiliency.  
  - Replace password authentication with Managed Identity via Azure AD.  
  - For microservice-based services, consider AKS (Azure Kubernetes Service).  
  - Integrate Azure DevOps for streamlined identity & access management.  

---

## 11. Appendix
- Terraform Code – GitHub repo  
- GitHub Actions Pipeline YAML  
- SQL Seed Script  
- Screenshots of working web app  



