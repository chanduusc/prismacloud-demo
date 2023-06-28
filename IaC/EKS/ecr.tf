data "aws_iam_user" "demo_user" {
  user_name = var.demo_user_username
}

module "pc_demo_ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = var.ecr_repo_name

  repository_read_write_access_arns = [data.aws_iam_user.demo_user.arn]

  create_lifecycle_policy         = false
  repository_force_delete         = true
  repository_image_scan_on_push   = false
  repository_image_tag_mutability = "MUTABLE" # required for repeated image pushes
}

resource "aws_iam_policy" "get_auth_token_pol" {
  name        = "GetAuthorizationToken"
  description = "Allow user ability to auth to private ECR repos"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "ecr:GetAuthorizationToken"
        ],
        Effect : "Allow",
        Resource : "*"
      }
    ]
  })
  tags = {
    yor_trace = "ffdf8a6b-7d9f-4b83-a510-4dcd4fb8e3ef"
  }
}

resource "aws_iam_user_policy_attachment" "get_auth_token_attach" {
  user       = var.demo_user_username
  policy_arn = aws_iam_policy.get_auth_token_pol.arn
}
