provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://homestack.littlecharlie.duckdns.org:4566"
    apigatewayv2   = "http://homestack.littlecharlie.duckdns.org:4566"
    cloudformation = "http://homestack.littlecharlie.duckdns.org:4566"
    cloudwatch     = "http://homestack.littlecharlie.duckdns.org:4566"
    dynamodb       = "http://homestack.littlecharlie.duckdns.org:4566"
    ec2            = "http://homestack.littlecharlie.duckdns.org:4566"
    es             = "http://homestack.littlecharlie.duckdns.org:4566"
    elasticache    = "http://homestack.littlecharlie.duckdns.org:4566"
    firehose       = "http://homestack.littlecharlie.duckdns.org:4566"
    iam            = "http://homestack.littlecharlie.duckdns.org:4566"
    kinesis        = "http://homestack.littlecharlie.duckdns.org:4566"
    lambda         = "http://homestack.littlecharlie.duckdns.org:4566"
    rds            = "http://homestack.littlecharlie.duckdns.org:4566"
    redshift       = "http://homestack.littlecharlie.duckdns.org:4566"
    route53        = "http://homestack.littlecharlie.duckdns.org:4566"
    s3             = "http://s3.homestack.littlecharlie.duckdns.org:4566"
    # s3             = "http://s3.homestack.littlecharlie.duckdns.org.localstack.cloud:4566"
    secretsmanager = "http://homestack.littlecharlie.duckdns.org:4566"
    ses            = "http://homestack.littlecharlie.duckdns.org:4566"
    sns            = "http://homestack.littlecharlie.duckdns.org:4566"
    sqs            = "http://homestack.littlecharlie.duckdns.org:4566"
    ssm            = "http://homestack.littlecharlie.duckdns.org:4566"
    stepfunctions  = "http://homestack.littlecharlie.duckdns.org:4566"
    sts            = "http://homestack.littlecharlie.duckdns.org:4566"
  }
}