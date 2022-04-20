PushToGithub:
	git add .
	git commit -m "Commit"
	git push
PushToDockerHub:
	docker build -t aymanzahran/ipad-gitpod-image
	docker push
