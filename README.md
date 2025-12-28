# platform-automation-lab

# 1. Start VMs
cd vagrant && vagrant up

# 2. Get Jenkins password
vagrant ssh jenkins-server -c "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

# 3. Open Jenkins: http://localhost:8080
# - Install suggested plugins
# - Create admin user

# 4. Add DockerHub credentials in Jenkins
# Manage Jenkins → Credentials → Add:
# - ID: dockerhub-credentials
# - Username/Password: Your DockerHub account

# 5. Create DockerHub secret on app server
vagrant ssh app-server
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_TOKEN \
  -n udemx
exit

# 6. Add to your hosts file
127.0.0.1    myapp.udemx.local
127.0.0.1    app.udemx.local

# 7. Create Jenkins pipeline job
## - New Item → Pipeline
## - Pipeline from SCM → Git
## - Repo URL, credentials, branch
## - Save → Build Now

# 8. Access apps
## https://hello.udemx.local
## https://incidents.udemx.local
