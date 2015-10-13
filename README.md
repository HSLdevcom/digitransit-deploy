# digitransit-deploy
Deployment scripts for Digitransit

## Issues
Our main issue tracking is handled in [https://digitransit.atlassian.net](https://digitransit.atlassian.net)
However, we also monitor this repository's issues and import them to Jira. You can create issues in GitHub.

## Getting started on MAC OSX (sorry, no Windows support yet. Linux should work.)

### Install Ansible
- Run: sudo pip install ansible
- Run: sudo pip install docker-py
- Ensure that you have an account and your SSH public key on dev and test servers

### Check that everything works
- Execute: ansible -i environments/test test -m ping -u {your username in test}

### Using build menu
- Run './menu.sh'. This uses your current username and selects 'dev environment' as a default
- Menu enables you to build and launch containers, ssh into servers, and display docker-compose logs

## Analytics
Current analytics are implemented with Piwik. You can install piwik like so:
- mkdir -p /var/lib/mysql
- docker run --name mysql_db -v /var/lib/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=password -d mysql
- ssh to db container and create "piwiki" database:
  - CREATE DATABASE piwik DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
  - GRANT ALL ON piwik.* to 'piwik'@'%' identified by 'password';
  - Also, check that /etc/mysql/my.cnf bindadress is 0.0.0.0
- docker run -d --link mysql_db:mysql_db --name="piwik" --publish="8090:80" cbeer/piwik
- Open browser to http://{host}:8090/
