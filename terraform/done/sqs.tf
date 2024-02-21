resource "aws_sqs_queue" "sample_queue" {
  name                      = "sample-sqs"
#   delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = "arn:aws:sqs:us-east-1:000000000000:sample-sqs-deadletter-queue"
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "dev"
    Management = "Terraform"
  }
}

resource "aws_sqs_queue" "sample_queue_deadletter" {
  name = "sample-sqs-deadletter-queue"
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = aws_sqs_queue.sample_queue.arn
  })
}