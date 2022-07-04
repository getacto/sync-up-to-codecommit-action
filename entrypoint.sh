#!/bin/sh

set -ue

aws_region="${INPUT_AWS_REGION}"
[ -z $aws_region ] && aws_region="us-east-1"
export AWS_REGION="$aws_region"
repository_name="${INPUT_REPOSITORY_NAME}"

repository=$(aws codecommit get-repository --repository-name ${repository_name} || aws codecommit create-repository --repository-name ${repository_name})

CodeCommitUrl=$(echo $repository | jq .repositoryMetadata.cloneUrlHttp)

git config --global --add safe.directory /github/workspace
git config --global credential.'https://git-codecommit.*.amazonaws.com'.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git remote add sync ${CodeCommitUrl}
git push sync --mirror
