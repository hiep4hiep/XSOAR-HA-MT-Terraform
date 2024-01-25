
# Create XSOAR Main servers
resource "aws_instance" "xsoar_jump_host" {
  ami           = var.xsoar_ami
  instance_type = var.xsoar_main_instance_type
  associate_public_ip_address = false
  subnet_id = "subnet-018a925e84752d498"
  vpc_security_group_ids = ["${aws_security_group.xsoar_main_app.id}"]
  key_name = aws_key_pair.lab_key.key_name
  tags = {
    Name = "${var.deployment_prefix}-xsoar-jump-host"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
  iam_instance_profile = aws_iam_instance_profile.xsoar_main_server_profile.name
}