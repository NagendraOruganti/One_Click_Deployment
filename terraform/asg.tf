data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  user_data = templatefile("${path.module}/user_data.tpl", {
    app_s3_bucket = var.app_s3_bucket
    app_s3_key    = var.app_s3_key
  })
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.ec2_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-ec2"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.project_name}-asg-1"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_capacity
  min_size            = var.min_capacity
  vpc_zone_identifier = [for s in aws_subnet.private : s.id]

  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb_target_group.app_tg]
}

