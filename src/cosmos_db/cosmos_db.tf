

# resource "azurerm_cosmosdb_account" "cosmos_db_account" {
#     name = "cosmosdb-mec-reply-thesis"
#     location = var.cosmos_db_resource_group.location
#     resource_group_name = var.cosmos_db_resource_group.name
#     offer_type = "Standard"
#     enable_free_tier = true
#     kind = "MongoDB"

#     capabilities {
#         name = "MongoDBv3.4"
#     }

#     capabilities {
#         name = "EnableMongo"
#     }

#     geo_location {
#       location = var.cosmos_db_resource_group.location
#       failover_priority = 0
#     }

#     consistency_policy {
#       consistency_level = "BoundedStaleness"
#       max_interval_in_seconds = 300
#       max_staleness_prefix    = 100000
#     }

# }


# resource "azurerm_cosmosdb_mongo_database" "mongodb_database" {
#   name                = "mongodb-database"
#   resource_group_name = azurerm_cosmosdb_account.cosmos_db_account.resource_group_name
#   account_name        = azurerm_cosmosdb_account.cosmos_db_account.name
#   throughput          = 400
#   depends_on = [
#     azurerm_cosmosdb_account.cosmos_db_account
#   ]
# }