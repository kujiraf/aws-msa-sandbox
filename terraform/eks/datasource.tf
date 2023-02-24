data "aws_vpc" "ma-personal-vpc" {
  id = "vpc-05cd37450a750b709"
}

data "tls_certificate" "eks_oidc_provider" {
  url = "https://oidc.eks.ap-northeast-1.amazonaws.com"
}
