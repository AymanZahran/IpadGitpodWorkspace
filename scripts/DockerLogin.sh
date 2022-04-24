#!/bin/bash
eval $(gp env -e)
docker login --username $DOCKERHUB_USERNAME --password $DOCKERHUB_TOKEN