Technical Challenge for Senior Solutions Architect
Role: Environment Owner / Ops Engineer Time Limit: ~3-4 hours (Preparation) + Live Demo Scenario: You are the Environment Owner responsible for provisioning a dedicated Code Quality Environment (SonarQube) for a development team.
Context
The architecture must be "Production Grade"—secure, resilient, automated, and ready for future scaling.
1. Database: Managed AWS RDS PostgreSQL.
2. Compute: AWS EKS Cluster.
3. Application: SonarQube (Community Edition) deployed via Helm.
Note on Scope:
● Part 1 (Production Design): You will write the Terraform code for the ideal AWS production setup. (Code only—do not apply this to a real AWS account).
● Part 2 (Kubernetes Operations): You will write a Kubernetes manifest to perform a manual troubleshooting task.
● Part 3 (Live Simulation): You will prepare a working local environment (Minikube/Kind) to demonstrate the application running live during the interview.
Part 1: Infrastructure as Code (Submission)
Goal: Architect the "Production" AWS environment using Terraform.
Requirements:
1. Infrastructure: Write Terraform code to provision:
○ A VPC Network optimized for security.
○ An EKS Cluster.
○ An RDS PostgreSQL instance (Strictly isolated from the public internet).
2. Application Deployment:
○ Use the Terraform Helm Provider to deploy SonarQube.
○ The application must be configured to use the created RDS instance.
3. Quality Standards:
○ Ensure the codebase is designed for team collaboration and long-term
maintainability.
○ Adhere to enterprise security standards regarding network isolation and
credential management.
