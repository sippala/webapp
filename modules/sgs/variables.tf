variable "name" {
  default = ""
}

variable "description" {
  default = ""
}

variable "vpc_id" { }

variable "ingress" { type = "map" }
variable "egress"  { type = "map" }
