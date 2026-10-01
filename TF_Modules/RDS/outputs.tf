output "db_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "PostgreSQL port"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.postgres.db_name
}

output "db_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "master_secret_arn" {
  description = "Secrets Manager ARN containing RDS master credentials"
  value       = aws_db_instance.postgres.master_user_secret[0].secret_arn
}