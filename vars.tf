variable "AWS_REGION" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "KEY_NAME" {
  default = "wilder-key"
}

variable "PATH_TO_PRIVATE_KEY" {
  description = "Key pair name with extention"
  default     = "wilder-key.pem"
}

variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnets"
  type        = list(string)
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnets"
  type        = list(string)
  default     = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0ac80df6eff0e70b5" //Ubuntu Server 18.04
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

