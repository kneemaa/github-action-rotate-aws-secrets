# IAM Permissions for Self Rotation

Terraform example of an IAM Group that grants its users permission to manage only their keys. Add your users to the `manage_own_tokens` group_membership resource to give them this permission. 

[Policy provided by aws](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_iam_credentials_console.html)
