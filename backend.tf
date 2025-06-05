terraform {
  backend "s3" {
    bucket         = "terraform-test-bucket-14443" # Backend S3 Bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1" # Region of Backend S3 Bucket
    encrypt        = true
  }
}