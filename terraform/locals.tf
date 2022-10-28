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

  # [ type, protocol, from_port, to_port,  sg-id, cidr_blocks, description ]
  ingress_http_80   = ["ingress", "tcp", 80, 80, null, ["0.0.0.0/0"], null]
  ingress_https_443 = ["ingress", "tcp", 443, 443, null, ["0.0.0.0/0"], null]
  # ingress_ecs_dynamic-port = ["ingress", "tcp", 32768, 61000, module.public-alb-sg.sg.id, null, null]
}
