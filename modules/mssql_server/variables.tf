variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "msqql_version" {
  type = string
}

variable "administrator_login" {
  sensitive = true
  type = object({
    username = object({
      source  = string
      literal = optional(string, "")
      key_vault = optional(object({
        name                = string
        resource_group_name = string
        secret_name         = string
      }), null)
    })
    password = object({
      source  = string
      literal = optional(string, "")
      key_vault = optional(object({
        name                = string
        resource_group_name = string
        secret_name         = string
      }), null)
    })
  })
}

variable "tags" {
  type = map(string)
}

variable "mssql_databases" {
  default = null
  type = map(object({
    name                        = string
    collation                   = string
    max_size_gb                 = number
    sku_name                    = string
    min_capacity                = number
    auto_pause_delay_in_minutes = number
    read_replica_count          = number
    read_scale                  = bool
    zone_redundant              = bool
    sync_groups = optional(map(object({
      name                     = string
      conflictResolutionPolicy = string
      interval                 = number
      usePrivateLinkConnection = bool
    })), {})
    sync_group_memberships = optional(map(object({
      name = string
      sync_group = object({
        name = string
        server = object({
          name                = string
          resource_group_name = string
        })
        database = object({
          name                = string
          resource_group_name = string
        })
      })
      own_database_type        = string
      usePrivateLinkConnection = bool
    })), {})
  }))
}