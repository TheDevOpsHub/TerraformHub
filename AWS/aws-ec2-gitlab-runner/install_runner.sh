#!/bin/bash
# Install necessary dependencies
yum update -y
yum install -y curl

# Install GitLab Runner
curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
chmod +x /usr/local/bin/gitlab-runner

# Register the GitLab Runner
gitlab-runner register --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "${gitlab_runner_registration_token}" \
  --executor "shell" \
  --description "AWS GitLab Runner" \
  --tag-list "aws,linux" \
  --run-untagged="true" \
  --locked="false"

# Start the GitLab Runner service
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
gitlab-runner start
