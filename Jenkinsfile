def contexts = ['x86-build', 'arm-build']

def transformToCreateContextStep(context) {
    return {
        stage ("Create ${context} context") {
            container("docker-${context}") {
                sshagent(credentials: ["${context}_ssh-key"]) {
                    sh """
                        [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                        ssh-keyscan -t rsa ${context}.eseidinger.de >> ~/.ssh/known_hosts
                        docker context create ${context} --docker host=ssh://root@${context}.eseidinger.de
                    """
                }
            }
        }
    }
}

def transformToBuildStep(context) {
    return {
        stage ("Build ${context}") {
            container("docker-${context}") {
                sshagent(credentials: ["${context}_ssh-key"]) {
                    sh """
                        docker context use ${context}
                        docker build --no-cache -t cloud-tools -f image/Dockerfile ./tools/
                    """
                }
            }
        }
    }
}

def transformToTestStep(context) {
    return {
        stage ("Test ${context}") {
            container("docker-${context}") {
                sshagent(credentials: ["${context}_ssh-key"]) {
                    sh """
                        docker context use ${context}
                        docker compose up --exit-code-from cloud-test
                    """
                }
            }
        }
    }
}

def transformToPublishStep(context) {
    return {
        stage ("Publish ${context}") {
            container("docker-${context}") {
                sshagent(credentials: ["${context}_ssh-key"]) {
                    withCredentials([usernamePassword(credentialsId: 'harbor', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                            docker context use ${context}
                            docker login harbor.eseidinger.de/public/ -u $USERNAME -p $PASSWORD
                            docker tag cloud-tools harbor.eseidinger.de/public/cloud-tools:latest-${context}
                            docker push harbor.eseidinger.de/public/cloud-tools:latest-${context}
                            docker tag harbor.eseidinger.de/public/cloud-tools:latest-${context} harbor.eseidinger.de/public/cloud-tools:$TAG_NAME-${context}
                            docker push harbor.eseidinger.de/public/cloud-tools:$TAG_NAME-${context}
                        """
                    }
                }
            }
        }
    }
}

def createContextSteps = [:]
def buildSteps = [:]
def testSteps = [:]
def publishSteps = [:]

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
    - name: docker-x86-build
      image: docker:27.2.0
      command:
        - cat
      tty: true
    - name: docker-arm-build
      image: docker:27.2.0
      command:
        - cat
      tty: true
        '''
        }
    }
    stages {
        stage('Create Docker contexts') {
            steps {
                script {
                    contexts.each { context ->
                        createContextSteps["Create context ${context}"] = transformToCreateContextStep(context)
                    }                
                    parallel createContextSteps
                }
            }
        }
        stage('Build image') {
            steps {
                script {
                    contexts.each { context ->
                        buildSteps["Build ${context}"] = transformToBuildStep(context)
                    }
                    parallel buildSteps
                }
            }
        }
        stage('Test image') {
            steps {
                script {
                    contexts.each { context ->
                        testSteps["Test ${context}"] = transformToTestStep(context)
                    }
                    parallel testSteps
                }
            }
        }
        stage('Publish image') {
            when {
                buildingTag()
            }
            steps {
                script {
                    contexts.each { context ->
                        publishSteps["Publish ${context}"] = transformToPublishStep(context)
                    }
                    parallel publishSteps
                }
            }
        }
        stage('Create manifest') {
            when {
                buildingTag()
            }
            steps {
                container("docker-x86-build") {
                    sshagent(credentials: ["x86-build_ssh-key"]) {
                        withCredentials([usernamePassword(credentialsId: 'harbor', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh """
                                docker context use x86-build
                                docker login harbor.eseidinger.de/public/ -u $USERNAME -p $PASSWORD
                                docker manifest create harbor.eseidinger.de/public/cloud-tools:$TAG_NAME harbor.eseidinger.de/public/cloud-tools:$TAG_NAME-x86-build harbor.eseidinger.de/public/cloud-tools:$TAG_NAME-arm-build
                                docker manifest push harbor.eseidinger.de/public/cloud-tools:$TAG_NAME
                                docker manifest create harbor.eseidinger.de/public/cloud-tools:latest harbor.eseidinger.de/public/cloud-tools:$TAG_NAME-x86-build harbor.eseidinger.de/public/cloud-tools:$TAG_NAME-arm-build
                                docker manifest push harbor.eseidinger.de/public/cloud-tools:latest
                            """
                        }
                    }
                }
            }
        }
    }
}
