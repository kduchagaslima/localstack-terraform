#!/bin/sh

mkdir tmp
for counter in $(seq 1 2); do echo "Hello World $counter" > tmp/content_$counter.txt; done
awslocal s3 sync tmp/ s3://source-files-s3/uploads/files_txt/
rm -rf tmp