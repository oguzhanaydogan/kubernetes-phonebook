resource "azurerm_cdn_frontdoor_profile" "example" {
	name                = var.name
	resource_group_name = var.resource_group_name
	sku_name = var.sku_name
}

resource "azurerm_cdn_frontdoor_endpoint" "example" {
	for_each = toset(var.endpoints)

    name                     = each.key
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
}

resource "azurerm_cdn_frontdoor_origin_group" "example" {
	for_each = var.origin_groups

    name                     = each.value.name
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
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

resource "azurerm_cdn_frontdoor_origin" "example" {
	for_each = var.origins

	name                          = each.value.name
	cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example[each.value.cdn_frontdoor_origin_group].id
	enabled                       = each.value.enabled

	certificate_name_check_enabled = each.value.certificate_name_check_enabled

	host_name          = each.value.host_name
	http_port          = each.value.http_port
	https_port         = each.value.https_port
	priority           = each.value.priority
	weight             = each.value.weight

	dynamic "private_link" {
		for_each = each.value.private_link == null ? [] : ["xxx"]

		content {
			request_message        = each.value.private_link.request_message
			location               = each.value.private_link.location
			private_link_target_id = each.value.private_link.private_link_target_id
		}
	}
}

resource "azurerm_cdn_frontdoor_route" "example" {
	for_each = var.routes

	name                          = each.value.name
	cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.example[each.value.cdn_frontdoor_endpoint].id
	cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example[each.value.cdn_frontdoor_origin_group].id
	cdn_frontdoor_origin_ids      = [
		for origin in each.value.cdn_frontdoor_origins : azurerm_cdn_frontdoor_origin.example[origin].id
	]
	# cdn_frontdoor_rule_set_ids    = [
	# 	for rule_set in each.value.cdn_frontdoor_rule_sets : azurerm_cdn_frontdoor_rule_set.example[rule_set].id
	# ]
	enabled                       = each.value.enabled

	forwarding_protocol    = each.value.forwarding_protocol
	https_redirect_enabled = each.value.https_redirect_enabled
	patterns_to_match      = each.value.patterns_to_match
	supported_protocols    = each.value.supported_protocols
}

# resource "azurerm_cdn_frontdoor_rule_set" "example" {
# 	for_each = var.rule_sets

# 	name                     = each.value.name
# 	cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
# }

# resource "azurerm_cdn_frontdoor_rule" "example" {
# 	for_each = {
# 		for index, rule in var.rules : index => rule
# 	}

# 	depends_on = [azurerm_cdn_frontdoor_origin_group.example, azurerm_cdn_frontdoor_origin.example]

# 	name                      = each.value.name
# 	cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.example[each.value.rule_set].id
# 	order                     = (each.key + 1) * 10

# 	conditions {
# 		dynamic "request_scheme_condition" {
# 			for_each = each.value.conditions.request_scheme_conditions

# 			content {
# 			  operator = request_scheme_condition.value.operator
# 			  match_values = request_scheme_condition.value.match_values
# 			}
# 		}
#  	}

# 	actions {
# 		dynamic "url_redirect_action" {
# 			for_each = each.value.actions.url_redirect_actions

# 			content {
# 			  redirect_type = url_redirect_action.value.redirect_type
# 			  redirect_protocol = url_redirect_action.value.redirect_protocol
# 			  destination_hostname = url_redirect_action.value.destination_hostname
# 			}
# 		}
# 	}
#  }