"""
A script to print an SSH config snippet to access the development VM
"""
import argparse
from setup_ssh import get_vm_ip, create_ssh_config_snippet


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create development VM.')
    parser.add_argument('vm_name', help='the name of the VM to create')
    args = parser.parse_args()
    ip = get_vm_ip(args.vm_name)
    ssh_config_snippet = create_ssh_config_snippet(args.vm_name, ip)
    print(ssh_config_snippet)
