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
  description = "${local.p}-eks-cluster-sg"
  rules = {
    "ingress_all_self" = ["ingress", "tcp", 0, 65535, null, { self = true }]
    "egress_any"       = local.egress_any
  }
}
