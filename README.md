# Cloud Development Environment

This repository contains Python and shell scripts to set up a local Ubuntu VM containing cloud development tools.
The VM can be created on Linux, MacOS and Windows using Multipass.

There are also scripts to set up a SSH connection from your host machine to the development VM.
A modern IDE like [Visual Studio Code](https://code.visualstudio.com/) can be used to work remotely on your VM using SSH.

A Dockerfile to create an Ubuntu based Docker image containing the same tool versions as the development VM is also available.
The image can be used with a CI/CD tool to automate build, test and deployment.

## Tools

The virtual machine as well as the image contain tools for all kinds of software development and deployment tasks.

### Software Development Tools

* [python](https://www.python.org/): a programming language that lets you work quickly and integrate systems more effectively
* [Miniconda](https://docs.conda.io/en/latest/miniconda.html): open source package management system and environment management for Python
* [Go](https://go.dev/): an open source programming language supported by Google
* [Node.js](https://nodejs.org/): an open-source, cross-platform JavaScript runtime environment
* [Java](https://www.java.com/): a programming language and computing platform
* [Kotlin](https://kotlinlang.org/): a modern but already mature programming language
* [Gradle](https://gradle.org/): an open-source build automation tool

### Docker Tools

* [Docker](https://www.docker.com/): package an application in an image and run it in an isolated container
* [Trivy](https://github.com/aquasecurity/trivy): a security scanner that can be used on images

### Kubernetes Tools

* [MicroK8s](https://microk8s.io/): The lightweight Kubernetes (VM only)
* [kind](https://kind.sigs.k8s.io/): a tool for running local Kubernetes clusters using Docker container “nodes”
* [Kubectl](https://kubernetes.io/docs/reference/kubectl/): the Kubernetes CLI
* [Helm](https://helm.sh/): the package manager for Kubernetes
* [k9s](https://k9scli.io/): Kubernetes CLI To Manage Your Clusters In Style (VM only)
* [Istio](https://istio.io/): a service mesh for Kubernetes

### Provisioning Tools

* [AWS CLI](https://aws.amazon.com/de/cli/): a unified tool to manage your AWS services
* [Ansible](https://docs.ansible.com/ansible/latest/index.html): a radically simple IT automation system
* [Terraform](https://www.terraform.io/): automate infrastructure on any cloud

## Usage

### Prerequisites

The following tools are needed to setup the virtual development environment on your host machine:

* [Git](https://git-scm.com/): a free and open source distributed version control system
* [Mulitpass](https://multipass.run/): Ubuntu VMs on demand for any workstation
* [Secure Shell](https://en.wikipedia.org/wiki/Secure_Shell): a cryptographic network protocol for operating network services securely over an unsecured network
* [Python](https://www.python.org/): a programming language that lets you work quickly and integrate systems more effectively

You need to install them, if they are not already available on your host.

### Provision Development Environment

First you need to clone this repository:

```
git clone https://gitea.eseidinger.de/public/clouddev-env.git
cd clouddev-env
```

The scripts for provisioning the development VM are in the directory _multipass_.

```
cd multipass
```

Executing the following command will create an Ubuntu VM using the virtualization technology native to your system.
A SSH keypair will be created and the public key is set as authorized key for the _clouddev_ user in the VM.
The _clouddev_ user is configured for sudo without password. The configuration for the user is created using
[cloud-init](https://cloudinit.readthedocs.io/en/latest/).
You can optionally specify a VM name for all commands. If you do not specificy a VM name, _clouddev_ will be used.

```
python create_devenv.py [--vm_name your_vm_name]
```

The next script will adapt the SSH config file in your home directory to allow connections to the VM without having
to enter a username or password.

```
python print_ssh_config.py [--vm_name your_vm_name] > ~/.ssh/config
```

Now you should be able to login to your VM using SSH. Try the following command.
You may need to change the host name.

```
ssh clouddev
```

You should now see a shell with the prompt _(base) clouddev@clouddev:~$_
The prompt may be different depending on your host name. Type `exit` to leave the shell.

Next we are going to install all the tools we need into the virtual development environment.

```
python install_tools.py [--vm_name your_vm_name]
```

You can test if all the tools have been installed and have the correct version by executing the
[pytests](https://docs.pytest.org/).


```
cd test
[VM_NAME=your_vm_name] python test_tool_versions.py
```

### Connect to the Development Environment

Start Visual Studio Code and follow the instructions on ["Remote Development using SSH"](https://code.visualstudio.com/docs/remote/ssh).

Or simply click on the "Open a Remote Window" button on the left side of the status bar and select "Connect to Host...".
A drop down menu should appear, offering you to connect to "clouddev".

Open the folder _/home/clouddev_ and open a terminal to configure git and clone this repository.

```
git config --global user.name "Your Name"
git config --global user.email "your.email@address.com"
git clone https://gitea.eseidinger.de/public/clouddev-env.git
```

### Build and Test the Docker Image

The image can be built using the following command:
```
docker build -t cloud-tools ./tools/ -f image/Dockerfile
```

To test the image run:
```
docker compose up
```

This will mount the Go test module in the _image-test_ directory, install [Terratest](https://terratest.gruntwork.io/) and execute the tests.
The tests will check if all the tools were installed and have the correct version. 

To try the tools in the image using a Docker in Docker environment, run:
```
docker compose -f docker-compose-dind.yml up -d
docker compose -f docker-compose-dind.yml exec cloud-tools bash
```
