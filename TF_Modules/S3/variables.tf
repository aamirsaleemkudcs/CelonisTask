variable "bucket_name" {
  description = "S3 bucket used to store Terraform state"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}