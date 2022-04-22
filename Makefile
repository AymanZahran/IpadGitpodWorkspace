PushToGithub:
	> id_rsa > id_rsa.pub
	git add .
	git commit -m "Commit"
	git push
PushToDockerHub:
	docker login --username aymanzahran --password $$DOCKERHUB_PERSONAL_ACCESS_TOKEN
	docker build -t aymanzahran/ipad-gitpod-image .
	docker push aymanzahran/ipad-gitpod-image
DockerLogin:
	docker login --username aymanzahran --password $$DOCKERHUB_PERSONAL_ACCESS_TOKEN
DockerExecAnsible:
	docker exec -it ipadgitpodworkspace-AnsibleController-1 /bin/bash
DockerExecJenkins:
	docker exec -it ipadgitpodworkspace-Jenkins-1 /bin/bash
