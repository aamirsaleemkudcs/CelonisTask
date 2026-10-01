module "sonarqube" {
  source = "../TF_Modules/SonarQube"

  namespace = "sonarqube"

  db_host = data.terraform_remote_state.infrastructure.outputs.rds_endpoint
  db_port = data.terraform_remote_state.infrastructure.outputs.rds_port
  db_name = data.terraform_remote_state.infrastructure.outputs.rds_db_name

  db_username = "sonaradmin"

  jdbc_secret_name       = "sonarqube-jdbc"
  monitoring_secret_name = "sonarqube-monitoring"
}