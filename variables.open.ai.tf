variable "azure_open_ai_create" {
  type        = bool
  default     = true
  description = "Indicates whether to create an Azure OpenAI resource."
}

variable "azure_open_ai_id" {
  type        = string
  default     = null
  description = "The ID of the existing Azure OpenAI resource."
}

variable "chat_gpt_model_name" {
  description = "GPT model used to answer user questions. Don't forget to check region availability."
  type        = string
  default     = "gpt-4o"
}

variable "chat_gpt_model_deployment_type" {
  description = "GPT model deployment type."
  type        = string
  default     = "GlobalStandard"
}

variable "chat_gpt_model_version" {
  description = "GPT model version."
  type        = string
  default     = "2024-11-20"
}

variable "chat_gpt_deployment_name" {
  description = "GPT model deployment name."
  type        = string
  default     = "chat"
}

variable "chat_gpt_deployment_capacity" {
  description = "GPT model tokens per Minute Rate Limit (thousands)."
  type        = number
  default     = 40
}

variable "embeddings_model_name" {
  description = "Embeddings model used to generate vector embeddings. Don't forget to check region availability."
  type        = string
  default     = "text-embedding-3-large"
}

variable "embeddings_deployment_type" {
  description = "Embeddings model deployment type."
  type        = string
  default     = "Standard"
}

variable "embeddings_model_version" {
  description = "Embeddings model version."
  type        = string
  default     = "1"
}

variable "embeddings_deployment_name" {
  description = "Embeddings model deployment name."
  type        = string
  default     = "text-embedding"
}

variable "embeddings_vector_size" {
  description = "Vector embeddings size."
  type        = number
  default     = 3072
}

variable "embeddings_deployment_capacity" {
  description = "Embeddings model tokens per Minute Rate Limit (thousands)."
  type        = number
  default     = 40
}

variable "openai_api_version" {
  description = "Azure OpenAI API version."
  type        = string
  default     = "2024-10-21"
}

variable "chat_gpt_llm_monitoring" {
  description = "Enables LLM monitoring to generate conversation metrics."
  type        = bool
  default     = true
}
