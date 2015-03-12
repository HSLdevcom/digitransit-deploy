# openjourneyplanner-deploy
Deployment scripts for Open Journey Planner

## Localhost - Getting started Mac OSX

### Create and test SSH access
- Install VirtualBox and Ubuntu on it. You can use e.g. Vagrant to do this or alternatively use Boot2Docker.
- Ensure forwarded port from host to guest: 2231 -> 22
- Ensure forwarded port from host to guest: 8080 -> 80
- Add your personal public key to virtual machine /root/.ssh/authorized_keys
- Ensure this works: ssh -p 2231 root@localhost

### Install Ansible
- Run: sudo pip install ansible
- Run: sudo pip install docker-py
- Ensure this works: ansible -i environments/local local -m ping -u root

### Build docker images
- First get encryption key, you need it to use hsl and matka.fi datasources
- Build Route-server; Run: ansible-playbook -i environments/local playbooks/build-route-server -u root --ask-vault-pass
- Build others; Run: ansible-playbook -i environments/local playbooks/{playbook-name} -u root

### Start containers
- Run: ansible-playbook -i environments/local playbooks/run.yaml -u root
- Access reverse proxy http://localhost:8080/

## Test environment - Getting started

### Requirements
- Ensure you have Ansible installed on you local computer
- Ensure that you have an account and your SSH public key is on the test server
- Ensure this works: ansible -i environments/test test -m ping -u {your username in test}

### Using build menu
- Run ./menu.sh 
- Menu enables you to build and launch servers, ssh into test, and display docker-compose logs