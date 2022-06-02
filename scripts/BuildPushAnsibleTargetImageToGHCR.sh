#!/bin/bash
eval $(gp env -e)
docker login ghcr.io --username $GHCR_USERNAME --password $GHCR_TOKEN
docker build . --file ../Dockerfile.AnsibleTarget --tag $GHCR_USERNAME/$ANSIBLE_TARGET_IMAGE_NAME
docker push $$DOCKERHUB_USERNAME/$ANSIBLE_TARGET_IMAGE_NAME
docker logout