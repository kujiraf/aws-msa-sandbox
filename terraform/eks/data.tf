data "terraform_remote_state" "common_state" {
  backend = "s3"
  config = {
    bucket = "ma-furukawatkr-tfstate"
    region = "ap-northeast-1"
    key    = "common/terraform.tfstate"
  }
}
