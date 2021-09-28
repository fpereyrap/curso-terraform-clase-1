#variables
variable "profile" {
  description = "profile name located on the aws config"
  default     = "terraform-demo"
}

variable "aws-key-name" {
  description = "key para la instancia de aws"
  default     = "deployer-key"
}