variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "elb_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "vpc_id"{
    description = "vpc aws"
    default = "vpc-10103176"
}
