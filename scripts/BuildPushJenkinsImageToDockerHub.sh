#!/bin/bash
eval $(gp env -e)
docker login --username $DOCKERHUB_USERNAME --password $DOCKERHUB_TOKEN
docker build . --file ../Dockerfile.Jenkins --tag $DOCKERHUB_USERNAME/$JENKINS_IMAGE_NAME
docker push $DOCKERHUB_USERNAME/$JENKINS_IMAGE_NAME
docker logout