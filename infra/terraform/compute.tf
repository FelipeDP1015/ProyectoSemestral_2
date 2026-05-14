
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public_frontend.id
  vpc_security_group_ids = [aws_security_group.main.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker

    systemctl start docker
    systemctl enable docker

    until docker info > /dev/null 2>&1; do
      echo "Esperando Docker..."
      sleep 3
    done

    docker run -d \
      --name mysql-db \
      -e MYSQL_DATABASE=innovatech_db \
      -e MYSQL_ROOT_PASSWORD=root123 \
      -e MYSQL_ROOT_HOST=% \
      -e MYSQL_USER=innovatech \
      -e MYSQL_PASSWORD=innovatech123 \
      -p 3306:3306 \
      --restart unless-stopped \
      --log-opt max-size=10m \
      --log-opt max-file=3 \
      mysql:8.0 \
      --bind-address=0.0.0.0
  EOF

  tags = {
    Name    = "${var.project_name}-mysql"
    Project = var.project_name
    Role    = "mysql"
  }
}