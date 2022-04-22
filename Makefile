PushToGithub:
	> id_rsa > id_rsa.pub
	git add .
	git commit -m "Commit"
	git push
# GHCRLogin:
# 	docker login --username $$GHCR_USERNAME --password $$GHCR_TOKEN
# DockerLogin:
# 	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
# PushGitpodImage:
# 	GITPOD_IMAGE_NAME=ipad-gitpod-image
# 	docker build . --file Dockerfile --tag $GITPOD_IMAGE_NAME
# 	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
# 	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
# 	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
#  	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
# 	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
# 	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
# 	docker build -t $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME .
# 	docker push $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
# PushGitpodImage:
# 	GITPOD_IMAGE_NAME=ipad-gitpod-image
#  	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_PASSWORD
# 	docker build -t $$GHCR_USERNAME/$GITPOD_IMAGE_NAME .
# 	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
# 	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
# 	docker build -t $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME .
# 	docker push $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
# PushGitpodImage:
# 	GITPOD_IMAGE_NAME=ipad-gitpod-image
#  	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_PASSWORD
# 	docker build -t $$GHCR_USERNAME/$GITPOD_IMAGE_NAME .
# 	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
# 	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
# 	docker build -t $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME .
# 	docker push $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME

DockerExecAnsible:
	docker exec -it ipadgitpodworkspace-AnsibleController-1 /bin/bash
DockerExecJenkins:
	docker exec -it ipadgitpodworkspace-Jenkins-1 /bin/bash
