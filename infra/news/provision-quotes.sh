#!/bin/bash -e

if [ -z "$1" ]; then
  echo "Must specify docker image as first argument"
fi

DOCKER_IMAGE=$1

echo "Provisioning docker image $DOCKER_IMAGE"

# cleanup previous deployment
docker stop quotes || true
docker rm quotes || true

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 339713031268.dkr.ecr.us-east-1.amazonaws.com

docker build -t news4421-quotes -f Dockerfile .

docker tag news4421-quotes:latest 339713031268.dkr.ecr.us-east-1.amazonaws.com/news4421-quotes:latest

docker push 339713031268.dkr.ecr.us-east-1.amazonaws.com/news4421-quotes:latest

docker run -d \
  --name quotes \
  --restart always \
  -p 8082:8082 \
  $DOCKER_IMAGE
