# ==================================
# S3 Module
# ==================================

module "s3_dev" {
  source = "./TF_Modules/S3"

  bucket_name = "celonis-tfstate-dev"
  environment = "dev"
}


# ==================================
# VPC Module
# ==================================

module "vpc" {
  source = "./TF_Modules/VPC"

  project_name = "celonis"
  environment  = "dev"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidr = "10.0.1.0/24"

  private_subnet_cidr   = "10.0.2.0/24"
  private_subnet_2_cidr = "10.0.3.0/24"

  database_subnet_1_cidr = "10.0.10.0/24"
  database_subnet_2_cidr = "10.0.11.0/24"

  availability_zone   = "us-east-2a"
  availability_zone_2 = "us-east-2b"
}


# ==================================
# EKS Module
# ==================================

#module "eks" {
#  source = "./TF_Modules/EKS"
#
#  cluster_name = "celonis-eks-dev"
#  environment  = "dev"
#
#  subnet_ids = module.vpc.private_subnet_ids
#
#  instance_type = "t3.small"
#
#  desired_size = 2
#  min_size     = 1
#  max_size     = 3
#}


# ==================================
# RDS PostgreSQL Module
# ==================================

module "rds" {
  source = "./TF_Modules/RDS"

  project_name = "celonis"
  environment  = "dev"

  vpc_id = module.vpc.vpc_id

  database_subnet_ids = module.vpc.database_subnet_ids

  # Only workloads in EKS private subnets
  # can connect to PostgreSQL.
  allowed_cidr_blocks = [
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  db_instance_class = "db.t3.micro"

  db_name     = "sonarqube"
  db_username = "sonaradmin"

  multi_az = false
}