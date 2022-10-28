module "bastion-sg" {
  source      = "./modules/sg"
  vpc_id      = data.aws_vpc.ma-personal-vpc.id
  name        = "${local.p}-bas-sg"
  description = "${local.p}-bas-sg"
  rules = {
    "ingress_http_80"   = local.ingress_http_80,
    "ingress_https_443" = local.ingress_https_443,
    "egress_any"        = local.egress_any
  }
}

module "bastion" {
  source = "./modules/ec2"

  vpc_id        = data.aws_vpc.ma-personal-vpc.id
  ami           = "ami-0de5311b2a443fb89"
  instance_type = "t2.medium"
  iam_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  sg_id         = [module.bastion-sg.sg.id]

  # size        = 8
  # device_name = "/dev/xvda"

  # HA params
  ha_groups = [
    {
      name        = "${local.p}-bastion"
      subnet      = module.private_subnets.subnets[local.private_subnets[0].name]
      private_ips = ["10.2.41.132"]
    }
  ]
}
