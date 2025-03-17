variable "speech_recognition_language" {
  description = "Language used for speech recognition in the frontend."
  type        = string
  default     = "en-US"
}

variable "speech_synthesis_language" {
  description = "Language used for speech synthesis in the frontend."
  type        = string
  default     = "en-US"
}

variable "speech_synthesis_voice_name" {
  description = "Voice used for speech synthesis in the frontend."
  type        = string
  default     = "en-US-RyanMultilingualNeural"
}
