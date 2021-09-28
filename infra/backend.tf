# terraform {
#   backend "s3" {
#     region         = "us-east-1"
#     bucket         = "my-terraform-backend-accountid-dev"
#     key            = "terraform-demo.tfstate"
#     dynamodb_table = "my-terraform-backend-acountid-dev"
#     profile        = "terraform-demo"
#     encrypt        = true
#   }
# }