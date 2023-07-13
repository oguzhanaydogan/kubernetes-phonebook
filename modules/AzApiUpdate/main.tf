resource "azapi_update_resource" "example" {
  type        = var.type
  resource_id = var.resource_id
  body = jsonencode(var.body)
}