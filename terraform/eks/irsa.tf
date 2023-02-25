# IAMに外部（EKS）OIDCプロバイダを追加する。
# この設定により、EKSで発行されたsa用のIDトークンを、STSで一時認証情報に交換できる
resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  thumbprint_list = [data.tls_certificate.eks_oidc_provider.certificates[0].sha1_fingerprint]
  client_id_list  = ["sts.amazonaws.com"]
}

# saが引き受けるロールの定義
# service account作成時に以下のコマンドでアノテーション付与が必要
# kubectl annotate sa my-serviceaccount eks.amazonaws.com/role-arn=$MaFurukawatkrMyServiceAccountIrsa_ROLE_ARN
module "irsa-s3-readonly" {
  source             = "../modules/iam"
  role_name          = "MaFurukawatkrMyServiceAccountIrsa"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "${aws_iam_openid_connect_provider.eks_oidc_provider.arn}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${aws_iam_openid_connect_provider.eks_oidc_provider.url}:sub": "system:serviceaccount:default:my-serviceaccount",
                    "${aws_iam_openid_connect_provider.eks_oidc_provider.url}:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
  EOF
  policies           = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}