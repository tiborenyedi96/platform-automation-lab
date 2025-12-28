# platform-automation-lab

Automated DevOps infrastructure with Vagrant, Ansible, K3s, and Jenkins.

## Prerequisites

- VirtualBox
- Vagrant
- DockerHub account

## Setup

### 1. Start VMs

```bash
cd vagrant
vagrant up
```

### 2. Configure Jenkins

Wait for VMs to finish provisioning (~10-15 min).

Get initial password from Ansible output or:
```bash
vagrant ssh jenkins-server -c "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

Access Jenkins at http://localhost:8080
- Install suggested plugins
- Create admin user
- Add DockerHub credentials (ID: `dockerhub-credentials`)

### 3. Setup SSH key

Get Jenkins public key:
```bash
vagrant ssh jenkins-server -c "sudo cat /var/lib/jenkins/.ssh/id_rsa.pub"
```

Add to app server:
```bash
ssh -i vagrant/ssh-keys/udemx_key -p 2233 udemx@localhost
echo '<jenkins-public-key>' >> ~/.ssh/authorized_keys
exit
```

### 4. Create DockerHub secret

```bash
ssh -i vagrant/ssh-keys/udemx_key -p 2233 udemx@localhost
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_PASSWORD \
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

In your incident-logger repository:
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