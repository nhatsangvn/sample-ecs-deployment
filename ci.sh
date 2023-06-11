#!/bin/bash
IMAGE_AWS_REGION=ap-southeast-1
IMAGE_TAG=$(git log -n 1 --abbrev=8 --pretty=format:'%cd-%h' --date=format:'%Y%m%d')
IMAGE_REPO=$(terraform -chdir=./deployment/base output -raw image-repo)
IMAGE_FULL=${IMAGE_REPO}:${IMAGE_TAG}
IMAGE_PROJECT=$(echo ${IMAGE_REPO} | cut -d '/' -f1)
IMAGE_NAME=$(echo ${IMAGE_REPO} | cut -d '/' -f2)

echo "IMAGE_TAG: ${IMAGE_TAG}
IMAGE_REPO: ${IMAGE_REPO}
IMAGE_FULL: ${IMAGE_FULL}
IMAGE_PROJECT: ${IMAGE_PROJECT}
IMAGE_NAME: ${IMAGE_NAME}"

echo "++ Logging in to registry"
aws ecr get-login-password --region ${IMAGE_AWS_REGION} | docker login --username AWS --password-stdin ${IMAGE_PROJECT}
echo "++ Building image: ${IMAGE_REPO}:${IMAGE_TAG}"
docker build -t rg-ops-image .

echo "++ Pushing image"
docker tag rg-ops-image:latest ${IMAGE_REPO}:${IMAGE_TAG}
docker tag rg-ops-image:latest ${IMAGE_REPO}:latest
docker push ${IMAGE_REPO}:${IMAGE_TAG}
docker push ${IMAGE_REPO}:latest
