#!/bin/sh

for counter in $(seq 1 100); do awslocal sqs send-message --queue-url http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/sample-sqs --message-body "Hello-World $counter";echo $counter;done