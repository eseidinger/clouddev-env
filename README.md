# Cloud Development Environment

This repository contains Python and shell scripts to set up a local Ubuntu VM containing cloud development tools.
The VM can be created on Linux, MacOS and Windows using [Multipass](https://multipass.run/).

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
* [cosgin](https://github.com/sigstore/cosign): Signing OCI containers (and other artifacts)

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

```bash
git clone https://gitea.eseidinger.de/public/clouddev-env.git
cd clouddev-env
```

The scripts for provisioning the development VM are in the directory *multipass*.

```bash
cd multipass
```

Executing the following command will create an Ubuntu VM using the virtualization technology native to your system.
A SSH key pair will be created and the public key is set as authorized key for the *clouddev* user in the VM.
The *clouddev* user is configured for sudo without password. The configuration for the user is created using
[cloud-init](https://cloudinit.readthedocs.io/en/latest/).
You can optionally specify a VM name for all commands. If you do not specify a VM name, *clouddev* will be used.

```bash
python create_devenv.py [--vm_name your_vm_name]
```

The next script will adapt the SSH config file in your home directory to allow connections to the VM without having
to enter a username or password.

```bash
python print_ssh_config.py [--vm_name your_vm_name] > ~/.ssh/config
```

Now you should be able to login to your VM using SSH. Try the following command.
You may need to change the host name.

```bash
ssh clouddev
```

You should now see a shell with the prompt *(base) clouddev@clouddev:~$*
The prompt may be different depending on your host name. Type `exit` to leave the shell.

Next we are going to install all the tools we need into the virtual development environment.

```bash
python install_tools.py [--vm_name your_vm_name]
```

You can test if all the tools have been installed and have the correct version by executing the
[pytests](https://docs.pytest.org/).

```bash
cd test
[VM_NAME=your_vm_name] python test_tool_versions.py
```

### Connect to the Development Environment

Start Visual Studio Code and follow the instructions on ["Remote Development using SSH"](https://code.visualstudio.com/docs/remote/ssh).

Or simply click on the "Open a Remote Window" button on the left side of the status bar and select "Connect to Host...".
A drop down menu should appear, offering you to connect to "clouddev".

Open the folder */home/clouddev* and open a terminal to configure git and clone this repository.

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@address.com"
git clone https://gitea.eseidinger.de/public/clouddev-env.git
```

### Build and Test the Docker Image

The image can be built using the following command:

```bash
docker build -t cloud-tools ./tools/ -f image/Dockerfile
```

To test the image run:

```bash
docker compose up
```

This will mount the Go test module in the *image-test* directory, install [Terratest](https://terratest.gruntwork.io/) and execute the tests.
The tests will check if all the tools were installed and have the correct version.

To try the tools in the image using a Docker in Docker environment, run:

```bash
docker compose -f docker-compose-dind.yml up -d
docker compose -f docker-compose-dind.yml exec cloud-tools bash
```

### X11 Forwarding

Although not strictly necessary, you can forward an X11 connection to the development VM to use tools with a GUI.
This works for Linux hosts out of the box.
For MacOS you'll have to install an XServer like [XQuartz](https://www.xquartz.org/)
and for Windows there is for example [VcXsrv](https://sourceforge.net/projects/vcxsrv/).

For Windows you also need to set the DISPLAY environment variable on the Linux VM.

```bash
export DISPLAY=xxx.xxx.xxx.xxx:0.0
```

Where *xxx.xxx.xxx.xxx* is the IPv4 address of the default switch. You can get this address using the `ipconfig` command on the Windows host.

## Troubleshooting

### Cannot connect to VM after reboot

If you cannot connect to your VM, it may have gotten a new IP address. To reconnect, run the *print_ssh_config.py* script again and modify your *~/.ssh/config* accordingly.

### Docker and MicroK8s not working

If you have connected Visual Studio Code to the *clouddev* VM before running the *install_tools.py* script, *docker* and *microk8s* won't work due to lacking privileges.
You'll have to reconnect (see [Cleaning up the VS Code Server on the remote](https://code.visualstudio.com/docs/remote/troubleshooting#_cleaning-up-the-vs-code-server-on-the-remote)), for the necessary group changes to the *clouddev* user to be applied.
