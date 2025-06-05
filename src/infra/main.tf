terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "local" {}

  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.project_name}-ai"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.project_name}-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Windows"
  sku_name            = "Y1" # Consumption plan
}

resource "azurerm_storage_account" "function_storage" {
  name                     = "${var.project_name}storage01"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "functionapp" {
  name                       = var.function_name
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  service_plan_id            = azurerm_service_plan.appserviceplan.id
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  os_type                    = "windows"
  version                    = "~4" # Para .NET 6
  functions_extension_version = "~4"

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "AzureWebJobsStorage"        = azurerm_storage_account.function_storage.primary_connection_string
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
    "FUNCTIONS_WORKER_RUNTIME"    = "dotnet-isolated"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appinsights.connection_string
    "KeyVaultConnection"         = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db_connection.secret_uri})"
  }
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.project_name}-kv"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = azurerm_function_app.functionapp.identity.principal_id

    secret_permissions = ["get", "list"]
  }
}

resource "azurerm_key_vault_secret" "db_connection" {
  name         = "DbConnection"
  value        = var.db_connection_string
  key_vault_id = azurerm_key_vault.keyvault.id
}
