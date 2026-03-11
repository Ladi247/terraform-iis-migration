variable "vpc_id" {}
/* variable "subnet_id" {} */
/* variable "instance_id" {} */

variable "subnet_ids" {
  type = list(string)
}

variable "internet_gateway" {}