#!/bin/bash
eval $(gp env -e)
export $(cat .env | xargs)
docker login --username $DOCKERHUB_USERNAME --password $DOCKERHUB_TOKEN
docker build . --file Dockerfile --tag $DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
docker push $DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
docker logout