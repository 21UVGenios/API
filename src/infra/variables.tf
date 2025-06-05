variable "resource_group_name" {
  description = "Nombre del resource group"
  type        = string
}

variable "location" {
  description = "Región donde se desplegarán los recursos"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Prefijo base para los recursos"
  type        = string
}

variable "function_name" {
  description = "Nombre de la Azure Function"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID de Azure"
  type        = string
}

variable "db_connection_string" {
  description = "Cadena de conexión a la base de datos"
  type        = string
  sensitive   = true
}
