
# Latest Amazon Linux 2023 AMI (no hardcoded AMI ID)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = "${var.project}-key"
  public_key = file(var.public_key_path)
}

# ---------- Web server (public subnet) ----------
resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public["a"].id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.main.key_name

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    echo '<h1>Web Tier - Provisioned by Terraform</h1>' > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOF

  tags = {
    Name = "${var.project}-web"
  }
}

# ---------- App server (private subnet, needs NAT to install packages) ----------
resource "aws_instance" "app" {
  count                  = var.enable_nat ? 1 : 0
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app["a"].id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = aws_key_pair.main.key_name

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y mariadb105
  EOF

  tags = {
    Name = "${var.project}-app"
  }

  depends_on = [aws_nat_gateway.main]
}
