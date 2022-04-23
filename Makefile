GITPOD_IMAGE_NAME:= ipad-gitpod-image
JENKINS_IMAGE_NAME:= ipad-jenkins-image
ANSIBLE_CONTROLLER_IMAGE_NAME:= ipad-ansiblecontroller-image
ANSIBLE_TARGET_IMAGE_NAME:= ipad-ansibletarget-image

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
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile --tag ghcr.io/$$GHCR_USERNAME/${GITPOD_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${GITPOD_IMAGE_NAME}
	docker logout
PushGitpodImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile --tag $$GHCR_USERNAME/${GITPOD_IMAGE_NAME}
	docker push $$GHCR_USERNAME/${GITPOD_IMAGE_NAME}
	docker logout
PushGitpodImage: PushGitpodImageToGHCR PushGitpodImageToDockerHub

PushJenkinsImageToGHCR:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.Jenkins --tag ghcr.io/$$GHCR_USERNAME/${JENKINS_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${JENKINS_IMAGE_NAME}
	docker logout
PushJenkinsImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.Jenkins --tag $$GHCR_USERNAME/${JENKINS_IMAGE_NAME}
	docker push $$GHCR_USERNAME/${JENKINS_IMAGE_NAME}
	docker logout
PushJenkinsImage: PushJenkinsImageToGHCR PushJenkinsImageToDockerHub

PushAnsibleControllerImageToGHCR:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleController --tag ghcr.io/$$GHCR_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker logout
PushAnsibleControllerImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleController --tag $$GHCR_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker push $$GHCR_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker logout
PushAnsibleControllerImage: PushAnsibleControllerImageToGHCR PushAnsibleControllerImageToDockerHub

PushAnsibleTargetImageToGHCR:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleTarget --tag ghcr.io/$$GHCR_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker logout
PushAnsibleTargetImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleTarget --tag $$GHCR_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker push $$GHCR_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker logout
PushAnsibleControllerImage: PushAnsibleTargetImageToGHCR PushAnsibleTargetImageToDockerHub

PushAll: PushGitpodImage PushJenkinsImage PushAnsibleControllerImage PushAnsibleControllerImage