resource "helm_release" "sonarqube" {
  name = "sonarqube"

  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart      = "sonarqube"
  version    = "2026.4.1"

  namespace        = var.namespace
  create_namespace = true

  atomic  = true
  wait    = true
  timeout = 900

  values = [
    yamlencode({

      # SonarQube Community Build
      community = {
        enabled = true
      }

      # ==========================================
      # External PostgreSQL - AWS RDS
      # ==========================================
      jdbcOverwrite = {
        enabled = true

        jdbcUrl = "jdbc:postgresql://${var.db_host}:${var.db_port}/${var.db_name}"

        jdbcUsername = var.db_username

        jdbcSecretName        = var.jdbc_secret_name
        jdbcSecretPasswordKey = "jdbc-password"
      }

      # ==========================================
      # Monitoring Passcode
      # ==========================================
      monitoringPasscodeSecretName = var.monitoring_secret_name
      monitoringPasscodeSecretKey  = "monitoring-passcode"

      # ==========================================
      # Internal Service Only
      # ==========================================
      service = {
        type = "ClusterIP"
      }

      # ==========================================
      # Lab Community Build Resources
      # ==========================================
      resources = {
        requests = {
          cpu    = "400m"
          memory = "2Gi"
        }

        limits = {
          cpu    = "800m"
          memory = "2Gi"
        }
      }

      # RDS stores application data.
      # Keep disabled for this lab deployment.
      persistence = {
        enabled = false
      }
    })
  ]
}