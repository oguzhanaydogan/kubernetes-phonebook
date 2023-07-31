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
  default = {}
  type = map(object({
    name = string
  }))
}

variable "origin_groups" {
  default = {}
  type = map(object({
    name                                                      = string
    session_affinity_enabled                                  = optional(bool)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number)
    health_probes = optional(map(object({
      interval_in_seconds = number
      path                = optional(string)
      protocol            = string
      request_type        = optional(string)
    })), {})
    load_balancing = object({
      additional_latency_in_milliseconds = optional(number)
      sample_size                        = optional(number)
      successful_samples_required        = optional(number)
    })
  }))
}

variable "origins" {
  default = {}
  type = map(object({
    name                           = string
    cdn_frontdoor_origin_group     = string
    enabled                        = optional(bool)
    certificate_name_check_enabled = bool
    host = object({
      name                = string
      resource_group_name = optional(string)
      storage_account_name = optional(string)
      storage_container_name = optional(string)
      type                = string
      pls_enabled         = optional(bool, false)
    })
    http_port  = optional(number)
    https_port = optional(number)
    priority   = optional(number)
    weight     = optional(number)
    private_link = optional(object({
      request_message = optional(string)
      location        = string
      target = object({
        name                = string
        resource_group_name = string
      })
    }), null)
  }))
}

variable "routes" {
  default = {}
  type = map(object({
    name                       = string
    cdn_frontdoor_endpoint     = string
    cdn_frontdoor_origin_group = string
    cdn_frontdoor_origins      = list(string)
    cdn_frontdoor_rule_sets    = optional(list(string))
    enabled                    = optional(bool)
    forwarding_protocol        = optional(string)
    https_redirect_enabled     = optional(bool)
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
    conditions = optional(object({
      request_scheme_condition = optional(object({
        operator     = optional(string)
        match_values = optional(list(string))
      }), null)
    }), null)
    actions = object({
      url_redirect_action = optional(object({
        redirect_type        = string
        redirect_protocol    = optional(string)
        destination_hostname = string
      }), null)
    })
  }))
}