PushToGithub:
	cd scripts && ./PushToGithub.sh && cd ..

GHCRLogin:
	cd scripts && ./GHCRLogin.sh && cd ..
DockerLogin:
	cd scripts && ./DockerLogin.sh && cd ..

BuildPushGitpodImageToGHCR:
	cd scripts && ./BuildPushGitpodImageToGHCR.sh && cd ..
BuildPushGitpodImageToDockerHub:
	cd scripts && ./BuildPushGitpodImageToDockerHub.sh && cd ..
BuildPushGitpodImage: BuildPushGitpodImageToGHCR BuildPushGitpodImageToDockerHub

BuildPushJenkinsImageToGHCR:
	cd scripts && ./BuildPushJenkinsImageToGHCR.sh && cd ..
BuildPushJenkinsImageToDockerHub:
	cd scripts && ./BuildPushJenkinsImageToDockerHub.sh && cd ..
BuildPushJenkinsImage: BuildPushJenkinsImageToGHCR BuildPushJenkinsImageToDockerHub

BuildPushAnsibleControllerImageToGHCR:
	cd scripts && ./BuildPushAnsibleControllerImageToGHCR.sh && cd ..
BuildPushAnsibleControllerImageToDockerHub:
	cd scripts && ./BuildPushAnsibleControllerImageToDockerHub.sh && cd ..
BuildPushAnsibleControllerImage: BuildPushAnsibleControllerImageToGHCR BuildPushAnsibleControllerImageToDockerHub

BuildPushAnsibleTargetImageToGHCR:
	cd scripts && ./BuildPushAnsibleTargetImageToGHCR.sh && cd ..
BuildPushAnsibleTargetImageToDockerHub:
	cd scripts && ./BuildPushAnsibleTargetImageToDockerHub.sh && cd ..
BuildPushAnsibleControllerImage: BuildPushAnsibleTargetImageToGHCR BuildPushAnsibleTargetImageToDockerHub

BuildPushAll: BuildPushGitpodImage BuildPushJenkinsImage BuildPushAnsibleControllerImage BuildPushAnsibleControllerImage

PushAll: PushToGithub BuildPushAll