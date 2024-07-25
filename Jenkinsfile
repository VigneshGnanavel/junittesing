pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-11.0.23.9-hotspot'
        PATH = "${env.JAVA_HOME}\\bin;${env.PATH}"
    }

    stages {
        stage('Build') {
            steps {
                bat 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Install Snyk CLI') {
            steps {
                bat 'npm install -g snyk'
            }
        }

        stage('Snyk Security Testing') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'snyk_test', variable: 'SNYK_API_TOKEN')]) {
                        bat "snyk auth ${env.SNYK_API_TOKEN}"
                        bat "snyk test --all-projects --json > snyk_junit_report.json"
                    }
                }
            }
        }

        stage('Generate SBOM') {
            steps {
                bat 'syft packages dir:. --scope AllLayers -o json > java_syft_junit_sbom.json'
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
