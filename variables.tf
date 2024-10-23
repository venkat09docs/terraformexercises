variable "aws_region_name" {
    type = string
    default = "ap-southeast-1"  
}

variable "instance_type" {
    default = "t2.micro"
}

variable "Key_pair_name" {
  default = "server_key"
}

variable "webserver_tags" {
  type = map
  default = {
    Name = "Web Server",
    Env  = "Dev"
  }
}

variable "webserver_sg_ports" {
  type = list(number)
  default = [ 22, 80 ]
}

variable "sg_cidr" {
  default = ["0.0.0.0/0"]
}

variable "server_count" {
  default = 2
}
