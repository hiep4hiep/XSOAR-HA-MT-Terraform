# EFS for XSOAR Main
resource "aws_security_group" "xsoar_main_efs_sg" {
  name        = "${var.deployment_prefix}-xsoar-main-efs-sg"
  description = "connect to efs"
  vpc_id      = data.aws_vpc.current.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      data.aws_vpc.current.cidr_block,
    ]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EFS for XSOAR Main Host
resource "aws_efs_file_system" "xsoar_main_efs" {
  creation_token = "${var.deployment_prefix}-xsoar-main-efs"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  tags = {
    Name = "${var.deployment_prefix}-xsoar-main-efs"
  }
}

resource "aws_efs_mount_target" "xsoar_main_mount_az1" {
  count          = 1
  file_system_id = aws_efs_file_system.xsoar_main_efs.id
  subnet_id      = var.aws_subnet_az1  
  security_groups = ["${aws_security_group.xsoar_main_efs_sg.id}"]
}

resource "aws_efs_mount_target" "xsoar_main_mount_az2" {
  count          = 1
  file_system_id = aws_efs_file_system.xsoar_main_efs.id
  subnet_id      = var.aws_subnet_az2 
  security_groups = ["${aws_security_group.xsoar_main_efs_sg.id}"]
}

resource "aws_efs_mount_target" "xsoar_main_mount_az3" {
  count          = 1
  file_system_id = aws_efs_file_system.xsoar_main_efs.id
  subnet_id      = var.aws_subnet_az3 
  security_groups = ["${aws_security_group.xsoar_main_efs_sg.id}"]
}

output "xsoar_main_efs_target" {
  value=aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name
}


# EFS for XSOAR Host Group
resource "aws_efs_file_system" "xsoar_host_efs" {
  creation_token = "${var.deployment_prefix}-xsoar-host-efs"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  tags = {
    Name = "${var.deployment_prefix}-xsoar-host-efs"
  }
}

resource "aws_efs_mount_target" "xsoar_host_mount_az1" {
  count          = 1
  file_system_id = aws_efs_file_system.xsoar_host_efs.id
  subnet_id      = var.aws_subnet_az1
  security_groups = ["${aws_security_group.xsoar_main_efs_sg.id}"]
}

resource "aws_efs_mount_target" "xsoar_host_mount_az2" {
  count          = 1
  file_system_id = aws_efs_file_system.xsoar_host_efs.id
  subnet_id      = var.aws_subnet_az2
  security_groups = ["${aws_security_group.xsoar_main_efs_sg.id}"]
}

resource "aws_efs_mount_target" "xsoar_host_mount_az3" {
  count          = 1
  file_system_id = aws_efs_file_system.xsoar_host_efs.id
  subnet_id      = var.aws_subnet_az3
  security_groups = ["${aws_security_group.xsoar_main_efs_sg.id}"]
}

output "xsoar_host_efs_target" {
  value=aws_efs_mount_target.xsoar_host_mount_az2[0].dns_name
}