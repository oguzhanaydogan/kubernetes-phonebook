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
  type      = string
}

variable "administrator_login_password" {
  sensitive = true
  type      = string
}

variable "tags" {
  type = map(string)
}

variable "mssql_databases" {
  default = {}
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
  }))
}