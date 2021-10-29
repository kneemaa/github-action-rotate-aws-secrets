![Validate Master](https://github.com/kneemaa/github-action-rotate-aws-secrets/actions/workflows/validate_master.yml/badge.svg)
[![CodeQL](https://github.com/kneemaa/github-action-rotate-aws-secrets/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/kneemaa/github-action-rotate-aws-secrets/actions/workflows/codeql-analysis.yml)

# Rotate AWS Access token stored in Github Repository secrets

## Environment Variables

| Variable | Required | Description | Default |
|--------- | -------- | ----------- | ------- |
| AWS_ACCESS_KEY_ID | True | Access Key ID to authenticate with AWS. You can use `${{secrets.ACCESS_KEY_ID}}` | N/A |
| AWS_SECRET_ACCESS_KEY | True | Secret Access Key ID to authenticate with AWS. You can use `${{secrets.SECRET_ACCESS_KEY_ID}}` | N/A |
| AWS_SESSION_TOKEN | False | Session Token for the current AWS session. Only required if you assume a role first. | N/A |
| IAM_USERNAME | False | Name of IAM user being rotated, if not set the username which is used in the AWS credentials is used | N/A |
| PERSONAL_ACCESS_TOKEN | True | Github Token with **Repo Admin** access of the target repo. As of 4/16/2020 `${{github.token}}` does not have permission to query the Secrets API. The existing env var GITHUB_TOKEN which is added automatically to all runs does not have the access secrets. | N/A |
| OWNER_REPOSITORY | True | The owner and repository name. For example, octocat/Hello-World. If being ran in the repo being updated, you can use `${{github.repository}}`. Multiple repositories can be specified by a comma-separated list (e.g. `OWNER_REPOSITORY: ${{ github.repository }},MyGitHubOrgOrUser/MyGitHubRepo`). | N/A |
| GITHUB_ACCESS_KEY_NAME | False |  Name of the secret for the Access Key ID. Setting this overrides the default. | `access_key_id` |
| GITHUB_SECRET_KEY_NAME | False | Name of the secret for the Secret Access Key ID. Setting this overrides the default. | `secret_key_id` |
| GITHUB_ENVIRONMENT | False | Name of the [Github environment](https://docs.github.com/en/actions/reference/environments) where the secrets are stored. | N/A |

# Example
## Rotation every monday at 13:27 UTC
```
on:
  schedule:
    - cron: '27 13 * * 1' 

jobs:
  rotate:
    name: rotate iam user keys
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.0.0

      - name: rotate aws keys
        uses: kneemaa/github-action-rotate-aws-secrets@v1.2.0
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.access_key_name }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.secret_key_name }}
          IAM_USERNAME: 'iam-user-name'
          PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          OWNER_REPOSITORY: ${{ github.repository }}
```

## Rotation every monday at 13:27 UTC for the `dev` Github environment secret

```
on:
  schedule:
    - cron: '27 13 * * 1' 

jobs:
  rotate:
    name: rotate iam user keys
    runs-on: ubuntu-latest
    environment: dev
    steps:
      - uses: actions/checkout@v2.0.0

      - name: rotate aws keys
        uses: kneemaa/github-action-rotate-aws-secrets@v1.2.0
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.access_key_name }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.secret_key_name }}
          IAM_USERNAME: 'iam-user-name'
          PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          OWNER_REPOSITORY: ${{ github.repository }}
          GITHUB_ENVIRONMENT: dev
```

Note that environment names must be set twice:

 * at the job level for Github workflow to know where to fetch the secrets
 * in the action's environment variable so that the action knows where to store the secret back


## Adding Slack notification on failure only
```
on:
  schedule:
    - cron: '27 13 * * 1'

jobs:
  rotate:
    name: rotate iam user keys
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.0.0

      - name: rotate aws keys
        uses: kneemaa/github-action-rotate-aws-secrets@v1.1.0
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.access_key_name }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.secret_key_name }}
          IAM_USERNAME: 'iam-user-name'
          PERSONAL_ACCESS_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          OWNER_REPOSITORY: ${{ github.repository }}

      - name: Send Slack Status
        if: failure()
        uses: 8398a7/action-slack@v2.7.0
        with:
          status: ${{job.status}}
          author_name: kneemaa-aws-rotation-action
          username: kneemaa-rotation-bot
          text: Rotating the token had a status of ${{ job.status }}
          channel: alerts-test
        env:
          SLACK_WEBHOOK_URL: https://hooks.slack.com/services/.../...
```
## License
The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
