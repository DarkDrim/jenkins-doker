pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
        registry = "drim/jenkins-doker"
        registryCredential = 'dockerhub'
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
         stage('Clone repository') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build docker image') {
            steps {
                script{
                    app = docker.build(registry)
                }
            }
        }

        stage('Push docker image') {
            steps {
                script{
                    docker.withRegistry('', registryCredential) {
                        app.push("latest")
                    }
                }
            }
        }

        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry"
            }
        }

        stage('Deploy to webserver') {
            steps {
                script{
                    docker.withServer('tcp://user@192.168.0.22:2375', 'swarm-certs') {
                        def doc_containers = sh(returnStdout: true, script: 'docker container ps -aq').replaceAll("\n", " ")
                        if (doc_containers) {
                            sh "docker rm -f ${doc_containers}"
                        }
                        app.run('--name test-jenkins -p 8081:80')
                    }
                }
            }
        }
    }
}
