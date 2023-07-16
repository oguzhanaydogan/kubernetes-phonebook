resource "azurerm_mssql_database" "test" {
  name                        = var.name
  server_id                   = var.server_id
  collation                   = var.collation
  max_size_gb                 = var.max_size_gb
  sku_name                    = var.sku_name
  min_capacity                = var.min_capacity
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  read_replica_count          = var.read_replica_count
  read_scale                  = var.read_scale
  zone_redundant              = var.zone_redundant
}