resource "aws_iam_group_membership" "manage_own_tokens" {
  name  = aws_iam_group.manage_own_tokens.name
  group = aws_iam_group.manage_own_tokens.name
  users = [
    # aws_iam_user.< iam user >.name,
  ]
}

resource "aws_iam_group" "manage_own_tokens" {
  name = "manage_own_tokens"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "manage-own-keys" {
  group      = aws_iam_group.manage_own_tokens.name
  policy_arn = aws_iam_policy.allow-self-token-rotation.arn
}

resource "aws_iam_policy" "allow-self-token-rotation" {
  name = "allow-self-token-rotation"
  path = "/"

  policy = data.aws_iam_policy_document.allow-self-token-rotation.json
}

data "aws_iam_policy_document" "allow-self-token-rotation" {
  # Policy provided by aws
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_iam_credentials_console.html
  statement {
    actions = [
      "iam:ListUsers",
      "iam:GetAccountPasswordPolicy"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "iam:*AccessKey*",
      "iam:ChangePassword",
      "iam:GetUser",
      "iam:*ServiceSpecificCredential*",
      "iam:*SigningCertificate*"
    ]

    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }
}
