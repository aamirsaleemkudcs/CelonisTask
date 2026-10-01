data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = "celonis-tfstate-2026"
    key    = "dev/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "helm" {
  kubernetes = {
    host = data.terraform_remote_state.infrastructure.outputs.eks_cluster_endpoint

    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.infrastructure.outputs.eks_cluster_certificate_authority
    )

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.terraform_remote_state.infrastructure.outputs.eks_cluster_name,
        "--region",
        "us-east-2"
      ]
    }
  }
}