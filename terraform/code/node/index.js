const AWS = require('aws-sdk');
const S3 = new AWS.S3();
const SFTP = require('ssh2-sftp-client');
const sftp_user_passwd = process.env['sftp_user_passwd'];


exports.handler = async (event) => {
    const bucketName = event.Records[0].s3.bucket.name;
    const fileName = event.Records[0].s3.object.key;
    let remoteDir = '/sftp_user/uploads/files_txt/';
    // const sts = new AWS.STS();
    
    // Conectar ao S3    
    const s3Object = await S3.getObject ({
        Bucket: bucketName,
        Key: fileName,
    }).promise();

    // Conectar ao servidor SFTP
    const sftpClient = new SFTP();
    await sftpClient.connect({
        host: 'sftp-server',
        port: 22,
        username: 'sftp_user',
        password: sftp_user_passwd,
    });

    console.log (fileName);
    await sftpClient.mkdir(remoteDir, true);
    await sftpClient.put(s3Object.Body, `/sftp_user/${fileName}`);
    await sftpClient.end();

    console.log(`Arquivo ${fileName} movido para o SFTP com sucesso!`);
};