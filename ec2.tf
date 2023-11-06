resource "aws_key_pair" "lab_key" {
  key_name = "lab_key"
  public_key = file(data.local_file.public_key.filename)
}

resource "aws_security_group" "xsoar_main_app" {
  name        = "${var.deployment_prefix}-xsoar-main-app"
  description = "SSH and HTTPS to xsoar app"
  vpc_id      = data.aws_vpc.current.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.current.cidr_block,
      "130.41.199.0/24"
    ]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.current.cidr_block,
      "130.41.199.0/24"
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create XSOAR Main servers
resource "aws_instance" "xsoar_app_01" {
  ami           = var.xsoar_ami
  instance_type = var.xsoar_main_instance_type
  associate_public_ip_address = true
  subnet_id = var.aws_subnet_az1
  vpc_security_group_ids = ["${aws_security_group.xsoar_main_app.id}"]
  key_name = aws_key_pair.lab_key.key_name
  tags = {
    Name = "${var.deployment_prefix}-xsoar-app-01"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
  iam_instance_profile = aws_iam_instance_profile.xsoar_main_server_profile.name
  user_data = <<EOF
#!/bin/bash
mkdir /var/lib/demisto
apt-get update -y
apt-get install nfs-common -y
apt-get install jq -y
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto
echo ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0 >> /etc/fstab
wget "${var.xsoar_download_url}" -O demisto_installer.sh
chmod +x demisto_installer.sh
./demisto_installer.sh -- -y -multi-tenant -elasticsearch-url=https://${aws_opensearch_domain.xsoar_main_opensearch.endpoint} -elasticsearch-username=${var.opensearch_master_user} -elasticsearch-password=${var.opensearch_master_password} -do-not-start-server
jq '.elasticsearch += {"shards":{"common-invplaybook":3,"common-entry":3},"replicas":{"common-invplaybook":1,"common-entry":1},"defaultShardsPerIndex":1,"defaultReplicasPerIndex":2,"refreshIntervals":{"*":"30s","common-configuration":"1s","common-incident":"1s"}}' /etc/demisto.conf > temp.conf && mv temp.conf /etc/demisto.conf
chown -R demisto:demisto /etc/demisto.conf
systemctl start demisto
EOF
}

resource "aws_instance" "xsoar_app_02" {
  ami           = var.xsoar_ami
  instance_type = var.xsoar_main_instance_type
  associate_public_ip_address = true
  subnet_id = var.aws_subnet_az2
  vpc_security_group_ids = ["${aws_security_group.xsoar_main_app.id}"]
  key_name = aws_key_pair.lab_key.key_name
  tags = {
    Name = "${var.deployment_prefix}-xsoar-app-02"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
  iam_instance_profile = aws_iam_instance_profile.xsoar_main_server_profile.name
  user_data = <<EOF
#!/bin/bash
mkdir /var/lib/demisto
apt-get update -y
apt-get install nfs-common -y
apt-get install jq -y
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto
echo ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0 >> /etc/fstab
wget "${var.xsoar_download_url}" -O demisto_installer.sh
chmod +x demisto_installer.sh
./demisto_installer.sh -- -y -multi-tenant -elasticsearch-url=https://${aws_opensearch_domain.xsoar_main_opensearch.endpoint} -elasticsearch-username=${var.opensearch_master_user} -elasticsearch-password=${var.opensearch_master_password} -do-not-start-server
jq '.elasticsearch += {"shards":{"common-invplaybook":3,"common-entry":3},"replicas":{"common-invplaybook":1,"common-entry":1},"defaultShardsPerIndex":1,"defaultReplicasPerIndex":2,"refreshIntervals":{"*":"30s","common-configuration":"1s","common-incident":"1s"}}' /etc/demisto.conf > temp.conf && mv temp.conf /etc/demisto.conf
chown -R demisto:demisto /etc/demisto.conf
systemctl start demisto
EOF
}

resource "aws_instance" "xsoar_app_03" {
  ami           = var.xsoar_ami
  instance_type = var.xsoar_main_instance_type
  associate_public_ip_address = true
  subnet_id = var.aws_subnet_az3
  vpc_security_group_ids = ["${aws_security_group.xsoar_main_app.id}"]
  key_name = aws_key_pair.lab_key.key_name
  tags = {
    Name = "${var.deployment_prefix}-xsoar-app-03"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
  iam_instance_profile = aws_iam_instance_profile.xsoar_main_server_profile.name
  user_data = <<EOF
#!/bin/bash
mkdir /var/lib/demisto
apt-get update -y
apt-get install nfs-common -y
apt-get install jq -y
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto
echo ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0 >> /etc/fstab
wget "${var.xsoar_download_url}" -O demisto_installer.sh
chmod +x demisto_installer.sh
./demisto_installer.sh -- -y -multi-tenant -elasticsearch-url=https://${aws_opensearch_domain.xsoar_main_opensearch.endpoint} -elasticsearch-username=${var.opensearch_master_user} -elasticsearch-password=${var.opensearch_master_password} -do-not-start-server
jq '.elasticsearch += {"shards":{"common-invplaybook":3,"common-entry":3},"replicas":{"common-invplaybook":1,"common-entry":1},"defaultShardsPerIndex":1,"defaultReplicasPerIndex":2,"refreshIntervals":{"*":"30s","common-configuration":"1s","common-incident":"1s"}}' /etc/demisto.conf > temp.conf && mv temp.conf /etc/demisto.conf
chown -R demisto:demisto /etc/demisto.conf
systemctl start demisto
EOF
}

# EC2 for Host servers
resource "aws_instance" "xsoar_host_01" {
  ami           = var.xsoar_ami
  instance_type = var.xsoar_host_instance_type
  associate_public_ip_address = false
  subnet_id = var.aws_subnet_az1
  vpc_security_group_ids = ["${aws_security_group.xsoar_main_app.id}"]
  key_name = aws_key_pair.lab_key.key_name
  tags = {
    Name = "${var.deployment_prefix}-xsoar-host-01"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
  iam_instance_profile = aws_iam_instance_profile.xsoar_host_server_profile.name
}

resource "aws_instance" "xsoar_host_02" {
  ami           = var.xsoar_ami
  instance_type = var.xsoar_host_instance_type
  associate_public_ip_address = false
  subnet_id = var.aws_subnet_az2
  vpc_security_group_ids = ["${aws_security_group.xsoar_main_app.id}"]
  key_name = aws_key_pair.lab_key.key_name
  tags = {
    Name = "${var.deployment_prefix}-xsoar-host-02"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
  iam_instance_profile = aws_iam_instance_profile.xsoar_host_server_profile.name
}


resource "aws_instance" "xsoar_host_03" {
  ami           = var.xsoar_ami
  instance_type = var.xsoar_host_instance_type
  associate_public_ip_address = false
  subnet_id = var.aws_subnet_az3
  vpc_security_group_ids = ["${aws_security_group.xsoar_main_app.id}"]
  key_name = aws_key_pair.lab_key.key_name
  tags = {
    Name = "${var.deployment_prefix}-xsoar-host-03"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    encrypted   = true
  }
  iam_instance_profile = aws_iam_instance_profile.xsoar_host_server_profile.name
}


resource "local_file" "xsoar_main_installation_script" {
  content = <<EOF
#!/bin/bash
mkdir /var/lib/demisto
apt-get update -y
apt-get install nfs-common -y
apt-get install jq -y
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto
echo ${aws_efs_mount_target.xsoar_main_mount_az1[0].dns_name}:/ /var/lib/demisto nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0 >> /etc/fstab
wget "${var.xsoar_download_url}" -O demisto_installer.sh
chmod +x demisto_installer.sh
./demisto_installer.sh -- -y -multi-tenant -elasticsearch-url=https://${aws_opensearch_domain.xsoar_main_opensearch.endpoint} -elasticsearch-username=${var.opensearch_master_user} -elasticsearch-password=${var.opensearch_master_password} -do-not-start-server
jq '.elasticsearch += {"shards":{"common-invplaybook":3,"common-entry":3},"replicas":{"common-invplaybook":1,"common-entry":1},"defaultShardsPerIndex":1,"defaultReplicasPerIndex":2,"refreshIntervals":{"*":"30s","common-configuration":"1s","common-incident":"1s"}}' /etc/demisto.conf > temp.conf && mv temp.conf /etc/demisto.conf
chown -R demisto:demisto /etc/demisto.conf
systemctl start demisto
EOF
  filename = "./xsoar_main_installation_script.sh"
}

resource "local_file" "xsoar_host_installation_script" {
  content = <<EOF
#!/bin/bash
mkdir /var/lib/demisto
apt-get update -y
apt-get install nfs-common -y
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_mount_target.xsoar_host_mount_az1[0].dns_name}:/ /var/lib/demisto
echo ${aws_efs_mount_target.xsoar_host_mount_az1[0].dns_name}:/ /var/lib/demisto nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0 >> /etc/fstab
chmod +x $1
.$1 -- -y -multi-tenant -elasticsearch-url=https://${aws_opensearch_domain.xsoar_main_opensearch.endpoint} -elasticsearch-username=${var.opensearch_master_user} -elasticsearch-password=${var.opensearch_master_password} -elasticsearch-prefix=ha_group_a
EOF
  filename = "./xsoar_host_installation_script.sh"
}

output "xsoar_main_ip" {
  value = "${aws_instance.xsoar_app_01.public_ip}, ${aws_instance.xsoar_app_02.public_ip}, ${aws_instance.xsoar_app_03.public_ip}"
}