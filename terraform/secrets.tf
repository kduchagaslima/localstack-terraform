resource "aws_ssm_parameter" "sftp_key" {
  name = "sftp_user_passwd"
  type = "SecureString"
  value = "sftp_passwd"
}