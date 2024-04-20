variable "region-name" {
  type        = string
  description = "region"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "type of instance"
  type        = string
  default     = "t3.medium"
}

variable "ami" {
  description = "type ami"
  type        = string
  default     = "ami-007020fd9c84e18c7"
}

variable "mykey" {
  description = "pem key"
  type        = string
  default     = "newkey3"
}


