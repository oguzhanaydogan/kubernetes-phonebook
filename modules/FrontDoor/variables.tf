variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "endpoints" {
  type = map(object({
    name = string
  }))
}

variable "origin_groups" {
  type = map(object({
    name                                                      = string
    session_affinity_enabled                                  = bool
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = number
    health_probes = map(object({
      interval_in_seconds = number
      path                = string
      protocol            = string
      request_type        = string
    }))
    load_balancing = object({
      additional_latency_in_milliseconds = number
      sample_size                        = number
      successful_samples_required        = number
    })
  }))
}

variable "origins" {
  type = map(object({
    name                           = string
    cdn_frontdoor_origin_group     = string
    enabled                        = bool
    certificate_name_check_enabled = bool
    host = object({
      resource_group_name = string
      name                = string
      type                = string
      pls_enabled         = bool
    })
    http_port  = number
    https_port = number
    priority   = number
    weight     = number
    private_link = object({
      request_message = string
      location        = string
      target = object({
        name                = string
        resource_group_name = string
      })
    })
  }))
}

variable "routes" {
  type = map(object({
    name                       = string
    cdn_frontdoor_endpoint     = string
    cdn_frontdoor_origin_group = string
    cdn_frontdoor_origins      = list(string)
    cdn_frontdoor_rule_sets    = list(string)
    enabled                    = bool
    forwarding_protocol        = string
    https_redirect_enabled     = bool
    patterns_to_match          = list(string)
    supported_protocols        = list(string)
  }))
}

variable "rule_sets" {
  default = {}
  type = map(object({
    name = string
  }))
}

variable "rules" {
  default = {}
  type = map(object({
    name     = string
    rule_set = string
    conditions = object({
      request_scheme_conditions = map(object({
        operator     = string
        match_values = list(string)
      }))
    })
    actions = object({
      url_redirect_actions = map(object({
        redirect_type        = string
        redirect_protocol    = string
        destination_hostname = string
      }))
    })
  }))
}