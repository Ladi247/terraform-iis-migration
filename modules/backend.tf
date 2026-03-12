# modules/backend/main.tf
resource "aws_s3_bucket" "tf_state" {
  bucket = "my-terraform-state-unique" # same as backend.tf
  acl    = "private"
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
