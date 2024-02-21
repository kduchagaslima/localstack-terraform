
data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/code/lambda_function.py" 
  output_path = "${path.module}/code/pkg/package.zip"
}

resource "aws_lambda_function" "move_files_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/code/pkg/package.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  function_name = "move_files_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime = "python3.11"
  tags = {
    Environment = "dev"
    Management = "Terraform"
  }

  environment {
    variables = {
      destination_bucket = "sample-s3"
    }
  }
}

resource "aws_lambda_permission" "allow_source_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.move_files_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_s3.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_s3.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.move_files_lambda.arn
    events              = ["s3:ObjectCreated:*","s3:*:*"]
    filter_prefix       = "uploads/"
    filter_suffix       = ".txt"
  }
}