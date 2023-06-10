provider "aws" {
  region = "ap-southeast-1"
}

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

