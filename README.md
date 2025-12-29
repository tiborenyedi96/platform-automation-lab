# platform-automation-lab

This is an automated DevOps infrastructure with Vagrant, Ansible, K3s, and Jenkins. I made this as a take-home assignment and to learn about Ansible, Jenkins and K3s.

## Note
This application uses a private repository for the main application components and helm charts to show how separation of concerns can be implemented with the tools I used. This public repository only contains the infrastructure built with Vagrant and Ansible and a basic application helm chart which is automatically deployed and shows a simple Hello UDEMX message on the main page.

To fully use this repository you would need the contents of my private application repository. It contains the completed Jenkinsfile, the frontend and backend code with dockerfiles, and the helm chart which can be deployed to the application server.

## Prerequisites

- VirtualBox
- Vagrant
- DockerHub account
- Access to the private repository

## Default Credentials

- VM user: `udemx`
- VM sudo password: `Alma1234`
- VM root password: `Alma1234`

## Setup

### 1. Start VMs

```bash
cd vagrant
vagrant up
```

### 2. Configure Jenkins

Wait for VMs to finish provisioning (~10-15 min).

Access Jenkins at http://localhost:8080

Get initial password:
```bash
ssh -i ssh-keys/udemx_jenkins-server -p 2234 udemx@localhost
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
exit
```

- Install suggested plugins
- Create admin user
- Add DockerHub credentials (ID: `dockerhub-credentials`)
- Add GitHub credentials (ID: `github-credentials`)

### 3. Setup SSH key

Get Jenkins public key:
```bash
ssh -i ssh-keys/udemx_jenkins-server -p 2234 udemx@localhost
sudo cat /var/lib/jenkins/.ssh/id_rsa.pub
exit
```

Add to app server:
```bash
ssh -i ssh-keys/udemx_app-server -p 2233 udemx@localhost
echo '<jenkins-public-key>' >> ~/.ssh/authorized_keys
exit
```

### 4. Create DockerHub secret on application server

```bash
ssh -i ssh-keys/udemx_app-server -p 2233 udemx@localhost
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_DOCKER_ACCESS_TOKEN \
  -n udemx
exit
```

### 5. Update hosts file

Add to hosts file:

```
127.0.0.1    hello.udemx.local
127.0.0.1    incidents.udemx.local
```

### 6. Setup application repo

In the private incident logger repository:
- Copy `Jenkinsfile.example` as `Jenkinsfile`
- Update `DOCKERHUB_USER` and `APP_SERVER_IP`
- Commit and push

### 7. Create Jenkins pipeline

- New Item → Pipeline
- Pipeline from SCM → Git
- Add repo URL and credentials
- Build Now

### 8. Access apps

- Hello UDEMX: https://hello.udemx.local
- Incident Logger: https://incidents.udemx.local

---

## Screenshots

### Automated Monitoring and Backup Scripts

The infrastructure includes several monitoring and backup scripts that run automatically via cron jobs:

![Cron Jobs](docs/screenshots/cron-jobs.png)
*Automated cron jobs for MySQL backups (daily at 2 AM) and load average monitoring (every 15 minutes)*

![Load Average Monitoring](docs/screenshots/loadavg-output.png)
*Load average monitoring script output showing system metrics captured every 15 minutes*

![Last Three Modified Files](docs/screenshots/last-three-mod.png)
*Script tracking the three most recently modified files in /var/log*

![Files Modified in Last 5 Days](docs/screenshots/last-five-days.png)
*Comprehensive listing of all files modified in the last 5 days*

![MySQL Backup](docs/screenshots/mysql-backup.png)
*Successful MySQL database backup with working dump validation*

### CI/CD Pipeline

![Jenkins Credentials](docs/screenshots/jenkins-credentials.png)
*Jenkins configured with DockerHub and GitHub credentials for automated deployments*

![Jenkins Pipeline Success](docs/screenshots/jenkins-pipeline-success.png)
*Successful CI/CD pipeline execution showing all stages: Build, Push to DockerHub, Copy Helm Chart, and Deploy*

![Jenkins Pipeline Configuration](docs/screenshots/jenkins-pipeline-config.png)
*Jenkins pipeline configured with private GitHub repository and SCM integration*

![Docker Hub Images](docs/screenshots/dockerhub-images.png)
*Automated Docker image builds pushed to Docker Hub registry*

### Deployed Applications

![Kubernetes Resources](docs/screenshots/kubectl-get-all.png)
*All Kubernetes resources running successfully - pods, services, deployments, and Helm releases*

![Hello UDEMX Application](docs/screenshots/hello-udemx.png)
*Simple Hello UDEMX application deployed via Ansible and accessible through Ingress*

![Incident Logger - View Incidents](docs/screenshots/incident-logger-list.png)
*Incident Logger application showing ticket management system with severity levels and status tracking*

![Incident Logger - Submit Incident](docs/screenshots/incident-logger-submit.png)
*Incident submission form for creating new tickets with title, description, and severity selection*