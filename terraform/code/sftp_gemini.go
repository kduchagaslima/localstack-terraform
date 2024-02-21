package main

import (
	"fmt"
	"io"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

func main() {
	// Criar uma sessão AWS
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-east-1"), // Substitua por sua região
	})
	if err != nil {
		fmt.Println("Erro ao criar sessão AWS:", err)
		return
	}

	// Criar um cliente S3
	s3Client := s3.New(sess)

	// Criar um cliente SFTP
	sftpClient, err := sftp.NewClient(ssh.Dial("tcp", "sftp-server:22", &ssh.ClientConfig{
		User:     "sftp_user",
		Password: "sftp_passwd",
	}))
	if err != nil {
		fmt.Println("Erro ao criar cliente SFTP:", err)
		return
	}

	// Obter o objeto S3
	object, err := s3Client.GetObject(&s3.GetObjectInput{
		Bucket: aws.String("source-files-s3"),
		Key:    aws.String("uploads/files_txt/"),
		// Key:    aws.String("uploads/*"),
	})
	if err != nil {
		fmt.Println("Erro ao obter objeto S3:", err)
		return
	}

	// Criar um arquivo local para o conteúdo do objeto S3
	file, err := os.Create("content.txt")
	if err != nil {
		fmt.Println("Erro ao criar arquivo local:", err)
		return
	}

	// Copiar o conteúdo do objeto S3 para o arquivo local
	_, err = io.Copy(file, object.Body)
	if err != nil {
		fmt.Println("Erro ao copiar conteúdo do objeto S3:", err)
		return
	}

	// Fechar o arquivo local
	file.Close()

	// Carregar o arquivo local para o servidor SFTP
	err = sftpClient.PutFile("content.txt")
	if err != nil {
		fmt.Println("Erro ao carregar arquivo para o servidor SFTP:", err)
		return
	}

	// Remover o arquivo local
	os.Remove("file-name")

	// Fechar o cliente SFTP
	sftpClient.Close()

	fmt.Println("Arquivo movido com sucesso!")
}
