"""
A script to install tools on the development VM using SSH
"""
import argparse
import os
import subprocess

script_path = os.path.dirname(__file__)
tool_script_path = f"{script_path}{os.sep}..{os.sep}tools"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Create development VM.')
    parser.add_argument('--vm_name', help='the name of the VM to create',
                        default='eseidinger-clouddev', required=False)
    args = parser.parse_args()
    subprocess.run(f'ssh {args.vm_name} "mkdir -p ~/install"',
                   shell=True, check=True)
    subprocess.run(f"scp {tool_script_path}{os.sep}* "
                   + f"{args.vm_name}:~/install/", shell=True, check=True)
    subprocess.run(f'ssh {args.vm_name} "bash ~/install/install.sh clouddev"',
                   shell=True, check=True)
