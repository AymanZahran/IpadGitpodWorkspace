FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY Jenkins/casc.yaml /var/jenkins_home/casc.yaml
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY Jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt


