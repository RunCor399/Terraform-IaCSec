

resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name = "aks-cluster"
    location = var.observability_rg.location
    resource_group_name = var.observability_rg.name
    sku_tier = "Free"

    default_node_pool {
        name           = "default"
        node_count     = 1
        vm_size        = "standard_d2_v2"
    }

// Add role assignment for azure user
    identity {
        type = "SystemAssigned"
    }

    # Uses Azure AD to authenticate users to K8s, refer to: https://learn.microsoft.com/en-us/azure/aks/azure-ad-rbac?tabs=portal
    # azure_active_directory_role_based_access_control {
    #   managed = true
    #   // it should be a group id, i've used my own object id
    #   admin_group_object_ids = ["9bd70693-8b50-432a-8876-a8096e9fb4b6"]
    #   azure_rbac_enabled = true
    # }

    network_profile {
      network_plugin = "azure"
    }

    http_application_routing_enabled = true

    oms_agent {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
    }

    linux_profile {
      admin_username = "adminuser"
      ssh_key {
        key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuE9WgQR2C4zPDRLDoMiSgqbsdXjgPFT5YkJFAmnyBO9oIoosAe/s2MBZkasz3IcW3/yrH8r8y4c7UTkAu1dzv+CJNS7Axcg2PNXUdTdZCZp0WHgeLMtlzLHWZRFltVP9wHuM3n206IyJ2iSm3sY8ZfViHWoo6bjHb0cOYL/+vEk7Chvces0gUwHTSTKFuX68x1iWRKTgxqQRSS7yz3wZqB+OxAVLvt7fHGV6nWDGVHsErXXFU7QKUvZQ//cKu1U/dMED3JWKWJEthHqCFOgPQ4PWc0kRe5l6CF+NrzfPKJT8cN9XcNj6kOUu2dMMQx3px6Mr5VjV/0xNQmmoZm0M2YCaq3mbpQEM7fO4xCKJRAlKai/q12N0/DCC4t1CxUhqhyvwiL/O1drOqhFEmsB7Yg+/FiynFjZqvt78RE3gP7t7xmBVRckDSRWTbTQqaLMNryuu6+gEXamOF0pPNCpmSPizCRd1t3D/x13IFHjVqzF9QbGRg0dYcV55izrHvatxRcggfEdBH1DTtuwWV3LftueNeXplRRUcq2MTF1SJQkHhnPzezLwQr9pGVKSFT2QjS5q67MAfK7gC7tSqoT6SVhRd4LFtH2spubLqZnLAN/OBK/atbJn3LVTxKFDd23eDTrwH7R20FUkyNmDYvDvRudlZDGQFs76msZtvcKZgb2Q== runcor3@LAPTOP-36GVQ98F"
      }
    }

    dns_prefix = "observability-aks"

    depends_on = [azurerm_log_analytics_workspace.log_analytics_workspace,
                  azurerm_resource_group.observability_rg]
}