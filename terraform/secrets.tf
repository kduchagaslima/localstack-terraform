data "template_file" "secret" {
  template = "${filebase64("code/iam_json/id_rsa")}"
}

resource "aws_secretsmanager_secret" "sftp" {
  name = "sftp_k"
}
resource "aws_secretsmanager_secret_version" "sftp" {
  secret_id     = aws_secretsmanager_secret.sftp.id
#   secret_string = "${data.template_file.secret.rendered}"
  secret_binary = data.template_file.secret.rendered
}