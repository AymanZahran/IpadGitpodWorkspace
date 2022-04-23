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
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile --tag ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushGitpodImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-gitpod-image
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile --tag $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushGitpodImage: PushGitpodImageToGHCR PushGitpodImageToDockerHub

PushJenkinsImageToGHCR:
	GITPOD_IMAGE_NAME=ipad-jenkins-image
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.Jenkins --tag ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushJenkinsImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-jenkins-image
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.Jenkins --tag $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushJenkinsImage: PushJenkinsImageToGHCR PushJenkinsImageToDockerHub

PushAnsibleControllerImageToGHCR:
	GITPOD_IMAGE_NAME=ipad-ansiblecontroller-image
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleController --tag ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleControllerImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-ansiblecontroller-image
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleController --tag $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleControllerImage: PushAnsibleControllerImageToGHCR PushAnsibleControllerImageToDockerHub

PushAnsibleTargetImageToGHCR:
	GITPOD_IMAGE_NAME=ipad-ansibletarget-image
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleTarget --tag ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push ghcr.io/$$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleTargetImageToDockerHub:
	GITPOD_IMAGE_NAME=ipad-ansibletarget-image
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleTarget --tag $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
	docker push $$GHCR_USERNAME/$GITPOD_IMAGE_NAME
PushAnsibleControllerImage: PushAnsibleTargetImageToGHCR PushAnsibleTargetImageToDockerHub