provider "aws" {
    region = "ap-south-1"
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_s3_bucket" "first-bucket" {
    bucket = "s3-backup-using-python"

    tags = {
        Name = "my-project-bucket"
    }
}

resource "aws_s3_bucket_versioning" "versioning-rule" {
    bucket = aws_s3_bucket.first-bucket.id
    versioning_configuration {
        status = "Enabled"  
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup-rule" {
    bucket = aws_s3_bucket.first-bucket.id

    rule {
        id = "expire_old_versions"
        status = "Enabled"

        noncurrent_version_expiration {
            noncurrent_days = 30 #Delete old version after 30 days
        }
    }
}