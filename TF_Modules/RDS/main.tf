# ==========================================
# RDS Subnet Group
# ==========================================

resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-${var.environment}-db-subnet-group"

  subnet_ids = var.database_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ==========================================
# RDS Security Group
# ==========================================

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Allow PostgreSQL only from EKS private subnets"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from EKS private subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    cidr_blocks = var.allowed_cidr_blocks
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}


# ==========================================
# PostgreSQL RDS
# ==========================================

resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  engine = "postgres"

  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username

  # AWS RDS generates and manages the master
  # password in AWS Secrets Manager.
  manage_master_user_password = true

  port = 5432

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  # CRITICAL:
  # Database receives no public endpoint.
  publicly_accessible = false

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period

  auto_minor_version_upgrade = true

  deletion_protection = false

  skip_final_snapshot = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-postgres"
    Environment = var.environment
    Application = "SonarQube"
    ManagedBy   = "Terraform"
  }
}