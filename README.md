# webapp
Teraform code for a sample web application 

This tf code creates VPC, Subnets, 2 EC2 Instances (1 in public and 2nd one in private subnet), ELB, RDS Instance, Security groups wherever required, IAM Profile to attach to each EC2 Instance.

Use the required commands from below to create/destroy resources on aws

```terraform init
terraform plan 
terraform apply 
terraform destroy```
