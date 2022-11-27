module "eks-node-role" {
  source             = "../modules/iam"
  role_name          = "MaFurukawatkrEksNodeRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF
  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "group1"
  node_role_arn   = module.eks-node-role.role.arn
  subnet_ids      = [for l in data.terraform_remote_state.common_state.outputs.private_subnets : l.id]
  version         = local.cluster_version

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
}