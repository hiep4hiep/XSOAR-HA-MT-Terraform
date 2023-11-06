### Open Search cluster for both Main and Host servers

data "aws_vpc" "current" {
  id = var.aws_vpc
}

resource "aws_security_group" "xsoar_main_opensearch" {
  name        = "${var.deployment_prefix}-opensearch-${var.xsoar_main_opensearch_domain}"
  description = "Managed by Terraform"
  vpc_id      = data.aws_vpc.current.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.current.cidr_block,
    ]
  }
}


resource "aws_opensearch_domain" "xsoar_main_opensearch" {
  domain_name    = var.xsoar_main_opensearch_domain
  engine_version = "OpenSearch_2.9"

  cluster_config {
    instance_type = var.opensearch_instance_type
    instance_count = 3
    dedicated_master_enabled = true
    dedicated_master_count   = 3
    zone_awareness_enabled    = true
    zone_awareness_config {
      availability_zone_count   = 3
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 50  # Specify the desired EBS volume size in GB
  }

  vpc_options {
    subnet_ids = [
      var.aws_subnet_az1,
      var.aws_subnet_az2,
      var.aws_subnet_az3
    ]
    security_group_ids = [aws_security_group.xsoar_main_opensearch.id]
  }
  tags = {
    Domain = var.xsoar_main_opensearch_domain
  }

  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.opensearch_master_user
      master_user_password = var.opensearch_master_password
    }
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  node_to_node_encryption {
    enabled = true
  }

    access_policies = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "es:*",
          "Resource": "arn:aws:es:ap-southeast-2:751512424814:domain/${var.xsoar_main_opensearch_domain}/*"
        }
      ]
    }
    EOF
}

output "xsoar-main-opensearch-url" {
  value = aws_opensearch_domain.xsoar_main_opensearch.endpoint
}

output "xsoar-main-opensearch-kibana-url" {
  value = aws_opensearch_domain.xsoar_main_opensearch.dashboard_endpoint
}
