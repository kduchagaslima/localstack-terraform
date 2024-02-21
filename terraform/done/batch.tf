resource "aws_iam_role_policy" "batch_policy" {
  name = "batch_full_access_policy"
  role = aws_iam_role.batch_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "batch_role" {
  name = "batch_full_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "batch.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_batch_compute_environment" "sample_batch" {
  compute_environment_name = "sample_batch"

#   compute_resources {
#     max_vcpus = 16

#     security_group_ids = [
#       aws_security_group.sample.id
#     ]

#     subnets = [
#       aws_subnet.sample.id
#     ]

#     type = "FARGATE"
#   }

  service_role = aws_iam_role.batch_role.arn
  type         = "UNMANAGED"
  
}

resource "aws_batch_job_queue" "batch_queue" {
  name     = "tf-batch-job-queue"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.sample_batch.arn
  ]
}

resource "aws_batch_job_definition" "test" {
  name = "tf_test_batch_job_definition"
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    command    = ["echo", "hello batch world!!"]
    image      = "busybox"
    jobRoleArn = aws_iam_role.batch_role.arn

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    executionRoleArn = aws_iam_role.batch_role.arn
  })
}