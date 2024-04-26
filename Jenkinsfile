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
      image: docker:26.1.0
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
    - name: docker-daemon
      image: docker:26.1.0-dind
      securityContext:
        privileged: true
      volumeMounts:
        - name: certs
          mountPath: /certs
      env:
        - name: DOCKER_TLS_CERTDIR
          value: /certs
      args:
        - "--mtu=500"
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
                    sh 'docker build --no-cache -t cloud-tools -f image/Dockerfile ./tools/'
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
                        sh 'docker push harbor.eseidinger.de/public/cloud-tools:latest'
                        sh 'docker push harbor.eseidinger.de/public/cloud-tools:$TAG_NAME'
                    }
                }
            }
        }
    }
}
