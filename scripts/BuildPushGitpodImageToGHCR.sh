#!/bin/bash
eval $(gp env -e)
docker login ghcr.io --username $GHCR_USERNAME --password $GHCR_TOKEN
docker build . --file ../Dockerfile --tag ghcr.io/$GHCR_USERNAME/$GITPOD_IMAGE_NAME
docker push ghcr.io/$GHCR_USERNAME/$GITPOD_IMAGE_NAME
docker logout