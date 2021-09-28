#main

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.aws-key-name
  public_key = tls_private_key.example.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = "" #completar con su subnet
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "HelloWorld"
  }
}

module terraform-backend {
    source = "../modules/terraform-aws-backend-s3"
    state_name = "terraform-class"
    environment = local.environment
    bucket_name = "my-terraform-backend-${local.account_id}-${local.environment}"
    dynamodb_table_name = "my-terraform-backend-${local.account_id}-${local.environment}"
}