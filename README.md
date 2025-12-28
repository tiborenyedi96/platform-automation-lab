# platform-automation-lab

Automated DevOps infrastructure with Vagrant, Ansible, K3s, and Jenkins.

## Prerequisites

- VirtualBox
- Vagrant
- DockerHub account

## Default Credentials

- VM users: `udemx`
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
ssh -i ssh-keys/udemx_key -p 2234 udemx@localhost
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
exit
```

- Install suggested plugins
- Create admin user
- Add DockerHub credentials (ID: `dockerhub-credentials`)
- Add GitHub credentials (ID: `github-credentials`)

### 3. Setup SSH key

Get Jenkins public key from Ansible output during provisioning.

Add to app server:
```bash
ssh -i ssh-keys/udemx_key -p 2233 udemx@localhost
echo '<jenkins-public-key>' >> ~/.ssh/authorized_keys
exit
```

### 4. Create DockerHub secret

```bash
ssh -i ssh-keys/udemx_key -p 2233 udemx@localhost
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