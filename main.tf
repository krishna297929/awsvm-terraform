
/*
 provider "aws" {
  region     = "us-east-2"
  #access_key = ""
  #secret_key = ""
} 


resource "aws_vpc" "awsvpc" {
  cidr_block = "10.0.0.0/16"

  tags={
      name = "prod"
  }
}

resource "aws_subnet" "prod" {
  vpc_id     = aws_vpc.awsvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}


resource "aws_instance" "awsterra" {
  ami           = "ami-0ac80df6eff0e70b5"
  instance_type = "t3.micro"

  tags = {
    Name = "aws-terraform-prod"
  }
}

 
*************************** */

# provider and region declaration

 provider "aws" {
  region     = "us-east-1"
  #access_key = ""
  #secret_key = ""
} 

resource "aws_instance" "example" {
  ami           = "ami-0ac80df6eff0e70b5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

# user data to input Running commands on your Linux instance at launch

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
    Name = "aws-terraform-prod"
  }
}


resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  
    ingress {
      from_port   = var.server_port
      to_port     = var.server_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_launch_configuration" "example" {
  image_id        = "ami-0ac80df6eff0e70b5"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {
  all_availability_zones= true
}

resource "aws_subnet" "primary" {
  availability_zone = data.aws_availability_zones.all.names[0]
  vpc_id = var.vpc_id
  cidr_block = "172.31.0.0/16"

  # ...
}

/* resource "aws_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.all.names[1]
  vpc_id = var.vpc_id
  cidr_block = "172.31.0.0/16"

  # ...
} */


resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 10
  load_balancers    = [aws_elb.example.name]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}


resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups    = [aws_security_group.elb.id]
  #availability_zones = data.aws_availability_zones.all.names
  availability_zones = ["us-east-1f"]

        health_check {
          target              = "HTTP:${var.server_port}/"
          interval            = 30
          timeout             = 3
          healthy_threshold   = 2
          unhealthy_threshold = 2
        }

        # This adds a listener for incoming HTTP requests.
        listener {
          
          lb_port           = var.elb_port
          lb_protocol       = "http"
          instance_port     = var.server_port
          instance_protocol = "http"
        }
}


resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

