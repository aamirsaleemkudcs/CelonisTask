variable "db_host" {
  description = "RDS PostgreSQL hostname"
  type        = string
}

variable "db_port" {
  description = "RDS PostgreSQL port"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "SonarQube PostgreSQL database name"
  type        = string
}

variable "db_username" {
  description = "SonarQube PostgreSQL username"
  type        = string
}

variable "jdbc_secret_name" {
  description = "Kubernetes Secret containing the RDS password"
  type        = string
  default     = "sonarqube-jdbc"
}

variable "monitoring_secret_name" {
  description = "Kubernetes Secret containing the SonarQube monitoring passcode"
  type        = string
  default     = "sonarqube-monitoring"
}

variable "namespace" {
  description = "Kubernetes namespace for SonarQube"
  type        = string
  default     = "sonarqube"
}