resource "azapi_resource" "symbolicname" {
  type = var.type
  name = var.name
  parent_id = var.parent_id
  schema_validation_enabled = var.schema_validation_enabled
  body = jsonencode(var.body)
}