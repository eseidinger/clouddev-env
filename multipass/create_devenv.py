"""
A script to create a development VM with multipass that is accessible via SSH
"""
import argparse
import os
import subprocess


script_path = os.path.dirname(__file__)
template_path = f"{script_path}{os.sep}templates"
config_path = f"{script_path}{os.sep}config"


def clean_old_config(vm_name) -> None:
    """
    Remove old config files
    """
    try:
        os.remove(f"{config_path}{os.sep}{vm_name}_rsa")
        os.remove(f"{config_path}{os.sep}{vm_name}_rsa.pub")
        os.remove(f"{config_path}{os.sep}cloud-config.yaml")
    except FileNotFoundError:
        pass


def create_ssh_key(vm_name: str) -> None:
    """
    Create a SSH key to use to connect to the VM
    """
    subprocess.run("ssh-keygen -m PEM -t rsa -b 4096 "
                   + f'-f {config_path}{os.sep}{vm_name}_rsa -N "" -q',
                   shell=True, check=True)


def get_ssh_public_key(vm_name: str) -> str:
    """
    Read the SSH public key from the configuration
    """
    with open(f"{config_path}{os.sep}{vm_name}_rsa.pub", encoding="utf-8") as file:
        ssh_public_key = file.read()
    return ssh_public_key.strip(" \r\n")


def create_cloud_config(ssh_authorized_key: str):
    """
    Create cloud-config to use to create VM
    """
    with open(f"{template_path}{os.sep}cloud-config_template.yaml",
              encoding="utf-8") as file:
        cloud_config_template = file.read()

    cloud_config = cloud_config_template.replace(
        "[ssh_authorized_key]", ssh_authorized_key)

    with open(f"{config_path}{os.sep}cloud-config.yaml", "w",
              encoding="utf-8") as file:
        file.write(cloud_config)


def create_vm(vm_name: str):
    """
    Create a VM using a cloud-config file
    """
    subprocess.run(f"multipass launch jammy --name {vm_name} --cpus 6 "
                   + "--disk 60G --mem 10G --cloud-init "
                   + f"{config_path}{os.sep}cloud-config.yaml",
                   shell=True, check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create development VM.')
    parser.add_argument('vm_name', help='the name of the VM to create',
                        default='eseidinger-clouddev')
    args = parser.parse_args()
    clean_old_config(args.vm_name)
    create_ssh_key(args.vm_name)
    public_key: str = get_ssh_public_key(args.vm_name)
    create_cloud_config(public_key)
    create_vm(args.vm_name)
