module "public_subnets" {
  source           = "../modules/subnet"
  vpc_id           = data.aws_vpc.ma-personal-vpc.id
  subnets          = local.public_subnets
  route_table_name = "${local.p}-public-rtb"
  igw_id           = data.aws_internet_gateway.ma-personal-igw.internet_gateway_id
  tags             = { "kubernetes.io/role/elb" = 1 }
}

resource "aws_nat_gateway" "public_nag_gw" {
  allocation_id = data.aws_eip.ma_allocation_id.id
  # attach public subnet 1a
  subnet_id = module.public_subnets.subnets[local.public_subnets[0].name].id
  tags = {
    Name = "${local.p}-natgw"
  }
}

module "private_subnets" {
  source           = "../modules/subnet"
  vpc_id           = data.aws_vpc.ma-personal-vpc.id
  subnets          = local.private_subnets
  route_table_name = "${local.p}-private-rtb"
  nat_gw_id        = aws_nat_gateway.public_nag_gw.id
  tags             = { "kubernetes.io/role/internal-elb" = 1 }
}

module "public-alb-sg" {
  source      = "../modules/sg"
  vpc_id      = data.aws_vpc.ma-personal-vpc.id
  name        = "${local.p}-public-alb-sg"
  description = "${local.p}-public-alb-sg"
  rules = {
    "ingress_http_80"   = local.ingress_http_80,
    "ingress_https_443" = local.ingress_https_443
  }
}

module "public-alb-tg-sg" {
  source      = "../modules/sg"
  vpc_id      = data.aws_vpc.ma-personal-vpc.id
  name        = "${local.p}-public-alb-tg-sg"
  description = "${local.p}-public-alb-tg-sg"
  rules = {
    "ingress_http_80"   = local.ingress_http_80,
    "ingress_https_443" = local.ingress_https_443,
    "egress_any"        = local.egress_any
    # "ingress_ecs_dynamic-port" = local.ingress_ecs_dynamic-port
  }
}

###############################################
# module "ecs_frontend_instances_tg" {
#   source = "./modules/tg"

#   # target group
#   vpc_id   = data.aws_vpc.ma-personal-vpc.id
#   tg_name  = "${local.p}-frontend-tg"
#   tg_port  = 80
#   protocol = "HTTP"

#   # instance template
#   ami           = "ami-02c3627b04781eada"
#   instance_type = "t2.medium"
#   iam_profile   = "${local.p}-ssmEcsService"
#   user_data     = <<EOF
#     #!/bin/bash
#     echo ECS_CLUSTER=${local.p}-ecs-cluster-frontend >> /etc/ecs/ecs.config
#     EOF
#   sg_id         = [module.public-alb-tg-sg.sg.id]
#   size          = 8
#   device_name   = "/dev/xvda"

#   # HA params
#   ha_groups = [
#     {
#       name        = "${local.p}-ecs-instance-frontend"
#       subnet      = module.public_subnets.subnets[local.public_subnets[1].name]
#       private_ips = ["10.2.10.121"]
#     }
#   ]
# }

# module "ecs_frontend_alb"{
#   source="./modules/elb"
#   lb_type="application"
# }
