#EC2 Variables
variable "ami" {
  description = "Ubuntu server 16.04"
  default     = "ami-076e276d85f524150"
}

variable "instance_type"           { default = "t2.medium" }
variable "key_name"                { default = "ec2Key" }
variable "disk_size"               { default = "30" }

variable "bastion_profile_name"    { default = "EC2Bastion" }
variable "bastion_public_ip_allow" { default = "true" }
variable "bastion_tag_name"        { default = "Bastion EC2" }

variable "web_profile_name"        { default = "EC2Web" }
variable "web_public_ip_allow"     { default = "false" }
variable "web_tag_name"            { default = "Web EC2" }

variable "script_file"             { default = "bootstrap.sh" }

variable "subnet_count"            { default = "1" }
variable "private_subnet_count"    { default = "2" }
variable "eip_count"               { default = "1" }
variable "cidr_block"              { default = "10.0.0.0/22" }
variable "public_cidrs"            {
  type    = "list"
  default = ["10.0.0.0/24"]
}
variable "private_cidrs"           {
  type    = "list"
  default = ["10.0.0.1/24", "10.0.0.2/24"]
}

variable "role_name"               { default = "ec2-iam-role" }
variable "test_bucket"             { default = "shankar-test-bucket-2020" }
variable "sg_bastion_sg_id"        { default = "" }

#DB
variable "storage"                 { default = "50" }
variable "storage_type"            { default = "gp2" }
variable "engine"                  { default = "mysql" }
variable "engine_version"          { default = "5.7"}
variable "db_instance_class"       { default = "db.m5.xlarge"}
variable "db_name"                 { default = "myTestDb"}
variable "username"                { default = "shan" }
variable "password"                { default = "shantest11" }
