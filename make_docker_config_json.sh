#!/bin/sh

ECR_REGION="$1"


aws --region ${ECR_REGION} ecr get-login --no-include-email > /tmp/ecr.creds

DOCKER_CREDS_FILE_NAME=config.json
ECR_USERNAME=AWS
ECR_PASSWORD=$(cat /tmp/ecr.creds | tr -d "\n" | awk '{for(i = 1; i < NF ; i++) {if($i == "-p") {print $(i+1)}}}')
ECR_REGISTRY=$(cat /tmp/ecr.creds | awk '{print $NF}' | sed 's/https:\/\///')
BASE64_AUTH=$(echo "${ECR_USERNAME}:${ECR_PASSWORD}" | base64 | tr -d '\n')

cat <<EOF > /tmp/ecr_creds
{
  "auths": {
    "${ECR_REGISTRY}": {
      "auth": "${BASE64_AUTH}"
    }
  }
}
EOF

# /docker-secrets/ must contain a folder for each mounted secret where the
# file inside is named .dockercfg. This is the default for any Kubernetes
# secret of type "kubernetes.io/dockercfg".

# All .dockercfg files must be "Kubernetes" style, i.e. they do not have a
# "auths" container object, they just have the single repository auth config.
cp /tmp/ecr_creds /tmp/combined_creds
shopt -s nullglob  # Ensure that if no secrets are mounted that we do nothing
for secret_dir in /docker-secrets/*/; do
  jq -Ms '.[0].auths * .[1] | {auths: .}' /tmp/combined_creds $secret_dir/.dockercfg > /tmp/combined_creds_new
  mv /tmp/combined_creds_new /tmp/combined_creds
done
cp /tmp/combined_creds /docker-creds/${DOCKER_CREDS_FILE_NAME}
