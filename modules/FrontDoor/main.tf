resource "azurerm_cdn_frontdoor_profile" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_cdn_frontdoor_endpoint" "example" {
	count = length(var.endpoints)

    name                     = element(var.endpoints, count.index)
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
}

resource "azurerm_cdn_frontdoor_origin_group" "example" {
	count = length(var.origin_groups)

    name                     = element(var.origin_groups, count.index).name
    cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
    session_affinity_enabled = element(var.origin_groups, count.index).session_affinity_enabled

	restore_traffic_time_to_healed_or_new_endpoint_in_minutes = element(var.origin_groups, count.index).restore_traffic_time_to_healed_or_new_endpoint_in_minutes

	dynamic "health_probe" {
		for_each = element(var.origin_groups, count.index).health_probes

		content {
			interval_in_seconds = health_probe.value.interval_in_seconds
			path                = health_probe.value.path
			protocol            = health_probe.value.protocol
			request_type        = health_probe.value.request_type
		}
	}

	load_balancing {
		additional_latency_in_milliseconds = element(var.origin_groups, count.index).load_balancing.additional_latency_in_milliseconds
		sample_size                        = element(var.origin_groups, count.index).load_balancing.sample_size
		successful_samples_required        = element(var.origin_groups, count.index).load_balancing.successful_samples_required
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
	# cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.example.id]
	enabled                       = each.value.enabled

	forwarding_protocol    = each.value.forwarding_protocol
	https_redirect_enabled = each.value.https_redirect_enabled
	patterns_to_match      = each.value.patterns_to_match
	supported_protocols    = each.value.supported_protocols

}

# resource "azurerm_cdn_frontdoor_rule_set" "example" {
# 	name                     = "exampleruleset"
# 	cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
# }

# resource "azurerm_cdn_frontdoor_rule" "example" {
# 	depends_on = [azurerm_cdn_frontdoor_origin_group.example, azurerm_cdn_frontdoor_origin.example]

# 	name                      = "examplerule"
# 	cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.example.id
# 	order                     = 1
# 	behavior_on_match         = "Continue"

# 	actions {
# 	route_configuration_override_action {
# 		cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id
# 		forwarding_protocol           = "HttpsOnly"
# 		query_string_caching_behavior = "IncludeSpecifiedQueryStrings"
# 		query_string_parameters       = ["foo", "clientIp={client_ip}"]
# 		compression_enabled           = true
# 		cache_behavior                = "OverrideIfOriginMissing"
# 		cache_duration                = "365.23:59:59"
# 	}

# 	url_redirect_action {
# 		redirect_type        = "PermanentRedirect"
# 		redirect_protocol    = "MatchRequest"
# 		query_string         = "clientIp={client_ip}"
# 		destination_path     = "/exampleredirection"
# 		destination_hostname = "contoso.com"
# 		destination_fragment = "UrlRedirect"
# 	}
# 	}

# 	conditions {
# 	host_name_condition {
# 		operator         = "Equal"
# 		negate_condition = false
# 		match_values     = ["www.contoso.com", "images.contoso.com", "video.contoso.com"]
# 		transforms       = ["Lowercase", "Trim"]
# 	}

# 	is_device_condition {
# 		operator         = "Equal"
# 		negate_condition = false
# 		match_values     = ["Mobile"]
# 	}

# 	post_args_condition {
# 		post_args_name = "customerName"
# 		operator       = "BeginsWith"
# 		match_values   = ["J", "K"]
# 		transforms     = ["Uppercase"]
# 	}

# 	request_method_condition {
# 		operator         = "Equal"
# 		negate_condition = false
# 		match_values     = ["DELETE"]
# 	}

# 	url_filename_condition {
# 		operator         = "Equal"
# 		negate_condition = false
# 		match_values     = ["media.mp4"]
# 		transforms       = ["Lowercase", "RemoveNulls", "Trim"]
#  	}
#  	}
#  }