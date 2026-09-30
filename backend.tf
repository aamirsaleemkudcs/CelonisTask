terraform {
  backend "s3" {
    bucket       = "celonis-tfstate-2026"
    key          = "dev/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}