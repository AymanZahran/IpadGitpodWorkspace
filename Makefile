PushToGithub:
	git add .
	git commit -m "Commit"
	git push
PushToDockerHub:
	docker login --username aymanzahran --password $$DOCKERHUB_PERSONAL_ACCESS_TOKEN
	docker build -t aymanzahran/ipad-gitpod-image .
	docker push aymanzahran/ipad-gitpod-image
DockerLoginAnsible:
	docker exec -it ipadgitpodworkspace-AnsibleController-1 /bin/bash
DockerLoginJenkins:
	docker exec -it ipadgitpodworkspace-Jenkins-1 /bin/bash
