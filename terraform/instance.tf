data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = var.ENV == "prod" ? module.jenkins.public_subnets[0] : module.jenkins.public_subnets[0]

  # the security group
  vpc_security_group_ids = [var.ENV == "prod" ? aws_security_group.allow-ssh-prod.id : aws_security_group.allow-ssh-prod.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      echo "[linux]" | tee -a linux.ini;
	  echo "${aws_instance.example.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.PATH_TO_PRIVATE_KEY}" | tee -a linux.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.PATH_TO_PRIVATE_KEY} -i linux.ini ../../playbooks/createKey.yaml;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.PATH_TO_PRIVATE_KEY} -i linux.ini ../../playbooks/installDocker.yaml;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.PATH_TO_PRIVATE_KEY} -i linux.ini ../../playbooks/installpackages.yaml;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.PATH_TO_PRIVATE_KEY} -i linux.ini ../../playbooks/installJenkins.yaml;
    EOT
  }
}



