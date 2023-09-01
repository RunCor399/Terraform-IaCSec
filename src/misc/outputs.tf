
# output "id" {
#   description = "AKS Cluster ID"
#   value = azurerm_kubernetes_cluster.aks_cluster.id
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
#   description = "Kube Config RAW"
#   sensitive = true
# }

# output "client_key" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key
#   description = "Kube Config Client Key"
#   sensitive = true
# }

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
#   description = "Kube Config Client Certificate"
#   sensitive = true
# }

# output "cluster_ca_certificate" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate
#   description = "Kube Config Cluster CA Certificate"
#   sensitive = true
# }

# output "host" {
#   value = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
#   description = "Kube Config Host"
#   sensitive = true
# }