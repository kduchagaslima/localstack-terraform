#!/bin/bash

apt update && apt upgrade -y
apt install -y ansible

cd /opt/aplicacoes/ansible

ansible-playbook -i inventory sftp.yaml

echo "SFTP server is already to use"

sleep 84000