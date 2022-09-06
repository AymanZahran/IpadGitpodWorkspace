#!/bin/bash
eval $(gp env -e)
docker login ghcr.io --username $GITHUB_USER --password $GITHUB_TOKEN