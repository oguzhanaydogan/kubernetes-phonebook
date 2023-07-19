resource "azapi_update_resource" "azapi_update_resource" {
  type        = var.type
  resource_id = var.resource_id
  body        = jsonencode(var.body)
}