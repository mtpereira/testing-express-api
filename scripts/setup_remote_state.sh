#!/bin/sh

set -u

source ./env

docker run \
    --rm \
    --env-file env \
    mesosphere/aws-cli:latest \
    s3api create-bucket --bucket terraform-testing-express-api --acl private --region "$AWS_REGION" --create-bucket-configuration LocationConstraint=$AWS_REGION

docker run \
    --rm \
    --env-file env \
    mesosphere/aws-cli:latest \
    s3api put-bucket-versioning --bucket terraform-testing-express-api --versioning-configuration Status=Enabled

docker run \
    --rm \
    --env-file env \
    mesosphere/aws-cli:latest \
    dynamodb create-table --table-name terraform-lock-testing-express-api --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region "$AWS_REGION"
