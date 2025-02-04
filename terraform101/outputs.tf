output "application_name" {
  value = var.application_name
}

output "environment_name" {
  value = var.environment_name
}

output "environment_suffix" {
  value = local.environment_suffix
}

output "api_key" {
  # This will fail because the variable api_key is marked as sensitive so it cannot be outputted directly
  value = var.api_key
  # By adding this now the api_key variable can be outputted but securely without showing the value
  sensitive = true
}

output "primary_region" {
  value = var.regions[0]
}

output "primary_region_count" {
  value = var.region_instance_count["westus"]
}