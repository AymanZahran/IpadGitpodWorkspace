#!/bin/bash
eval $(gp env -e)
docker login --username $DOCKERHUB_USERNAME --password $DOCKERHUB_TOKEN
docker build . --file ../Dockerfile.AnsibleController --tag $DOCKERHUB_USERNAME/$ANSIBLE_CONTROLLER_IMAGE_NAME
docker push $DOCKERHUB_USERNAME/$ANSIBLE_CONTROLLER_IMAGE_NAME
docker logout