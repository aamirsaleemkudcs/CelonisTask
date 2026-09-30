variable "bucket_name" {
  description = "Name of the S3 bucket used for Terraform state"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}