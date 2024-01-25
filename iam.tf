# IAM for XSOAR Main
resource "aws_iam_policy" "xsoar_main_iam_policy" {
  name        = "${var.deployment_prefix}-xsoar-main-policy"
  description = "IAM policy to allow XSOAR access to OpenSearch and EFS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "es:*"
        ],
        Resource = "${aws_opensearch_domain.xsoar_main_opensearch.arn}"
      },
      {
        Effect = "Allow",
        Action = [
          "elasticfilesystem:*"
        ],
        Resource = "${aws_efs_file_system.xsoar_main_efs.arn}"
       
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "xsoar_main_policy_attachment" {
  name = "${var.deployment_prefix}-xsoar-main-policy-opensearch"
  policy_arn = aws_iam_policy.xsoar_main_iam_policy.arn
  roles      = [aws_iam_role.xsoar_main_server_role.name]
}


resource "aws_iam_role" "xsoar_main_server_role" {
  name = "${var.deployment_prefix}-xsoar-main-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "xsoar_main_server_profile" {
  name = "${var.deployment_prefix}-xsoar-main-server-profile"
  role = aws_iam_role.xsoar_main_server_role.name
}


# IAM for XSOAR Host
resource "aws_iam_policy" "xsoar_host_iam_policy" {
  name        = "${var.deployment_prefix}-xsoar-host-policy"
  description = "IAM policy to allow XSOAR access to OpenSearch and EFS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "es:*"
        ],
        Resource = "${aws_opensearch_domain.xsoar_main_opensearch.arn}"
      },
      {
        Effect = "Allow",
        Action = [
          "elasticfilesystem:*"
        ],
        Resource = "${aws_efs_file_system.xsoar_host_efs.arn}"
       
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "xsoar_host_policy_attachment" {
  name = "${var.deployment_prefix}-xsoar-host-policy-opensearch"
  policy_arn = aws_iam_policy.xsoar_host_iam_policy.arn
  roles      = [aws_iam_role.xsoar_host_server_role.name]
}


resource "aws_iam_role" "xsoar_host_server_role" {
  name = "${var.deployment_prefix}-xsoar-host-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "xsoar_host_server_profile" {
  name = "${var.deployment_prefix}-xsoar-host-server-profile"
  role = aws_iam_role.xsoar_host_server_role.name
}