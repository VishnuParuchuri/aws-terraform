resource "aws_launch_template" "this" {
  name_prefix   = "secure-aws-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "==== User data started ===="

yum clean all
yum update -y

# Install nginx directly (amazon-linux-extras removed in new AL2)
yum install -y nginx

systemctl enable nginx
systemctl start nginx

echo "<h1>Secure AWS Terraform – NGINX Working ${var.environment == "prod" ? "In PROD" : ""}</h1>" > /usr/share/nginx/html/index.html

echo "==== User data completed successfully ===="
EOF
)

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}
