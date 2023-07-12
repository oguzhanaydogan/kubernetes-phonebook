resource "azapi_resource" "symbolicname" {
  type = var.type
  name = var.name
  parent_id = var.parent_id
  body = jsonencode({
    properties = {
      conflictLoggingRetentionInDays = int
      conflictResolutionPolicy = "string"
      enableConflictLogging = bool
      hubDatabasePassword = "string"
      hubDatabaseUserName = "string"
      interval = int
      schema = {
        masterSyncMemberName = "string"
        tables = [
          {
            columns = [
              {
                dataSize = "string"
                dataType = "string"
                quotedName = "string"
              }
            ]
            quotedName = "string"
          }
        ]
      }
      syncDatabaseId = "string"
      usePrivateLinkConnection = bool
    }
    sku = {
      capacity = int
      family = "string"
      name = "string"
      size = "string"
      tier = "string"
    }
  })
}