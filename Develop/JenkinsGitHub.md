$title=Jenkins + GitHub

Stack Setup is updated via Git(Hub). Updates are either a result of:

+ A merged pull request
+ A push from a contributor

About 5 minutes after such an action this update is automatically put live. This is only a very basic example, but it demonstrates the usefullness of an automatic test/deploy tool like Jenkins. Setting up and configuring Jenkins to do this is very easy:


### Installing Jenkins

The easiest way to install Jenkins is via package manager. Debian/Ubuntu:

    wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    apt-get install jenkins

CentOS/RedHat:

    wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    yum install jenkins

Upgrading Jenkins can be done within Jenkins itself, rather than via the package manager. If you wish to integrate with Git and/or SSH remote servers, Jenkins will need a SSH key:

    su jenkins
    cd ~/.ssh/
    ssh-keygen -t rsa -C "jenkins@example.com"


### Plugins & Git/GitHub Integration

Found in Jenkins via: Managing Jenkins -> Plugin Manager

One of the best features of Jenkins is how extendable it can be. Here are some great Git/GitHub ones and a few others:

+ Git plugin
+ Git client plugin
+ GitHub API Plugin
+ GitHub Authentication Plugin
+ GitHub plugin
+ GitHub Pull Request Builder
+ SSH plugin - allows you to add servers Jenkins can connect to via SSH and execute commands remotely (for deploys/etc)


#### Automatic builds

Projects in Jenkins can be configured to poll Git (and other Source Code Managers) repositories for changes. Jenkins can also be configured to monitor GitHub for pull requests, and build those - it can even send the results of the build back to the pull request on GitHub. With the above plugins installed these options are explained in the web interface.


### Continuous & Automatic Test/Deploy

By using multiple 'projects' per actual dev project we can create a mostly automatic deployment cycle. Say you have 3 branches: develop, staging and production; for each of these we setup `test` and `deploy` projects, the second of which is only triggered after the first succeeds:

`<repository>-<branch>-test` => `<repository>-<branch>-deploy`