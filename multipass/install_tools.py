"""
A script to install tools on the development VM using SSH
"""
import os
import subprocess

script_path = os.path.dirname(__file__)
tool_script_path = f"{script_path}{os.sep}..{os.sep}tools"

if __name__ == "__main__":
    subprocess.run('ssh eseidinger-clouddev "mkdir -p ~/install"',
                   shell=True, check=True)
    subprocess.run(f"scp {tool_script_path}{os.sep}* "
                   + "eseidinger-clouddev:~/install/", shell=True, check=True)
    subprocess.run('ssh eseidinger-clouddev "bash ~/install/install.sh clouddev"',
                   shell=True, check=True)
