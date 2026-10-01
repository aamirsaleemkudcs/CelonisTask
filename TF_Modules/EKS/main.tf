# ==========================================
# EKS Cluster IAM Role
# ==========================================

resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "eks.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  role = aws_iam_role.eks_cluster.name
}

# ==========================================
# EKS Cluster
# ==========================================

resource "aws_eks_cluster" "main" {

  name = var.cluster_name

  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {

    subnet_ids = var.subnet_ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ==========================================
# EKS Node IAM Role
# ==========================================

resource "aws_iam_role" "eks_nodes" {

  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.eks_nodes.name
}


resource "aws_iam_role_policy_attachment" "ecr_readonly" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"

  role = aws_iam_role.eks_nodes.name
}


resource "aws_iam_role_policy_attachment" "cni_policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  role = aws_iam_role.eks_nodes.name
}

# ==========================================
# EKS Managed Node Group
# ==========================================

resource "aws_eks_node_group" "main" {

  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${var.cluster_name}-nodes"

  node_role_arn = aws_iam_role.eks_nodes.arn

  subnet_ids = var.subnet_ids

  instance_types = [
    var.instance_type
  ]

  capacity_type = "ON_DEMAND"

  disk_size = 20

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.ecr_readonly,
    aws_iam_role_policy_attachment.cni_policy
  ]

  tags = {
    Name        = "${var.cluster_name}-nodes"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_principal_arn
  type          = "STANDARD"

  depends_on = [
    aws_eks_cluster.main
  ]
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.admin
  ]
}