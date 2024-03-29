locals {
  p   = "ma-furukawatkr"
  aza = "ap-northeast-1a"
  azc = "ap-northeast-1c"

  cluster_version = 1.24

  # [ type, protocol, from_port, to_port,  description, (map){cidr_blocks, source_sg-id, self}]
  ingress_http_80   = ["ingress", "tcp", 80, 80, null, { cidr_blocks = ["0.0.0.0/0"] }]
  ingress_https_443 = ["ingress", "tcp", 443, 443, null, { cidr_blocks = ["0.0.0.0/0"] }]
  egress_any        = ["egress", "tcp", 0, 65535, null, { cidr_blocks = ["0.0.0.0/0"] }]

  allowed_cidr = ["106.72.167.33/32"]

  subnets_list = concat(
    [for l in data.terraform_remote_state.common_state.outputs.private_subnets : l.id],
    [for l in data.terraform_remote_state.common_state.outputs.public_subnets : l.id]
  )
}
