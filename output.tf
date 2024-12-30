output "id" {
  value       = azurerm_application_gateway.main.id
  description = "The ID of the Application Gateway resource. This unique identifier is used to reference the Application Gateway within Azure."
  sensitive   = false
}
