#!/bin/bash
eval $(gp env -e)
docker login --username $GHCR_USERNAME --password $GHCR_TOKEN