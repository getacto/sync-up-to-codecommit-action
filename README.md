# Sync up to AWS CodeCommit Action

Synchronize from GitHub repository to AWS CodeCommit via GitHub Actions.  
No need to ssh-private-key. Need to AWS IAM Credentials only.

## Example usage

```yaml
name: sync up to codecommit

on:
  push:
    branches:
      - main

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1.0.3
        with:
          aws-access-key-id: ${{ secrets.TEST_AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.TEST_AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Sync up to CodeCommit
        uses: Equiem/sync-up-to-codecommit-action@v1.0.10
        with:
          repository_name: test_repo
```

## Inputs

- `repository_name` **Required** CodeCommit repository name.

## License

[MIT](LICENSE)

