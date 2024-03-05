const ssh2 = require('ssh2');
const { GetObjectCommand, S3Client } = require('@aws-sdk/client-s3');
const { resolve } = require('path');
const { rejects } = require('assert');

// Configurações do SFTP
const sftpConfig = {
    host: 'sftp-server',
    port: 22,
    username: 'sftp_user',
    password: 'sftp_passwd',
};

exports.handler = async (event) => {
    // Obter informações do arquivo
    //   const s3 = new AWS.S3();
    const bucket = event.Records[0].s3.bucket.name;
    const key = event.Records[0].s3.object.key;

    const command = new GetObjectCommand({
        Bucket: bucket,
        Key: key,
    });

    const client = new S3Client({
        region: 'us-east-1',
        endpoint: 'http://172.22.0.3:4566'
    });

    try {
        const response = await client.send(command);
        // The Body object also has 'transformToByteArray' and 'transformToWebStream' methods.
        // const str = await response.Body.transformToString();
        // const stream = response.Body;
        let readStream;

        if (response.Body && typeof response.Body.createReadStream === 'function') {
            readStream = response.Body.createReadStream();
        } else if (response.Payload && typeof response.Payload.createReadStream === 'function') {
            readStream = response.Payload.createReadStream();
        } else {
            throw new Error('Unable to create a read stream from the response.');
        }
        // Conectar ao SFTP
        const sftpClient = new ssh2.Client();
        sftpClient.connect(sftpConfig);
        // console.log(f);
        // Criar diretório remoto se não existir
        // const g = sftpClient.sftp('mkdir -p /sftp_user/files_fromS3');
        // console.log(g);
        
        // Upload do arquivo para o SFTP
        const remotePath = `/sftp_user/${key}`;
        // const remoteWriteStream = await sftpClient.createWriteStream(remotePath);
        const writeStream = await sftpClient.sftp('createReadStream', remotePath);

        // const t = sftpClient.sftp('put', str, `/sftp_user/files_fromS3/${key}`);
        // console.log(t);
        //   await sftpClient.sftp('put', s3Object.Body, `/sftp_user/files_fromS3/${key}`);
        // Pipe the S3 stream to the SFTP write stream
        // stream.pipe(remoteWriteStream);
        readStream.pipe(writeStream);

        // Handle stream events
        readStream.on('error', (err) => {
            console.error('Error reading from S3:', err);
            sftpClient.end(); // Close connection on error
        });

        writeStream.on('error', (err) => {
            console.error('Error writing to SFTP:', err);
            sftpClient.end(); // Close connection on error
        });

        await new Promise((resolve, rejects) => {
            writeStream.on('finish', resolve);
            writeStream.on('error', rejects);
        });

        // remoteWriteStream.on('finish', () => {
        //     console.log(`Arquivo ${key} movido para o SFTP com sucesso!`);
        //     sftpClient.end(); // Close connection after successful upload
        // });

        // Desconectar do S3 e SFTP
        sftpClient.end();

        console.log(`Arquivo ${key} movido para o SFTP com sucesso!`);
    } catch (err) {
        console.error(err);
    }
};

