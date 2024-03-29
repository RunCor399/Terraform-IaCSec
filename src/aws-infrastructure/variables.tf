variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "backend_access_key" {}
variable "backend_secret_key" {}

variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "vpc_name" {
  type    = string
  default = "eks-lab-vpc-module"
}

variable "eks_cluster_name" {
  type    = string
  default = "eks-lab-cluster-module"
}

variable "private_subnets_num" {
  type    = number
  default = 1
}

variable "public_subnets_num" {
  type = number
  default = 2
}

variable "db_subnets_num" {
  type    = number
  default = 2
}


variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "db_pwd" {
  type = string
  sensitive = true
}