resource "aws_launch_template" "iis_template" {

  name_prefix   = "iis-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_id]
  }

  user_data = base64encode(<<EOF
<powershell>
Install-WindowsFeature -name Web-Server -IncludeManagementTools
</powershell>
EOF
)

}

resource "aws_autoscaling_group" "iis_asg" {

  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.iis_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "iis-autoscale-server"
    propagate_at_launch = true
  }

}