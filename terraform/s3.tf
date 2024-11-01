resource "aws_s3_bucket" "sample_s3" {
  bucket = "sample-s3"

  tags = {
    Name        = "sample-s3"
    Environment = "Dev"
    Management = "Terraform"
  }
}

resource "aws_s3_bucket" "source_s3" {
  bucket = "source-files-s3"

  tags = {
    Name        = "source-files-s3"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket" "FirehoseFallbackS3Bucket" {
  bucket = "firehosefallbacks3bucket"

  tags = {
    Name        = "firehosefallbacks3bucket"
    Environment = "Dev"
  }
}