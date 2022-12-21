"""
A script to setup SSH config to access the development VM
"""
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

private_key_filename = f"{script_path}{os.sep}config{os.sep}eseidinger-clouddev_rsa"
ssh_config_template_filename = f"{script_path}{os.sep}templates{os.sep}ssh_config_template"
ssh_config_filename = f"{home}{os.sep}.ssh{os.sep}config"


def get_vm_ip() -> str:
    """
    Get the IP address of the running development VM
    """
    multipass_info = subprocess.run(
        "multipass info --format json eseidinger-clouddev",
        shell=True, capture_output=True, check=True)
    multipass_info_object = json.loads(multipass_info.stdout)
    return multipass_info_object["info"]["eseidinger-clouddev"]["ipv4"][0]


def create_ssh_config_snippet(vm_ip: str) -> str:
    """
    Create SSH config snippet to connect to the development VM
    """
    with open(ssh_config_template_filename, encoding="utf-8") as ssh_config_template_file:
        ssh_config_template = ssh_config_template_file.read()
    return (ssh_config_template.replace("[Hostname]", vm_ip)
            .replace("[IdentityFile]", private_key_filename).strip(" \r\n"))


def get_clean_ssh_config() -> str:
    """
    Return existing SSH config without host config for the development VM
    """
    if os.path.isfile(ssh_config_filename):
        with open(ssh_config_filename, mode="r", encoding="utf-8") as ssh_config_file:
            ssh_config_file_contents = ssh_config_file.read()
        clean_ssh_config = re.sub(r"Host eseidinger-clouddev(?:\n\s+.*)+", "",
                                  ssh_config_file_contents)
    else:
        clean_ssh_config = ""
    return clean_ssh_config


if __name__ == "__main__":
    ip = get_vm_ip()
    ssh_config_snippet = create_ssh_config_snippet(ip)
    old_ssh_config = get_clean_ssh_config()
    with open(ssh_config_filename, mode="w", encoding="utf-8") as file:
        file.write(old_ssh_config + ssh_config_snippet)
