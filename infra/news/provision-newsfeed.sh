#!/bin/bash -e

if [ -z "$1" ]; then
  echo "Must specify docker image as first argument"
fi

DOCKER_IMAGE=$1

echo "Provisioning docker image $DOCKER_IMAGE"

# cleanup previous deployment
docker stop newsfeed || true
docker rm newsfeed || true

docker build -t news4421-newsfeed -f Dockerfile .

docker tag news4421-newsfeed:latest 339713031268.dkr.ecr.us-east-1.amazonaws.com/news4421-newsfeed:latest

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 339713031268.dkr.ecr.us-east-1.amazonaws.com

docker push 339713031268.dkr.ecr.us-east-1.amazonaws.com/news4421-newsfeed:latest

docker run -d \
  --name newsfeed \
  --restart always \
  -p 8081:8081 \
  $DOCKER_IMAGE
