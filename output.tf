output "id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.main.id
  sensitive   = false
}

output "name" {
  description = "The name of the Application Gateway."
  value       = azurerm_application_gateway.main.name
  sensitive   = false
}

output "public_ip_address" {
  description = "The public IP address of the Application Gateway."
  value       = length(azurerm_public_ip.main) > 0 ? azurerm_public_ip.main[0].ip_address : null
  sensitive   = false
}

output "backend_address_pool_ids" {
  description = "Map of backend address pool names to their IDs."
  value       = { for pool in azurerm_application_gateway.main.backend_address_pool : pool.name => pool.id }
  sensitive   = false
}
