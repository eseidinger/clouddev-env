"""
Test if the tools in the development VM have the correct version
"""
import subprocess
import unittest
import re
import os

script_path = os.path.dirname(__file__)
tools_path = f"{script_path}{os.sep}..{os.sep}..{os.sep}tools"
versions_filename = f"{tools_path}{os.sep}versions.sh"


class TestToolVersions(unittest.TestCase):
    """
    Test if the tools in the development VM have the correct version
    """

    def setUp(self):
        """
        Determine expected versions
        """
        self.versions = {}
        with open(versions_filename, encoding='utf-8') as versions_file:
            versions_file_contents = versions_file.read()
            version_lines = versions_file_contents.split('\n')
            for line in version_lines:
                if '=' in line:
                    key, version = line.split('=')
                    self.versions[key] = version.strip('"')

    def test_docker(self):
        """
        Test Docker version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "docker version"',
                                      shell=True, capture_output=True, check=True)
        match = re.search(r'\d+:(\d+\.\d+\.\d+)',
                          self.versions['DOCKER_VERSION'])
        if match is not None:
            version = match.group(1)
        else:
            self.fail("Docker version regex did not match")
        self.assertTrue(version in str(version_info.stdout))

    def test_microk8s(self):
        """
        Test MicroK8s version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "microk8s version"',
                                      shell=True, capture_output=True, check=True)
        match = re.search(
            r'(\d+\.\d+)/', self.versions['MICROK8S_VERSION'])
        if match is not None:
            version = match.group(1)
        else:
            self.fail("MicroK8s version regex did not match")
        self.assertTrue(version in str(version_info.stdout))

    def test_miniconda(self):
        """
        Test miniconda version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "~/miniconda3/bin/conda --version"',
                                      shell=True, capture_output=True, check=True)
        match = re.search(r'[^_]+_(\d+\.\d+\.\d+)',
                          self.versions['MINICONDA_VERSION'])
        if match is not None:
            version = match.group(1)
        else:
            self.fail("Miniconda version regex did not match")
        self.assertTrue(version in str(version_info.stdout))

    def test_ansible(self):
        """
        Test ansible version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "~/miniconda3/bin/pip show ansible"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['ANSIBLE_VERSION'] in str(version_info.stdout))

    def test_golang(self):
        """
        Test Golang version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "/usr/local/go/bin/go version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(self.versions['GOLANG_VERSION']
                        in str(version_info.stdout))

    def test_kind(self):
        """
        Test kind version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "~/go/bin/kind version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(self.versions['KIND_VERSION']
                        in str(version_info.stdout))

    def test_kubectl(self):
        """
        Test kubectl version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "kubectl --client=true version"',
                                      shell=True, capture_output=True, check=True)
        match = re.search(
            r'\d+\.\d+\.\d+', self.versions['KUBECTL_VERSION'])
        if match is not None:
            version = match.group(0)
        else:
            self.fail("Kubectl version regex did not match")
        self.assertTrue(version in str(version_info.stdout))

    def test_helm(self):
        """
        Test Helm version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "helm version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(self.versions['HELM_VERSION']
                        in str(version_info.stdout))

    def test_awscli(self):
        """
        Test AWS CLI version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "aws --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['AWS_CLI_VERSION'] in str(version_info.stdout))

    def test_terraform(self):
        """
        Test Terraform version
        """
        version_info = subprocess.run('ssh eseidinger-clouddev "terraform --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['TERRAFORM_VERSION'] in str(version_info.stdout))


if __name__ == '__main__':
    unittest.main()
