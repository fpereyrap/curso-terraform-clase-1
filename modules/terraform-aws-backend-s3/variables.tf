variable "bucket_name" {
  description = "Bucket name for the S3 bucket to store state files"
  default     = ""
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for locking state files"
  default     = ""
}

variable "state_name" {
   description = "name to be used when creating the bucket and its dynamo table"
 }

variable "environment"{
  description = "development environment"
}