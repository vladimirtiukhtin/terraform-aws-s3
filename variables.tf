variable "name" {
  description = "Common name, a unique identifier"
  type        = string
}

variable "force_destroy" {
  description = "Enables terraform to destroy the bucket even if it's not empty"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "AWS KMS ARN"
  type        = string
  default     = null
}

variable "bucket_policy_statements" {
  description = ""
  type = list(object({
    Effect    = string
    Principal = any
    Action    = any
    Resource  = any
  }))
  default = []
}

variable "object_ownership" {
  description = ""
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "versioning" {
  description = "Whether or not versioning should be enabled"
  type        = string

  validation {
    condition     = contains(["Enabled", "Disabled", "Suspended"], var.versioning)
    error_message = "Name must comply with \"(^[0-9A-Za-z][A-Za-z0-9\\-_]+$)\""
  }

  default = "Enabled" // Enabled, Suspended, or Disabled
}

variable "restrict_public_buckets" {
  description = ""
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = ""
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = ""
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = ""
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Map of additional tags to add to module's resources"
  type        = map(string)
  default     = {}
}
