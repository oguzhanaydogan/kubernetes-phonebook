locals {
  resources = {
    coyhub-db-us = module.mssql_servers["coyhub-db-us"]
    coyhub-db-eu = module.mssql_servers["coyhub-db-eu"]
  }
}