output "front_door_endpoint_urls" {
  value = [for front_door in values(module.front_doors) : "${front_door.name}: ${front_door.endpoint_urls}"]
}