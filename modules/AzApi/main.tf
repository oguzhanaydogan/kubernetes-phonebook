resource "azapi_resource" "symbolicname" {
  type = var.type
  name = var.name
  parent_id = var.parent_id
  body = jsonencode(var.body)
}