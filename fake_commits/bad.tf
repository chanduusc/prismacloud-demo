resource "aws_cloudwatch_log_group" "apache_bad" {
  name              = "apache[${count.index + 1}]"
  count             = "2"
  retention_in_days = 15
}
