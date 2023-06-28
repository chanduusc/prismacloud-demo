resource "aws_cloudwatch_log_group" "apache_bad" {
  name              = "apache[${count.index + 1}]"
  count             = "2"
  retention_in_days = 15
  tags = {
    yor_trace = "6bf88cd7-1ccb-4c16-8409-b44b570d3d29"
  }
}
