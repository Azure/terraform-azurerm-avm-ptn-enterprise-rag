variable "load_testing_create" {
  type        = bool
  default     = false
  description = "Indicates whether to create the load testing resource."
}

variable "load_testing_description" {
  type        = string
  default     = "Load testing resource to testing RAG Application."
  description = "Description of the load testing resource."
}