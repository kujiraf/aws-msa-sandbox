locals {
  p   = "ma-furukawatkr"
  aza = "ap-northeast-1a"
  azc = "ap-northeast-1c"

  public_subnets = [
    {
      name = "${local.p}-public-${local.aza}"
      az   = local.aza
      cidr = "10.2.41.0/26"
    },
    {
      name = "${local.p}-public-${local.azc}"
      az   = local.azc
      cidr = "10.2.41.64/26"
  }]
  private_subnets = [
    {
      name = "${local.p}-private-${local.aza}"
      az   = local.aza
      cidr = "10.2.41.128/26"
    },
    {
      name = "${local.p}-private-${local.azc}"
      az   = local.azc
      cidr = "10.2.41.192/26"
    }
  ]

  # [ type, protocol, from_port, to_port,  description, (map){cidr_blocks, source_sg-id, self}]
  ingress_http_80   = ["ingress", "tcp", 80, 80, null, { cidr_blocks = ["0.0.0.0/0"] }]
  ingress_https_443 = ["ingress", "tcp", 443, 443, null, { cidr_blocks = ["0.0.0.0/0"] }]
  egress_any        = ["egress", "tcp", 0, 65535, null, { cidr_blocks = ["0.0.0.0/0"] }]
  # ingress_ecs_dynamic-port = ["ingress", "tcp", 32768, 61000, {security_sg=module.public-alb-sg.sg.id}]
}
