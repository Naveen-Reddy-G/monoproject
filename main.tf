resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-0720cb7af233b0529"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "c7i-flex.large"
    key_name = "Naveen"
    tags = {
        Name = "DevOps"
    }
    
}
   


  resource "aws_elb" "web_server_lb"{
     name = "web-server-lb"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-0dc0cda316be63cd5", "subnet-0532ee0b11ec75d3d"]
     listener {
      instance_port     = 8000
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }
    tags = {
      Name = "terraform-elb"
    }
  }
resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    load_balancers       = [aws_elb.web_server_lb.name]
    availability_zones    = ["ap-southeast-2a", "ap-southeast-2b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
    
    
  }

