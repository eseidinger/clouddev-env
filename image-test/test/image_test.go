package test

import (
	"os"
	"regexp"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/stretchr/testify/assert"
)

func TestVersions(t *testing.T) {
	m := make(map[string]string)
	dat, _ := os.ReadFile("../../tools/versions.sh")
	version_array := strings.Split(string(dat), "\n")
	for i := 0; i < len(version_array); i++ {
		key_value := strings.Split(version_array[i], "=")
		if len(key_value) == 2 {
			m[key_value[0]] = strings.Trim(key_value[1], "\"")
		}
	}
	tag := "cloud-tools"

	t.Run("CONDA_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"conda", "--version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["CONDA_VERSION"]), output)
	})
	t.Run("PYTHON_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"python", "--version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["PYTHON_VERSION"]), output)
	})
	t.Run("GOLANG_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"go", "version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["GOLANG_VERSION"]), output)
	})
	t.Run("NODE_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"node", "--version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["NODE_VERSION"]), output)
	})
	t.Run("NPM_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"npm", "--version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["NPM_VERSION"]), output)
	})
	t.Run("JAVA_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"java", "-version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["JAVA_VERSION"]), output)
	})
	t.Run("KOTLIN_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"kotlin", "-version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["KOTLIN_VERSION"]), output)
	})
	t.Run("GRADLE_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"gradle", "--version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["GRADLE_VERSION"]), output)
	})
	t.Run("DOCKER_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"docker", "version"},
			Remove:  true,
			User:    "root",
			Volumes: []string{"/var/run/docker.sock:/var/run/docker.sock"}}
		output := docker.Run(t, tag, opts)
		version_string := regexp.MustCompile(`^\d+:(\d+\.\d+\.\d+)`)
		docker_version := version_string.FindStringSubmatch(m["DOCKER_VERSION"])[1]
		assert.True(t, strings.Contains(output, docker_version), output)
	})
	t.Run("TRIVY_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"trivy", "--version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["TRIVY_VERSION"]), output)
	})
	t.Run("COSIGN_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"cosign", "version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["COSIGN_VERSION"]), output)
	})
	t.Run("KIND_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"kind", "version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["KIND_VERSION"]), output)
	})
	t.Run("KUBECTL_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"kubectl", "version", "--client=true"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		version_string := regexp.MustCompile(`^\d+\.\d+\.\d+`)
		kubectl_version := version_string.FindString(m["KUBECTL_VERSION"])
		assert.True(t, strings.Contains(output, kubectl_version), output)
	})
	t.Run("HELM_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"helm", "version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["HELM_VERSION"]), output)
	})
	t.Run("ISTIO_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"istioctl", "version", "--remote=false"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["ISTIO_VERSION"]), output)
	})
	t.Run("AWS_CLI_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"aws", "--version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["AWS_CLI_VERSION"]), output)
	})
	t.Run("TERRAFORM_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"terraform", "version"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, m["TERRAFORM_VERSION"]), output)
	})
	t.Run("ANSIBLE_VERSION", func(t *testing.T) {
		opts := &docker.RunOptions{Command: []string{"pip", "show", "ansible"},
			Remove: true}
		output := docker.Run(t, tag, opts)
		assert.True(t, strings.Contains(output, "Version: "+m["ANSIBLE_VERSION"]), output)
	})
}
