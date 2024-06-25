# Manage terraform state in S3 and dynamo
terraform {
  backend "s3" {
    bucket         = "go-app-bucket"
    key            = "terraform.tfstate"
    dynamodb_table = "go-app-table"
  }    
}
