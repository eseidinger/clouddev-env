def imageSha = ''

pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: cloud-tools-image
spec:
  containers:
    - name: docker
      image: docker:23.0.1
      command:
        - cat
      tty: true
      volumeMounts:
        - name: certs
          mountPath: /certs
      env:
        - name: DOCKER_TLS_CERTDIR
          value: /certs
        - name: DOCKER_HOST
          value: "tcp://localhost:2376"
        - name: DOCKER_TLS_VERIFY
          value: 1
        - name: DOCKER_CERT_PATH
          value: /certs/client
    - name: cosign
      image: bitnami/cosign:2.0.0
      command:
        - cat
      tty: true
    - name: docker-daemon
      image: docker:23.0.1-dind
      securityContext:
        privileged: true
      volumeMounts:
        - name: certs
          mountPath: /certs
      env:
        - name: DOCKER_TLS_CERTDIR
          value: /certs
  volumes:
    - name: certs
      emptyDir: {}
        '''
        }
    }
    stages {
        stage('Build image') {
            steps {
                container('docker') {
                    sh 'docker build -t cloud-tools ./tools/ -f image/Dockerfile'
                }
            }
        }
        stage('Test image') {
            steps {
                container('docker') {
                    sh 'docker compose up --exit-code-from cloud-test'
                }
            }
        }
        stage('Publish image') {
            when {
                buildingTag()
            }
            steps {
                container('docker') {
                    withCredentials([usernamePassword(credentialsId: 'harbor', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'docker login harbor.eseidinger.de/public/ -u $USERNAME -p $PASSWORD'
                        sh 'docker tag cloud-tools harbor.eseidinger.de/public/cloud-tools:latest'
                        sh 'docker tag harbor.eseidinger.de/public/cloud-tools:latest harbor.eseidinger.de/public/cloud-tools:$TAG_NAME'
                        script {
                          imageSha = sh (script: 'docker push harbor.eseidinger.de/public/cloud-tools:latest', returnStdout: true).
                              split("\n").reverse()[1].split(" ")[2]
                        }
                        sh 'docker push harbor.eseidinger.de/public/cloud-tools:$TAG_NAME'
                    }
                }
            }
        }
        stage('Sign image') {
            when {
                buildingTag()
            }
            steps {
                container('cosign') {
                    withCredentials([
                        file(credentialsId: 'cosign-key', variable: 'COSIGN_KEY'),
                        string(credentialsId: 'cosign-key-pass', variable: 'COSIGN_PASSWORD')
                    ]) {
                            sh "cosign sign -y --key \${COSIGN_KEY} harbor.eseidinger.de/public/cloud-tools@${imageSha}"
                    }
                }
            }
        }
    }
}
