variable "vpc_id" {}

variable "ami" {}
variable "instance_type" {}
variable "iam_profile" {}
# variable "user_data" {}
variable "sg_id" {}
# variable "size" {}
# variable "device_name" {}

variable "ha_groups" {
  description = "テンプレートインスタンスをHA構成する際の変数map"
}
