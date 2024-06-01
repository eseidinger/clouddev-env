"""
A script to create a development VM with multipass that is accessible via SSH
"""
import argparse
import os
import subprocess
import platform


script_path = os.path.dirname(__file__)
template_path = f"{script_path}{os.sep}templates"
config_path = f"{script_path}{os.sep}config"

system = platform.system()

multipass_extension = ""

if system == "Linux":
    kernel_info = platform.uname().release
    if "WSL2" in kernel_info:
        multipass_extension = ".exe"

def clean_old_config(env_name) -> None:
    """
    Remove old config files
    """
    try:
        os.remove(f"{config_path}{os.sep}{env_name}_rsa")
        os.remove(f"{config_path}{os.sep}{env_name}_rsa.pub")
        os.remove(f"{config_path}{os.sep}cloud-config.yaml")
    except FileNotFoundError:
        pass


def create_ssh_key(env_name: str) -> None:
    """
    Create a SSH key to use to connect to the VM
    """
    subprocess.run("ssh-keygen -m PEM -t rsa -b 4096 "
                   + f'-f {config_path}{os.sep}{env_name}_rsa -N "" -q',
                   shell=True, check=True)


def get_ssh_public_key(env_name: str) -> str:
    """
    Read the SSH public key from the configuration
    """
    with open(f"{config_path}{os.sep}{env_name}_rsa.pub", encoding="utf-8") as file:
        ssh_public_key = file.read()
    return ssh_public_key.strip(" \r\n")


def create_cloud_config(ssh_authorized_key: str, user: str):
    """
    Create cloud-config to use to create VM
    """
    with open(f"{template_path}{os.sep}cloud-config_template.yaml",
              encoding="utf-8") as file:
        cloud_config_template = file.read()

    cloud_config = cloud_config_template.replace(
        "[ssh_authorized_key]", ssh_authorized_key) \
        .replace("[user]", user)

    with open(f"{config_path}{os.sep}cloud-config.yaml", "w",
              encoding="utf-8") as file:
        file.write(cloud_config)


def create_vm(env_name: str, cpus: str, disk: str, memory: str):
    """
    Create a VM using a cloud-config file
    """
    subprocess.run(f"multipass{multipass_extension} launch noble --name {env_name} --cpus {cpus} "
                   + f"--disk {disk} --memory {memory} --cloud-init "
                   + f"{config_path}{os.sep}cloud-config.yaml",
                   shell=True, check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create development VM.')
    parser.add_argument('--env_name', help='the name of the VM to create',
                        default='clouddev', required=False)
    parser.add_argument('--cpus', help='the number of CPUs for the VM',
                        default='4', required=False)
    parser.add_argument('--disk', help='the disk size for the VM',
                        default='40G', required=False)
    parser.add_argument('--memory', help='the memory size for the VM',
                        default='4G', required=False)
    parser.add_argument('--user', help='user for the VM',
                        default='clouddev', required=False)
    args = parser.parse_args()
    clean_old_config(args.env_name)
    create_ssh_key(args.env_name)
    public_key: str = get_ssh_public_key(args.env_name)
    create_cloud_config(public_key, args.user)
    create_vm(args.env_name, args.cpus, args.disk, args.memory)
