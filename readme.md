Technical Challenge for Senior Solutions Architect
##################################################
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

Part 2: Kubernetes Operations (Submission)
Goal: Demonstrate "Day 2" operations and troubleshooting.
Scenario:
Imagine the application is running, but a specific configuration row in the database
needs to be manually updated using a SQL command (UPDATE settings SET
value='true' WHERE key='sonar.forceAuthentication';).
Requirements:
1. The "Fixer" Task: Create a Kubernetes manifest that spins up an ephemeral
container to connect to the database and execute the SQL command above.
2. Security: The container must authenticate with the database securely without
exposing credentials in plain text.

Part 3: Live Session Preparation (The Interview)
Goal: Be ready to demonstrate a fully functional environment live using professional
tooling.
Please come to the interview with your local Kubernetes environment (Minikube,
Kind, or Docker Desktop) running.
1. Local Setup Requirements:
Since you do not have a real AWS RDS instance locally, you must:
1. Provision a Local Database: Deploy a PostgreSQL instance inside your local
cluster (using a Helm chart, Operator, or plain manifest) to act as the RDS
substitute.
2. Deploy the App: Install SonarQube pointing to this local database.
2. Tooling Expectations (Crucial):
We expect the Environment Owner to handle debugging and cluster navigation
fluently and efficiently.
1. Do not rely solely on basic kubectl commands.
2. Please have k9s (or a similar Kubernetes TUI/Dashboard) installed and ready to
use.
3. You will be asked to navigate namespaces, view logs, shell into pods, and edit
resources in real-time.
During the interview, we will ask you to:
1. Prove Health: Use your tooling to show us that SonarQube is running and
connected to the local database.
2. Run the Job: Execute the "Fixer" manifest you wrote in Part 2.
○ Success Criteria: The Job must successfully connect to the local DB, execute
the update, and terminate with status Completed.
3. Live Configuration: We will ask you to make a configuration change to the
running cluster on the fly to test your Helm/K8s agility.
Submission Guidelines
Please zip your Terraform and Kubernetes files into a secure archive and share it with
us prior to the interview.