module "eks-cluster-role" {
  source             = "../modules/iam"
  role_name          = "MaFurukawatkrEksClusterRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
  policies           = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
}

module "eks-cluster-sg" {
  source      = "../modules/sg"
  vpc_id      = data.aws_vpc.ma-personal-vpc.id
  name        = "${local.p}-eks-cluster-sg"
  description = "managed my terraform module eks-cluster-sg"
  rules = {
    "ingress_all_self" = ["ingress", "tcp", 0, 65535, null, { self = true }]
    "ingress_bas_sg"   = ["ingress", "tcp", 0, 65535, "ingress from bastion", { source_sg = data.terraform_remote_state.common_state.outputs.bastion_sg.id }]
    "egress_any"       = local.egress_any
  }
}

resource "aws_eks_cluster" "this" {
  depends_on                = [aws_cloudwatch_log_group.eks_log_group]
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  name     = "${local.p}-eks-cluster"
  role_arn = module.eks-cluster-role.role.arn
  version  = local.cluster_version
  vpc_config {
    subnet_ids              = [for l in data.terraform_remote_state.common_state.outputs.private_subnets : l.id]
    security_group_ids      = [module.eks-cluster-sg.sg.id]
    endpoint_private_access = true
    public_access_cidrs     = local.allowed_cidr
  }
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/${local.p}-eks/cluster"
  retention_in_days = 7
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  thumbprint_list = [data.tls_certificate.eks_oidc_provider.certificates[0].sha1_fingerprint]
  client_id_list  = ["sts.amazonaws.com"]
}