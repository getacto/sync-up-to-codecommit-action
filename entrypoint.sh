#!/bin/bash

set -ue

repository_name="${INPUT_REPOSITORY_NAME}"

repository=$(aws codecommit get-repository --repository-name ${repository_name} || aws codecommit create-repository --repository-name ${repository_name})

CodeCommitUrl=$(echo $repository | jq -r .repositoryMetadata.cloneUrlHttp)

remote="sync"

mkdir /github/acto-analytics

cp -R /github/workspace/analytics-python /github/acto-analytics

git config --global --add safe.directory /github/acto-analytics
git config --global credential.'https://git-codecommit.*.amazonaws.com'.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git remote add ${remote} ${CodeCommitUrl}

cd /github/workspace/analytics-python

git add .

git commit -m "sync analytics"

git push --force --set-upstream ${remote} $(git rev-parse --abbrev-ref HEAD)
