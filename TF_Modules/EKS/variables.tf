variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets used by EKS"
  type        = list(string)
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "admin_principal_arn" {
  description = "IAM principal granted administrator access to the EKS cluster"
  type        = string
}