variable "tag_name"       {}
variable "ec2_ami"        {}
variable "instance_type"  {}
variable "volume_size"    {}
variable "key_name"       {}
variable "key_path"       {}

# web1 = web server for activo.com
resource "aws_instance" "web1" {
  ami = "${var.ec2_ami}"
  instance_type = "${var.instance_type}"
  ebs_optimized = false
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.default-web.name}"]

  root_block_device = {
    volume_size = "${var.volume_size}"
    volume_type = "gp2"
    iops = 100
//    delete_on_termination = false
  }

  # We run a remote provisioner on the instance after creating it.
  user_data = "${file("${path.module}/userdata.sh")}"

  #Instance tags
  tags {
    Name = "${var.tag_name}"
  }
}

# SSH key
resource "aws_key_pair" "sshkey" {
  key_name = "${var.key_name}"
  public_key = "${file("${var.key_path}")}"
}

# Default security group: Allow SSH, HTTP, HTTPS
resource "aws_security_group" "default-web" {
  name        = "${var.tag_name}"
  description = "SSH+HTTP+HTTPS"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.tag_name}-sg"
  }
}