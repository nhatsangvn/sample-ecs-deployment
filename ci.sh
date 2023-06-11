#995465982134.dkr.ecr.ap-southeast-1.amazonaws.com/rg-ops-image
IMAGE_TAG=$(git log -n 1 --abbrev=8 --pretty=format:'%cd-%h' --date=format:'%Y%m%d')
IMAGE_REPO=$(terraform -chdir=./deployment/services output -raw image-repo)
IMAGE_FULL=${IMAGE_REPO}:${IMAGE_TAG}
IMAGE_PROJECT=$(echo ${IMAGE_REPO} | cut -d '/' -f1)
IMAGE_NAME=$(echo ${IMAGE_REPO} | cut -d '/' -f2)

echo "IMAGE_TAG: ${IMAGE_TAG}
IMAGE_REPO: ${IMAGE_REPO}
IMAGE_FULL: ${IMAGE_FULL}
IMAGE_PROJECT: ${IMAGE_PROJECT}
IMAGE_NAME: ${IMAGE_NAME}"

aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 995465982134.dkr.ecr.ap-southeast-1.amazonaws.com
docker build -t rg-ops-image .

docker tag rg-ops-image:latest 995465982134.dkr.ecr.ap-southeast-1.amazonaws.com/rg-ops-image:${IMAGE_TAG}
docker tag rg-ops-image:latest 995465982134.dkr.ecr.ap-southeast-1.amazonaws.com/rg-ops-image:latest

docker push 995465982134.dkr.ecr.ap-southeast-1.amazonaws.com/rg-ops-image:${IMAGE_TAG}
docker push 995465982134.dkr.ecr.ap-southeast-1.amazonaws.com/rg-ops-image:latest
