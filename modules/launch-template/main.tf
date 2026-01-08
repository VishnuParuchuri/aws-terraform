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
    set -eux

    exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

    echo "==== User data started ===="

    yum update -y
    amazon-linux-extras enable nginx1
    yum install -y nginx

    systemctl start nginx
    systemctl enable nginx

    echo "<h1>Secure AWS Terraform – NGINX Working${var.environment == "prod" ? " In PROD" : ""}</h1>" > /usr/share/nginx/html/index.html

    echo "==== User data completed successfully ===="
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}
