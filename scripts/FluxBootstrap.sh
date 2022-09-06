#!/bin/bash
eval $(gp env -e)
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=IpadGitpodWorkspace \
  --branch=master \
  --path=../Flux/ \
  --personal