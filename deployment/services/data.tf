### fetch info
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id] # fetch from datasource vpc
  }
}

data "aws_acm_certificate" "api-sohan-cloud" {
  domain      = "api.sohan.cloud"
  types       = ["IMPORTED"]
  most_recent = true
}


data "aws_ecr_repository" "rg-ops" {
  name = "rg-ops-image"
}

data "aws_ecr_image" "rg-ops" {
  repository_name = data.aws_ecr_repository.rg-ops.name
  image_tag       = "latest"
}
