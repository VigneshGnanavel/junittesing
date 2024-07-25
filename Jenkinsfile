pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('jenkins_jfrog')
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-11.0.23.9-hotspot'
        PATH = "${env.JAVA_HOME}\\bin;${env.PATH}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/VigneshGnanavel/junittesing.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("calculatorproject:latest")
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    def PORT = 8089
                    def DOCKER_IMAGE_NAME = "calculatorproject"
                    def DOCKER_IMAGE_TAG = "latest"
                    bat "docker run -d -p ${PORT}:${PORT} --name junitdemotesting ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Install Snyk CLI') {
            steps {
                bat 'curl https://static.snyk.io/cli/latest/snyk-win.exe -o snyk.exe'
            }
        }

        stage('Snyk Security Testing') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'jenkins_snyk', variable: 'SNYK_API_TOKEN')]) {
                        bat "snyk auth ${env.SNYK_API_TOKEN}"
                        bat "snyk test --all-projects --json > snyk_junit_report.json"
                    }
                }
            }
        }

        stage('Generate SBOM') {
            steps {
                bat 'syft packages dir:. --scope all-layers -o json > java_syft_junit_sbom.json'
            }
        }

        stage('Upload Test Results to Artifactory') {
            steps {
                script {
                    bat 'dir target\\surefire-reports'
                    bat "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} target\\surefire-reports\\TEST-calculatorTest.xml results/"
                    bat "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} java_syft_junit_sbom.json web-app-artifactory/"
                    bat "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} snyk_junit_report.json web-app-artifactory/"
                }
            }
        }
    }
}
