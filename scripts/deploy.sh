#!/bin/sh

set -eu

source ./env

docker run \
    --rm \
    --env-file env \
    --entrypoint /bin/sh \
    --workdir /terraform \
    --volume $(pwd)/terraform:/terraform \
    hashicorp/terraform:"$TERRAFORM_VERSION" \
    -c "terraform init -reconfigure -backend-config=\"region=$AWS_REGION\" && terraform plan -out plan -var 'app_version=latest' && terraform apply -auto-approve plan"
