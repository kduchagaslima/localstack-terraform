data "archive_file" "python_sftp_package" {  
  type = "zip"  
  # source_file = "${path.module}/code/sftp_gemini.py" 
#   source_dir = "${path.module}/code/build/python/lib/python3.7/site-packages" 
  source_dir = "${path.module}/../../ssh-to-server-via-lambda" 
  output_path = "${path.module}/code/pkg/gemini_package.zip"
}

resource "aws_lambda_function" "mover_arquivo" {
  function_name = "mover-arquivo-s3-sftp"
  filename = "${path.module}/code/pkg/gemini_package.zip"
  source_code_hash = data.archive_file.python_sftp_package.output_base64sha256 
  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      BUCKET = aws_s3_bucket.source_s3.bucket
    }
  }
}

resource "aws_lambda_permission" "allow_s3_sftp" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mover_arquivo.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_s3.arn
}

resource "aws_s3_bucket_notification" "bucket_notification_sftp" {
  bucket = aws_s3_bucket.source_s3.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.mover_arquivo.arn
    events              = ["s3:ObjectCreated:*","s3:*:*"]
    filter_prefix       = "uploads/"
    filter_suffix       = ".txt"
  }
}
output "lambda_arn" {
  value = aws_lambda_function.mover_arquivo.arn
}
