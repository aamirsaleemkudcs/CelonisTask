output "release_name" {
  description = "SonarQube Helm release name"
  value       = helm_release.sonarqube.name
}

output "namespace" {
  description = "SonarQube Kubernetes namespace"
  value       = helm_release.sonarqube.namespace
}

output "status" {
  description = "SonarQube Helm release status"
  value       = helm_release.sonarqube.status
}