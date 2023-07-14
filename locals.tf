locals {
  resources = {
    coyhub-db-us = module.mssql_servers["coyhub-db-us"]
    coyhub-db-eu = module.mssql_servers["coyhub-db-eu"]
    phonebook-lb-pls = module.private_link_services["phonebook-lb-pls"]
  }
}