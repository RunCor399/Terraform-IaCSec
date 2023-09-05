# IaC Security Assessment
Total (Checkov) = 341

## Components included:
- AWS infrastructure (Terraform)
- Azure Observability (Terraform)
- HCP Vault on VM (Terraform)
- Azure MySQL Database (Terraform)
- Keycloak (Terraform)
- Kubernetes (YAML)

## Main Vulnerabilities - Checkov
- Ensure Azure Kubernetes Cluster (AKS) nodes should use a minimum number of 50 pods.  CKV_AZURE_168 (max_pods parameter in aks node_pool)
- Ensure AKS local admin account is disabled. CKV_AZURE_141 (local_account_disabled = true in aks)
- Ensure AKS API server defines authorized IP ranges. CKV_AZURE_6 (api_server_authorized_ip_ranges = "0.0.0.0/0")
- Ensure AKS enables private clusters. CKV_AZURE_115 (private_cluster_enabled = true)
- Ensure that Azure Key Vault disables public network access. CKV_AZURE_189 (network_acls in Vault-On-VM Azure Key Vault, public_network_access_enabled = false)
- Ensure that key vault enables purge protection. CKV_AZURE_110 (purge_protection_enabled = true)
- Ensure the key vault is recoverable CKV_AZURE_42 (soft_delete_retention_days  = 7)
- Ensure that key vault key is backed by HSM CKV_AZURE_112 (key_type = "RSA-HSM")
- Ensure all keys have an expiration date. CKV_AZURE_40  (expiration_date = "2020-12-30T20:00:00Z")
- Ensure that SSH access is restricted from the internet CKV_AZURE_10 (commented Inbound SSH rule in Netwok Security Group (main.tf of Vault))
- Ensure that Storage blobs restrict public access CKV_AZURE_190 (public_network_access_enabled = false)
- Ensure that AWS database instances have deletion protection enabled CKV_AWS_293 (deletion_protection = true)
- Minimize the admission of pods which lack an associated NetworkPolicy CKV_K8S_6 
- Minimize the admission of containers with capabilities assigned CKV_K8S_37 (security context capabilities)
- Containers should run as a high UID to avoid host conflict CKV_K8S_40 (security context runAsUser)
- Containers should not run with allowPrivilegeEscalation CKV_K8S_20 (allowPrivilegeEscalation=false)



Search filter: pr:38 tool:checkov is:open sort:created-desc path:/src/final-assessment 



## Main Vulnerabilities - Sysdig App
- 5 High
- 37 Medium
- 37 Low

## Run time of pipelines