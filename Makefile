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

BuildPushGitpodImageToGHCR:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile --tag ghcr.io/$$GHCR_USERNAME/${GITPOD_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${GITPOD_IMAGE_NAME}
	docker logout
BuildPushGitpodImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile --tag $$GHCR_USERNAME/${GITPOD_IMAGE_NAME}
	docker push $$DOCKERHUB_USERNAME/${GITPOD_IMAGE_NAME}
	docker logout
BuildPushGitpodImage: BuildPushGitpodImageToGHCR BuildPushGitpodImageToDockerHub

BuildPushJenkinsImageToGHCR:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.Jenkins --tag ghcr.io/$$GHCR_USERNAME/${JENKINS_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${JENKINS_IMAGE_NAME}
	docker logout
BuildPushJenkinsImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.Jenkins --tag $$GHCR_USERNAME/${JENKINS_IMAGE_NAME}
	docker push $$DOCKERHUB_USERNAME/${JENKINS_IMAGE_NAME}
	docker logout
BuildPushJenkinsImage: BuildPushJenkinsImageToGHCR BuildPushJenkinsImageToDockerHub

BuildPushAnsibleControllerImageToGHCR:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleController --tag ghcr.io/$$GHCR_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker logout
BuildPushAnsibleControllerImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleController --tag $$GHCR_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker push $$DOCKERHUB_USERNAME/${ANSIBLE_CONTROLLER_IMAGE_NAME}
	docker logout
BuildPushAnsibleControllerImage: BuildPushAnsibleControllerImageToGHCR BuildPushAnsibleControllerImageToDockerHub

BuildPushAnsibleTargetImageToGHCR:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleTarget --tag ghcr.io/$$GHCR_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker push ghcr.io/$$GHCR_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker logout
BuildPushAnsibleTargetImageToDockerHub:
	docker login ghcr.io --username $$GHCR_USERNAME --password $$GHCR_TOKEN
	docker build . --file Dockerfile.AnsibleTarget --tag $$GHCR_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker push $$DOCKERHUB_USERNAME/${ANSIBLE_TARGET_IMAGE_NAME}
	docker logout
BuildPushAnsibleControllerImage: BuildPushAnsibleTargetImageToGHCR BuildPushAnsibleTargetImageToDockerHub

BuildPushAll: BuildPushGitpodImage BuildPushJenkinsImage BuildPushAnsibleControllerImage BuildPushAnsibleControllerImage