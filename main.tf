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

  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"

  availability_zone = "us-east-2a"
}