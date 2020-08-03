

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
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

