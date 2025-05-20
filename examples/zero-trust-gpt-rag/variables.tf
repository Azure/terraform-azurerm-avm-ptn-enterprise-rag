variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "virtual_network_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/23"]
  description = "The address space for the virtual network."
}

variable "virtual_network_subnets" {
  type = map(object({
    name        = string
    prefix_size = number
  }))
  default = {
    "01_ai" = {
      name        = "ai-subnet"
      prefix_size = 26
    }
    "02_app_integration" = {
      name        = "app-integration-subnet"
      prefix_size = 26
    }
    "03_app_service" = {
      name        = "app-services-subnet"
      prefix_size = 26
    }
    "04_database" = {
      name        = "database-subnet"
      prefix_size = 26
    }
  }
}
