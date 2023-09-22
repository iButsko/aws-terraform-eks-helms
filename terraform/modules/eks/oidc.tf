# Create the OIDC Provider in the AWS Account
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

# Create an IAM Role that can be assumed by Actions Runners running
# against repos in the list
resource "aws_iam_role" "devtest_gha_oidc_assume_role" {
  name = "devtest_gha_oidc_assume_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${aws_iam_openid_connect_provider.github_actions.arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:sub" : ["repo:culler127/webservers"]
          },
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Attach a policy to the role allowing whatever you need for Terraform
# To do its thing
resource "aws_iam_role_policy" "devtest_gha_oidc_terraform_permissions" {
  name = "devtest_oidc_terraform_permissions"
  role = aws_iam_role.devtest_gha_oidc_assume_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:*", # EXAMPLE ONLY MAKE THESE MINIMUM PERMISSION SET
          "eks:*",
          "iam:*",
          "ecr:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Needed for adding to your Github Action
output "role_arn" {
  value = aws_iam_role.devtest_gha_oidc_assume_role.arn
}