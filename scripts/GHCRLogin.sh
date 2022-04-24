#!/bin/bash
eval $(gp env -e)
docker login ghcr.io --username $GHCR_USERNAME --password $GHCR_TOKEN