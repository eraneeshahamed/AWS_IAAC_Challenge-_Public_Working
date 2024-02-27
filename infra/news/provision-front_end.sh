#!/bin/bash -e
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --docker-image)
    DOCKER_IMAGE="$2"
    shift # past argument
    shift # past value
    ;;
    --quote-service-url)
    QUOTE_SERVICE_URL="$2"
    shift # past argument
    shift # past value
    ;;
    --newsfeed-service-url)
    NEWSFEED_SERVICE_URL="$2"
    shift # past argument
    shift # past value
    ;;
    --static-url)
    STATIC_URL="$2"
    shift # past argument
    shift # past value
    ;;
    --region)
    AWS_DEFAULT_REGION="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

echo "Provisioning docker image $DOCKER_IMAGE"

# cleanup previous deployment
docker stop front_end || true
docker rm front_end || true


docker build -t news4421-front_end -f Dockerfile .

docker tag news4421-front_end:latest 339713031268.dkr.ecr.us-east-1.amazonaws.com/news4421-front_end:latest

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 339713031268.dkr.ecr.us-east-1.amazonaws.com

docker push 339713031268.dkr.ecr.us-east-1.amazonaws.com/news4421-front_end:latest

NEWSFEED_SECRET_TOKEN="T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX"

docker run -d \
  --restart always \
  --name front_end \
  -e QUOTE_SERVICE_URL=${QUOTE_SERVICE_URL} \
  -e NEWSFEED_SERVICE_URL=${NEWSFEED_SERVICE_URL} \
  -e STATIC_URL=${STATIC_URL} \
  -e NEWSFEED_SERVICE_TOKEN=${NEWSFEED_SECRET_TOKEN} \
  -p 8080:8080 \
  $DOCKER_IMAGE
