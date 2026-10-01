
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority" {
  description = "EKS cluster certificate authority"
  value       = module.eks.cluster_certificate_authority
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = module.rds.db_port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = module.rds.db_name
}

output "rds_master_secret_arn" {
  description = "Secrets Manager ARN containing the RDS master credentials"
  value       = module.rds.master_secret_arn
}
