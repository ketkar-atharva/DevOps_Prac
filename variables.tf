variable "project" {
  type    = string
  default = "threetier"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# key = AZ suffix (a, b), value = CIDR. for_each loops over these maps.
variable "public_subnets" {
  type = map(string)
  default = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
  }
}

variable "app_subnets" {
  type = map(string)
  default = {
    a = "10.0.11.0/24"
    b = "10.0.12.0/24"
  }
}

variable "db_subnets" {
  type = map(string)
  default = {
    a = "10.0.21.0/24"
    b = "10.0.22.0/24"
  }
}

variable "enable_nat" {
  description = "Create NAT Gateway and app server (costs money)"
  type        = bool
  default     = false
}

variable "my_ip" {
  description = "Your public IP in CIDR form, e.g. 203.0.113.25/32"
  type        = string
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/threetier-key.pub"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}