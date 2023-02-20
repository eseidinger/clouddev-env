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

        self.vm_name = os.getenv('VM_NAME', 'eseidinger-clouddev')
        if self.vm_name == "localhost":
            self.command_prefix = "bash -c"
        else:
            self.command_prefix = f"ssh {self.vm_name}"

    def test_docker(self):
        """
        Test Docker version
        """
        version_info = subprocess.run(f'{self.command_prefix} "docker version"',
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
        version_info = subprocess.run(f'{self.command_prefix} "microk8s version"',
                                      shell=True, capture_output=True, check=True)
        match = re.search(
            r'(\d+\.\d+)/', self.versions['MICROK8S_VERSION'])
        if match is not None:
            version = match.group(1)
        else:
            self.fail("MicroK8s version regex did not match")
        self.assertTrue(version in str(version_info.stdout))

    def test_conda(self):
        """
        Test conda version
        """
        version_info = subprocess.run(f'{self.command_prefix} "~/miniconda3/bin/conda --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['CONDA_VERSION'] in str(version_info.stdout))

    def test_python(self):
        """
        Test Python version
        """
        version_info = subprocess.run(f'{self.command_prefix} "~/miniconda3/bin/python --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['PYTHON_VERSION'] in str(version_info.stdout))

    def test_ansible(self):
        """
        Test ansible version
        """
        version_info = subprocess.run(f'{self.command_prefix} "~/miniconda3/bin/pip show ansible"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['ANSIBLE_VERSION'] in str(version_info.stdout))

    def test_golang(self):
        """
        Test Golang version
        """
        version_info = subprocess.run(f'{self.command_prefix} "~/tools/go/bin/go version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(self.versions['GOLANG_VERSION']
                        in str(version_info.stdout))

    def test_kind(self):
        """
        Test kind version
        """
        version_info = subprocess.run(f'{self.command_prefix} "~/go/bin/kind version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(self.versions['KIND_VERSION']
                        in str(version_info.stdout))

    def test_kubectl(self):
        """
        Test kubectl version
        """
        version_info = subprocess.run(f'{self.command_prefix} "kubectl --client=true version"',
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
        version_info = subprocess.run(f'{self.command_prefix} "~/tools/helm/helm version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(self.versions['HELM_VERSION']
                        in str(version_info.stdout))

    def test_awscli(self):
        """
        Test AWS CLI version
        """
        version_info = subprocess.run(f'{self.command_prefix} "aws --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['AWS_CLI_VERSION'] in str(version_info.stdout))

    def test_terraform(self):
        """
        Test Terraform version
        """
        version_info = subprocess.run(f'{self.command_prefix} '
                                      + '"~/tools/terraform/terraform --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['TERRAFORM_VERSION'] in str(version_info.stdout))

    def test_nvm(self):
        """
        Test nvm version
        """
        version_info = subprocess.run(f'{self.command_prefix} ". ~/.nvm/nvm.sh && nvm --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['NVM_VERSION'] in str(version_info.stdout))

    def test_node(self):
        """
        Test Node version
        """
        version_info = subprocess.run(
            f'{self.command_prefix} '
            + f'"~/.nvm/versions/node/v{self.versions["NODE_VERSION"]}/bin/node --version"',
            shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['NODE_VERSION'] in str(version_info.stdout))

    def test_npm(self):
        """
        Test npm version
        """
        version_info = subprocess.run(
            f'{self.command_prefix} '
            + f'"~/.nvm/versions/node/v{self.versions["NODE_VERSION"]}/bin/node '
            + f'~/.nvm/versions/node/v{self.versions["NODE_VERSION"]}/bin/npm --version"',
            shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['NPM_VERSION'] in str(version_info.stdout))

    def test_k9s(self):
        """
        Test K9s version
        """
        version_info = subprocess.run(
            f'{self.command_prefix} '
            + '"~/tools/k9s/k9s version"',
            shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['K9S_VERSION'] in str(version_info.stdout))

    def test_java(self):
        """
        Test Java version
        """
        version_info = subprocess.run(f'{self.command_prefix} '
                                      + '"~/.sdkman/candidates/java/current/bin/java --version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['JAVA_VERSION'] in str(version_info.stdout))

    def test_kotlin(self):
        """
        Test Kotlin version
        """
        version_info = subprocess.run(f'{self.command_prefix} '
                                      + '"JAVA_HOME=~/.sdkman/candidates/java/current/ '
                                      + '~/.sdkman/candidates/kotlin/current/bin/kotlin -version"',
                                      shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['KOTLIN_VERSION'] in str(version_info.stdout))

    def test_gradle(self):
        """
        Test Gradle version
        """
        version_info = subprocess.run(
            f'{self.command_prefix} '
            + '"JAVA_HOME=~/.sdkman/candidates/java/current/ '
            + '~/.sdkman/candidates/gradle/current/bin/gradle --version"',
            shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['GRADLE_VERSION'] in str(version_info.stdout))

    def test_trivy(self):
        """
        Test Trivy version
        """
        version_info = subprocess.run(
            f'{self.command_prefix} '
            + '"trivy --version"',
            shell=True, capture_output=True, check=True)
        self.assertTrue(
            self.versions['TRIVY_VERSION'] in str(version_info.stdout))

if __name__ == '__main__':
    unittest.main()
