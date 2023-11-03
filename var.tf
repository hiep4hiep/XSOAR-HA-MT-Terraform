variable "aws_vpc" {
    default = "<your-vpc-id>"
}

# Create 3 subnets in 3 AZ and put subnet IDs here
variable "aws_subnet_az1" {
    default = "<your-subnet-in-az1>"
}

variable "aws_subnet_az2" {
    default = "<your-subnet-in-az2>"
}

variable "aws_subnet_az3" {
    default = "<your-subnet-in-az3>"
}

# The prefix that will be appended to your resource name, e.g dev, uat, prod, test, somename...
variable "deployment_prefix" {
    default = "<your-deployment-prefix>"
}

variable "xsoar_main_opensearch_domain" {
    default = "<name-of-your-opensearch-domain>" # Put any name you want here, it will be the name of the OpenSearch cluster
}

variable "opensearch_master_user" {
    default = "<opensearch-master-username>"
}

variable "opensearch_master_password" {
    default = "<opensearch-master-password>"
}

variable "xsoar_download_url" {
    default = "<url-to-download-xsoar-installer."  # URL to download XSOAR installer
}

data "local_file" "public_key" {
  filename = "<path-to-ssh-key>" # This public key will be used for EC2 instances
}

