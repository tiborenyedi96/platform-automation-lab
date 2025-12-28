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

### 2. Get app server IP

```bash
vagrant ssh app-server -c "hostname -I | awk '{print \$2}'"
```

### 3. Configure Jenkins

Get initial password:
```bash
vagrant ssh jenkins-server -c "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

Access Jenkins at http://localhost:8080
- Install suggested plugins
- Create admin user
- Add DockerHub credentials (ID: `dockerhub-credentials`)

### 4. Setup SSH key

Get Jenkins public key from Ansible output or:
```bash
vagrant ssh jenkins-server -c "sudo cat /var/lib/jenkins/.ssh/id_rsa.pub"
```

Add to app server:
```bash
vagrant ssh app-server
mkdir -p ~/.ssh
echo '<jenkins-public-key>' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
exit
```

### 5. Create DockerHub secret

```bash
vagrant ssh app-server
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=YOUR_USERNAME \
  --docker-password=YOUR_PASSWORD \
  -n udemx
exit
```

### 6. Update hosts file

Add to hosts file:

```
127.0.0.1    hello.udemx.local
127.0.0.1    incidents.udemx.local
```

### 7. Setup application repo

In your incident-logger repository:
- Copy `Jenkinsfile.example` as `Jenkinsfile`
- Update `DOCKERHUB_USER` and `APP_SERVER_IP`
- Commit and push

### 8. Create Jenkins pipeline

- New Item → Pipeline
- Pipeline from SCM → Git
- Add repo URL and credentials
- Build Now

### 9. Access apps

- Hello UDEMX: https://hello.udemx.local
- Incident Logger: https://incidents.udemx.local

## What's included

- Debian 11 with SSH on port 2233
- K3s cluster with Helm
- Nginx Ingress with TLS
- UFW firewall and fail2ban
- OpenJDK 8 & 11
- Jenkins CI/CD
- Monitoring scripts in `/opt/scripts/`:
  - `db-backup.sh` (cron: daily 2 AM)
  - `last-three-mod.sh`
  - `last-five-day-mod-files.sh`
  - `loadavg.sh` (cron: every 15 min)