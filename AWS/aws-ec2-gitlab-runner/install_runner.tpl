#!/bin/bash
# Install necessary dependencies
# set -x enables a mode of the shell where all executed commands are printed to the terminal
set -x
echo "Hello from EC2 user data script"

yum update -y
yum install -y curl git

# Install GitLab Runner
curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
chmod +x /usr/local/bin/gitlab-runner


useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

# Start the GitLab Runner service
/usr/local/bin/gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
/usr/local/bin/gitlab-runner start

# Register the GitLab Runner
/usr/local/bin/gitlab-runner register --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "${gitlab_runner_registration_token}" \
  --executor "shell" \
  --description "AWS GitLab Runner" \
  --tag-list "aws,linux" \
  --run-untagged="true" \
  --locked="false"

systemctl status -l gitlab-runner.service
