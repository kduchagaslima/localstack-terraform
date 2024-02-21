resource "aws_lambda_function" "sample_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/code/pkg/function.zip" 
  function_name = "sample_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime = "nodejs18.x"
  tags = {
    Environment = "dev"
    Management = "Terraform"
  }

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.sample_queue.arn
  function_name    = aws_lambda_function.sample_lambda.arn
  batch_size = 5
}