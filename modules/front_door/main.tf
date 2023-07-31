locals {
  # Gather all 'lb's from all origins
  lbs = {
    for key, origin in var.origins : key => {
      name                = origin.host.name
      resource_group_name = origin.host.resource_group_name
    }
    if origin.host.pls_enabled && origin.host.type == "Microsoft.Network/loadBalancers"
  }

  # Gather all 'private_link_service' from all origins
  private_link_services = {
    for key, origin in var.origins : key => {
      name                = origin.private_link.target.name
      resource_group_name = origin.private_link.target.resource_group_name
    }
    if origin.host.pls_enabled && origin.host.type == "Microsoft.Network/loadBalancers"
  }

  # Gather all 'storage_blob's from all origins
  storage_blobs = {
    for key, origin in var.origins : key => {
      name                   = origin.host.name
      storage_account_name   = origin.host.storage_account_name
      storage_container_name = origin.host.storage_container_name
    }
    if origin.host.type == "Microsoft.Storage/blobs"
  }

  # Gather all 'app_service's from all origins
  app_services = {
    for key, origin in var.origins : key => {
      name                = origin.host.name
      resource_group_name = origin.host.resource_group_name
    }
    if origin.host.type == "Microsoft.Web/sites"
  }
}

resource "azurerm_cdn_frontdoor_profile" "cdn_frontdoor_profile" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
}

resource "azurerm_cdn_frontdoor_endpoint" "cdn_frontdoor_endpoints" {
  for_each = var.endpoints

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "cdn_frontdoor_origin_groups" {
  for_each = var.origin_groups

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id
  session_affinity_enabled = each.value.session_affinity_enabled

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  dynamic "health_probe" {
    for_each = each.value.health_probes

    content {
      interval_in_seconds = health_probe.value.interval_in_seconds
      path                = health_probe.value.path
      protocol            = health_probe.value.protocol
      request_type        = health_probe.value.request_type
    }
  }

  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }
}

data "azurerm_lb" "lbs" {
  for_each = local.lbs

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_private_link_service" "private_link_services" {
  for_each = local.private_link_services

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_storage_blob" "storage_blobs" {
  for_each = local.storage_blobs

  name                   = each.value.name
  storage_account_name   = each.value.storage_account_name
  storage_container_name = each.value.storage_container_name
}

data "azurerm_linux_web_app" "app_services" {
  for_each = local.app_services

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_cdn_frontdoor_origin" "cdn_frontdoor_origins" {
  for_each = var.origins

  name                          = each.value.name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.cdn_frontdoor_origin_groups[each.value.cdn_frontdoor_origin_group].id
  enabled                       = each.value.enabled
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  host_name = coalesce(
    try(
      data.azurerm_lb.lbs[each.key].private_ip_address,
      data.azurerm_storage_blob.storage_blobs[each.key].url,
      data.azurerm_linux_web_app.app_services[each.key].default_hostname,
      ""
    ),
    "Coalesce could not find any non empty result!"
  )
  http_port  = each.value.http_port
  https_port = each.value.https_port
  priority   = each.value.priority
  weight     = each.value.weight

  dynamic "private_link" {
    for_each = each.value.private_link != null ? [1] : []
    
    content {
      request_message = each.value.private_link.request_message
      location        = each.value.private_link.location
      private_link_target_id = coalesce(
        try(
          data.azurerm_private_link_service.private_link_services[each.value.key].id,
          data.azurerm_lb.lbs[each.key].id,
          data.azurerm_storage_blob.storage_blobs[each.key].id,
          data.azurerm_linux_web_app.app_services[each.key].id,
          ""
        ),
        "Coalesce could not find any non empty result!"
      )
    }
  }
}

resource "azurerm_cdn_frontdoor_route" "cdn_frontdoor_routes" {
  for_each = var.routes

  name                          = each.value.name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.cdn_frontdoor_endpoints[each.value.cdn_frontdoor_endpoint].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.cdn_frontdoor_origin_groups[each.value.cdn_frontdoor_origin_group].id
  cdn_frontdoor_origin_ids = [
    for origin in each.value.cdn_frontdoor_origins :
    azurerm_cdn_frontdoor_origin.cdn_frontdoor_origins[origin].id
  ]
  cdn_frontdoor_rule_set_ids = [
    for rule_set in each.value.cdn_frontdoor_rule_sets :
    azurerm_cdn_frontdoor_rule_set.cdn_frontdoor_rule_sets[rule_set].id
  ]
  enabled = each.value.enabled
  forwarding_protocol    = each.value.forwarding_protocol
  https_redirect_enabled = each.value.https_redirect_enabled
  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = each.value.supported_protocols
}

resource "azurerm_cdn_frontdoor_rule_set" "cdn_frontdoor_rule_sets" {
  for_each = var.rule_sets

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.id
}

resource "azurerm_cdn_frontdoor_rule" "cdn_frontdoor_rules" {
  for_each = var.rules

  name                      = each.value.name
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.cdn_frontdoor_rule_sets[each.value.rule_set].id
  order                     = index(keys(var.rules), each.key) + 1

  dynamic "conditions" {
    for_each = each.value.conditions != null ? [1] : []

    dynamic "request_scheme_condition" {
      for_each = conditions.request_scheme_condition != null ? [1] : []

      content {
        operator     = request_scheme_condition.value.operator
        match_values = request_scheme_condition.value.match_values
      }
    }
  }

  actions {
    dynamic "url_redirect_action" {
      for_each = each.value.actions.url_redirect_action != null ? [1] : []

      content {
        redirect_type        = url_redirect_action.value.redirect_type
        redirect_protocol    = url_redirect_action.value.redirect_protocol
        destination_hostname = url_redirect_action.value.destination_hostname
      }
    }
  }

  depends_on = [
    azurerm_cdn_frontdoor_origin_group.cdn_frontdoor_origin_groups,
    azurerm_cdn_frontdoor_origin.cdn_frontdoor_origins
  ]
}