resource "aws_iam_role" "eks_cluster_role" {
  name = "maFurukawatkrEksClusterRole"
  tags = {
    Name = "${local.p}-eks-cluster-role"
  }
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
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" // AWS managed policy
}

module "eks-cluster-sg" {
  source      = "./modules/sg"
  vpc_id      = data.aws_vpc.ma-personal-vpc.id
  name        = "${local.p}-eks-cluster-sg"
  description = "${local.p}-eks-cluster-sg"
  rules = {
    "ingress_all_self" = ["ingress", "tcp", 0, 65535, null, { self = true }]
    "egress_any"       = local.egress_any
  }
}
