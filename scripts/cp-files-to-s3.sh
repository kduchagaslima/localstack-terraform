#!/bin/sh

awslocal s3 cp ../terraform/code/iam_json/assume-role.json s3://source-files-s3/code/iam_json/
awslocal s3 cp ../terraform/code/iam_json/role.json s3://source-files-s3/code/iam_json/
awslocal s3 cp ../terraform/code/pkg/function.zip s3://source-files-s3/packages/
awslocal s3 cp ../terraform/code/pkg/package.zip s3://source-files-s3/packages/