#!/bin/bash

set -ue

repository_name="${INPUT_REPOSITORY_NAME}"

repository=$(aws codecommit get-repository --repository-name ${repository_name} || aws codecommit create-repository --repository-name ${repository_name})

CodeCommitUrl=$(echo $repository | jq -r .repositoryMetadata.cloneUrlHttp)


git config --global --add safe.directory /github/workspace
git config --global credential.'https://git-codecommit.*.amazonaws.com'.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git remote add sync ${CodeCommitUrl}

if [[ $(git lfs ls-files) ]]; then
  git config --global --add safe.directory /github/workspace/.git
  git lfs migrate export --include="*" --everything
  git lfs uninstall
  git remote remove origin
fi

git push --set-upstream sync $(git rev-parse --abbrev-ref HEAD)
