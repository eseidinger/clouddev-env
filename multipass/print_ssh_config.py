"""
A script to print an SSH config snippet to access the development VM
"""
import argparse
from setup_ssh import get_vm_ip, create_ssh_config_snippet


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create development VM.')
    parser.add_argument('--env_name', help='the name of the VM to create',
                        default='clouddev', required=False)
    parser.add_argument('--user', help='the name of the user for the VM',
                        default='clouddev', required=False)
    args = parser.parse_args()
    ip = get_vm_ip(args.env_name)
    ssh_config_snippet = create_ssh_config_snippet(args.env_name, ip, args.user)
    print(ssh_config_snippet)
