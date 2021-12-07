// Tykota Hawkins

terraform {
  required_providers {
    mycloud = {
      source  = "hashicorp/azurerm"
      version = "~> 2.88.1"
    }
  }
}

resource "rg-scoring_resource_group" "scoring" {
  name     = "scoring_resource_group"
  location = "us-west-2"
}

resource "plan-scoring_service_plan" "scoring" {
  name                = "plan-scoring-service-plan"
  location            = rg-scoring_resource_group.scoring.location
  resource_group_name = rg-scoring_resource_group.scoring.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "rg_scoring_app_service" "scoring" {
  name                = random_id.server.hex
  app_service_name    = ase-scoring_app_service.scoring.name
  location            = rg-scoring_resource_group.scoring.location
  resource_group_name = rg-scoring_resource_group.scoring.name
  app_service_plan_id = plan-scoring_service_plan.scoring.id

  site_config {
    dotnet_framework_version = "v4.0"
  }

  app_settings = {
    "ENV" = "production"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server= AppDbServer.appDb.com;Integrated Security=SSPI"
  }
}

