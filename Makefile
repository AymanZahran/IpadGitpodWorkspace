PushToGithub:
	> id_rsa > id_rsa.pub
	git add .
	git commit -m "Commit"
	git push

GHCRLogin:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
DockerLogin:
	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN

PushGitpodImageToGHCR:
	GITPOD_IMAGE_NAME=ipad-gitpod-image
	docker build . --file Dockerfile --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushGitpodImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-gitpod-image
	docker build . --file Dockerfile --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
	docker push $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
PushGitpodImage: PushGitpodImageToGHCR PushGitpodImageToDockerHub

PushJenkinsImageToGHCR:
	GITPOD_IMAGE_NAME=ipad-jenkins-image
	docker build . --file Dockerfile.Jenkins --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushJenkinsImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-jenkins-image
	docker build . --file Dockerfile.Jenkins --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
	docker push $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
PushJenkinsImage: PushJenkinsImageToGHCR PushJenkinsImageToDockerHub

PushAnsibleControllerImageToGHCR:
	GITPOD_IMAGE_NAME=ipad-ansiblecontroller-image
	docker build . --file Dockerfile.AnsibleController --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleControllerImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-ansiblecontroller-image
	docker build . --file Dockerfile.AnsibleController --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
	docker push $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleControllerImage: PushAnsibleControllerImageToGHCR PushAnsibleControllerImageToDockerHub

PushAnsibleTargetImageToGHCR:
	GITPOD_IMAGE_NAME=ipad-ansibletarget-image
	docker build . --file Dockerfile.AnsibleTarget --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleTargetImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-ansibletarget-image
	docker build . --file Dockerfile.AnsibleTarget --tag $GITPOD_IMAGE_NAME
	IMAGE_ID=ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
	docker tag $GITPOD_IMAGE_NAME $IMAGE_ID
	docker login --username $$DOCKERHUB_USERNAME --password $$DOCKERHUB_TOKEN
	docker push $$DOCKERHUB_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleControllerImage: PushAnsibleTargetImageToGHCR PushAnsibleTargetImageToDockerHub