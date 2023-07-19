resource "azapi_resource" "azapi_resource" {
  name      = var.name
  type      = var.type
  parent_id = var.parent_id
  body      = jsonencode(var.body)
}