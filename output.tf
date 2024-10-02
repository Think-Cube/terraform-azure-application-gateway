output "id" {
  value       = azurerm_application_gateway.main.id
  description = "The ID of the Application Gateway."
  sensitive   = false
}
