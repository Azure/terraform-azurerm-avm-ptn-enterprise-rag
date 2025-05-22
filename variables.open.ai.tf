variable "azure_open_ai_create" {
  type        = bool
  default     = true
  description = "Flag to create Azure Open AI Services. If set to false, the resource will not be created."
  nullable    = false
}

variable "azure_open_ai" {
  type        = any
  default     = {}
  description = "Azure Open AI Service to be created. For details concerning inputs, see https://registry.terraform.io/modules/Azure/avm-res-cognitiveservices-account/azurerm/0.7.0?tab=inputs."
  nullable    = false
}


variable "rai_policies" {
  type = map(object({
    name             = string
    base_policy_name = string
    mode             = string
    content_filters = optional(list(object({
      blocking           = bool
      enabled            = bool
      name               = string
      severity_threshold = string
      source             = string
    })))
    custom_block_lists = optional(list(object({
      source          = string
      block_list_name = string # Has to match an existing name or the name defined in `var.rai_block_lists`
      blocking        = bool
    })))
  }))
  description = "List of RAI policies to be created."
  default = {
    primary = {
      name             = "default-gpt-rag"
      base_policy_name = "Microsoft.Default"
      mode             = "default"
      content_filters = [
        {
          name                = "hate"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "prompt"
        },
        {
          name                = "sexual"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "prompt"
        },
        {
          name                = "selfharm"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "prompt"
        },
        {
          name                = "violence"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "prompt"
        },
        {
          name                = "hate"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "completion"
        },
        {
          name                = "sexual"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "completion"
        },
        {
          name                = "selfharm"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "completion"
        },
        {
          name                = "violence"
          blocking            = true
          enabled             = true
          allowedContentLevel = "medium"
          source              = "completion"
        },
        {
          name     = "jailbreak"
          blocking = false
          source   = "prompt"
          enabled  = false
        },
        {
          name     = "protected_material_text"
          blocking = false
          source   = "completion"
          enabled  = false
        },
        {
          name     = "protected_material_code"
          blocking = false
          source   = "completion"
          enabled  = false
        }
      ]
      custom_block_lists = [
        {
          source          = "prompt"
          blocking        = true
          block_list_name = "gpt-rag-blocklist"
        },
        {
          source          = "completion"
          blocking        = true
          block_list_name = "gpt-rag-blocklist"
        }
      ]
    }
  }
}

variable "rai_block_lists" {
  type = map(object({
    name        = string
    description = optional(string)
    block_list_items = optional(map(object({
      isRegex = bool
      pattern = string
    })))
  }))
  description = "A collection of RAI block lists and their items."
  default = {
    primary = {
      name        = "gpt-rag-blocklist"
      description = "Blocklist for GPT RAG"

      block_list_items = {
        primary = {
          name    = "primary"
          isRegex = false
          pattern = ""
        }
      }
    }
  }
}
