#!/bin/sh

ECR_REGION="$1"


aws --region ${ECR_REGION} ecr get-login --no-include-email > /tmp/ecr.creds

DOCKER_CREDS_FILE_NAME=config.json
ECR_USERNAME=AWS
ECR_PASSWORD=$(cat /tmp/ecr.creds | tr -d "\n" | awk '{for(i = 1; i < NF ; i++) {if($i == "-p") {print $(i+1)}}}')
ECR_REGISTRY=$(cat /tmp/ecr.creds | awk '{print $NF}' | sed 's/https:\/\///')
BASE64_AUTH=$(echo "${ECR_USERNAME}:${ECR_PASSWORD}" | base64 | tr -d '\n')

cat <<EOF > /docker-creds/${DOCKER_CREDS_FILE_NAME}
{
  "auths": {
    "${ECR_REGISTRY}": {
      "auth": "${BASE64_AUTH}"
    }
  }
}
EOF
