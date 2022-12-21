"""
A script to print an SSH config snippet to access the development VM
"""
from setup_ssh import get_vm_ip, create_ssh_config_snippet


if __name__ == "__main__":
    ip = get_vm_ip()
    ssh_config_snippet = create_ssh_config_snippet(ip)
    print(ssh_config_snippet)
