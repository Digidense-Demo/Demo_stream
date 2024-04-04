variable "description" {
  type        = string
  description = "The description for the KMS key"
  default = "Kms_key"
}

variable "deletion_window_in_days" {
  type        = number
  description = "The deletion window in days"
  default = 7
}

variable "enable_key_rotation" {
  type        = bool
  description = "Enable key rotation"
  default = true
}

variable "aliases_name" {
  type = string
  description = "this is for kms key name creation"
  default = "alias/Demo_stream_key"
}