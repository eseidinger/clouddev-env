"""
A script to create a development VM with multipass that is accessible via SSH
"""
import os
import subprocess


script_path = os.path.dirname(__file__)
template_path = f"{script_path}{os.sep}templates"
config_path = f"{script_path}{os.sep}config"


def clean_old_config() -> None:
    """
    Remove old config files
    """
    try:
        os.remove(f"{config_path}{os.sep}eseidinger-clouddev_rsa")
        os.remove(f"{config_path}{os.sep}eseidinger-clouddev_rsa.pub")
        os.remove(f"{config_path}{os.sep}cloud-config.yaml")
    except FileNotFoundError:
        pass


def create_ssh_key() -> None:
    """
    Create a SSH key to use to connect to the VM
    """
    subprocess.run("ssh-keygen -m PEM -t rsa -b 4096 "
                   + f'-f {config_path}{os.sep}eseidinger-clouddev_rsa -N "" -q',
                   shell=True, check=True)


def get_ssh_public_key() -> str:
    """
    Read the SSH public key from the configuration
    """
    with open(f"{config_path}{os.sep}eseidinger-clouddev_rsa.pub", encoding="utf-8") as file:
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


def create_vm():
    """
    Create a VM using a cloud-config file
    """
    subprocess.run("multipass launch jammy --name eseidinger-clouddev --cpus 4 "
                   + "--disk 40G --mem 8G --cloud-init "
                   + f"{config_path}{os.sep}cloud-config.yaml",
                   shell=True, check=True)


if __name__ == "__main__":
    clean_old_config()
    create_ssh_key()
    public_key: str = get_ssh_public_key()
    create_cloud_config(public_key)
    create_vm()
