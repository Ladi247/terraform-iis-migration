terraform {
  backend "s3" {
    bucket         = "my-terraform-state-unique" # change to your unique name
    key            = "terraform-iis-migration/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
