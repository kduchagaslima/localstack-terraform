import tempfile
import boto3
import paramiko

def lambda_handler(event, context):
    # Conexão S3
    s3 = boto3.client('s3')
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Conexão SFTP
    host = 'sftp-server'
    port = 22
    username = 'sftp_user'
    password = 'sftp_passwd'
    transport = paramiko.Transport((host, port))
    transport.connect(username=username, password=password)
    sftp = paramiko.SFTPClient.from_transport(transport)

    # Download do arquivo S3
    with tempfile.NamedTemporaryFile() as temp_file:
        s3.download_file(bucket, key, temp_file.name)

        # Upload do arquivo para SFTP
        sftp.put(temp_file.name, f'/home/sftp_user/files_fromS3/{key}')

    # Desconexão SFTP
    sftp.close()
    transport.close()

