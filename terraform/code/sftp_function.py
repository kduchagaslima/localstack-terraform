import paramiko
import boto3
import botocore
import json
import os
import logging
import base64
logger = logging.getLogger()
logger.setLevel(logging.INFO)

secretmanager = boto3.client('secretsmanager')

# Example settings for a S3 bucket/key
# AWS_S3_BUCKET = "example-bucket"
# AWS_S3_KEY = "upload/existing_object.dat"


# Example settings for a SFTP server
SSH_HOST = "sftp-server"
SSH_USERNAME = "sftp_user"
SSH_PRIVATE_KEY = "/path/to/ssh_key.pem"
SSH_FILENAME = "/home/sftp_user/"

def lambda_handler(event, context):
    secret_name = "sftp_k"
    key = event['Records'][0]['s3']['object']['key']
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    source = {'Bucket': source_bucket, 'Key': key}

    get_secret_value_response = secretmanager.get_secret_value(
        SecretId=secret_name
    )

    try:
        response = print(get_secret_value_response)
        pkey = get_secret_value_response['SecretString']
        logger.info("Secret read from Secrets Manager...")

        # Connect to S3 and start transferring the file
        s3 = boto3.client('s3')
        s3_object = s3.get_object(source)

        # Build the SSH/SFTP connection:
        # pkey = paramiko.RSAKey.from_private_key_file(ssh_private_k)
        transport = paramiko.Transport((SSH_HOST, 2222))
        transport.connect(username=SSH_USERNAME, pkey=pkey)
        sftp = paramiko.SFTP.from_transport(transport)

        # Connections are done, use putfo to transfer the data from S3
        # to the SFTP server
        print("Transferring file from S3 to SFTP...")
        sftp.putfo(s3_object['Body'], SSH_FILENAME)

        # All done, clean up
        sftp.close()
        print("Done")
    except botocore.exceptions.ParamValidationError as error:
        logger.error("Missing required parameters while calling the API.")
        print('Error Message: {}'.format(error))
