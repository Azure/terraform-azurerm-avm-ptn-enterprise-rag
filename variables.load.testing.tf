variable "load_testing_create" {
  type        = bool
  default     = true
  description = "Flag to create Load Testing Services. If set to false, the resource will not be created."
  nullable    = false
}

variable "load_testing" {
  type = object({
    description = optional(string)
    tags        = optional(map(string))
  })
  default     = {}
  nullable    = false
  description = "Load Testing configuration"
}