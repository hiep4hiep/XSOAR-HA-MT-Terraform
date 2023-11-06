# The prefix that will be appended to your resource name, e.g dev, uat, prod, test, somename...
variable "deployment_prefix" {
    description = "your deployment prefix"
}

variable "aws_vpc" {
    description = "your vpc id"
}

# 3 public subnets in 3 AZ
variable "aws_subnet_az1" {
    description = "your subnet ID in az1"
}

variable "aws_subnet_az2" {
    description = "your subnet ID in az2"
}

variable "aws_subnet_az3" {
    description = "your subnet ID in az3"
}

# EC2 instance type like t2.small, m5.large
variable "xsoar_main_instance_type" {
    description = "xsoar main instance type"
}
variable "xsoar_host_instance_type" {
    description = "xsoar host instance type"
}
variable "xsoar_ami" {
    description = "ami id for xsoar main and host EC2"
}


# OpenSearch
variable "opensearch_instance_type" {
    description = "opensearch instance type"
}

variable "xsoar_main_opensearch_domain" {
    description = "name of your opensearch domain" 
}

variable "opensearch_master_user" {
    description = "opensearch master username"
}

variable "opensearch_master_password" {
    description = "opensearch master password"
}

variable "xsoar_download_url" {
    description = "url to download xsoar installer." 
}

variable "public_key" {
    description = "path to ssh key"
}

data "local_file" "public_key" {
  filename = var.public_key
}


