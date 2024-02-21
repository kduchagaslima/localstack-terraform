package main

import (
	"io"
	"log"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

func getObjectFromS3(svc *s3.S3, bucket, key string) io.Reader {
	var input = &s3.GetObjectInput{
		Bucket: aws.String("source-files-s3"),
		Key:    aws.String("uploads/files_txt/"),
	}

	o, err := svc.GetObject(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case s3.ErrCodeNoSuchKey:
				log.Fatal(s3.ErrCodeNoSuchKey, aerr.Error())
			default:
				log.Fatal(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			log.Fatal(err.Error())
		}
	}

	// Load S3 file into memory, assuming small files
	return o.Body
}

func uploadObjectToDestination(sshConfig, destinationPath string, srcFile io.Reader) {
	config := &ssh.ClientConfig{
		User: "sftp_user",
		Auth: []ssh.AuthMethod{
			ssh.Password("sftp_passwd"),
		},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	}
	// Connect to destination host via SSH
	conn, err := ssh.Dial("tcp", "sftp-server:2222", config)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	// create new SFTP client
	client, err := sftp.NewClient(conn)
	if err != nil {
		log.Fatal(err)
	}
	defer client.Close()

	log.Printf("Opening file on destination server under path %s", destinationPath)
	// create destination file
	dstFile, err := client.OpenFile(destinationPath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC)
	if err != nil {
		log.Fatal(err)
	}
	defer dstFile.Close()

	log.Printf("Copying file to %s", destinationPath)
	// copy source file to destination file
	bytes, err := io.Copy(dstFile, srcFile)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("%s - Total %d bytes copied\n", dstFile.Name(), bytes)
}

func main() {
}
