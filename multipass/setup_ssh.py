"""
A script to setup SSH config to access the development VM
"""
import argparse
import os
import subprocess
import json
import platform
import re

system = platform.system()
script_path = os.path.dirname(__file__)

if system == "Windows":
    home = os.environ["HOMEPATH"]
else:
    home = os.environ["HOME"]

ssh_config_template_filename = f"{script_path}{os.sep}templates{os.sep}ssh_config_template"
ssh_config_filename = f"{home}{os.sep}.ssh{os.sep}config"


def get_vm_ip(env_name: str) -> str:
    """
    Get the IP address of the running development VM
    """
    multipass_info = subprocess.run(
        f"multipass info --format json {env_name}",
        shell=True, capture_output=True, check=True)
    multipass_info_object = json.loads(multipass_info.stdout)
    return multipass_info_object["info"][env_name]["ipv4"][0]


def create_ssh_config_snippet(env_name: str, vm_ip: str, user: str) -> str:
    """
    Create SSH config snippet to connect to the development VM
    """
    private_key_filename = f"{script_path}{os.sep}config{os.sep}{env_name}_rsa"
    with open(ssh_config_template_filename, encoding="utf-8") as ssh_config_template_file:
        ssh_config_template = ssh_config_template_file.read()
    return (ssh_config_template.replace("[VMName]", env_name)
            .replace("[Hostname]", vm_ip)
            .replace("[User]", user)
            .replace("[IdentityFile]", private_key_filename).strip(" \r\n"))


def get_clean_ssh_config(env_name: str) -> str:
    """
    Return existing SSH config without host config for the development VM
    """
    if os.path.isfile(ssh_config_filename):
        with open(ssh_config_filename, mode="r", encoding="utf-8") as ssh_config_file:
            ssh_config_file_contents = ssh_config_file.read()
        ssh_config_file_contents = ssh_config_file_contents.replace("\r\n", "\n")
        clean_ssh_config = re.sub(f"Host {env_name}" + r"(?:\n\s+.*)+\n?", "",
                                  ssh_config_file_contents)
        clean_ssh_config = clean_ssh_config.strip()
    else:
        clean_ssh_config = ""
    return clean_ssh_config


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create development VM.')
    parser.add_argument('--env_name', help='the name of the VM to create',
                        default='clouddev', required=False)
    parser.add_argument('--user', help='the name of the user for the VM',
                        default='clouddev', required=False)
    args = parser.parse_args()
    ip = get_vm_ip(args.env_name)
    ssh_config_snippet = create_ssh_config_snippet(args.env_name, ip, args.user)
    old_ssh_config = get_clean_ssh_config(args.env_name)
    if old_ssh_config != "" and not old_ssh_config.endswith("\n"):
        old_ssh_config = old_ssh_config + "\n"
    with open(ssh_config_filename, mode="w", encoding="utf-8") as file:
        file.write(old_ssh_config + ssh_config_snippet)
