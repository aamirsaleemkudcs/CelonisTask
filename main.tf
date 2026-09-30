module "s3_backend" {
  source = "./TF_Modules/S3"

  bucket_name = "celonis-tfstate-dev"
  environment = "dev"
}