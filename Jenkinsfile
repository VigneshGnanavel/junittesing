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
                bat 'mvn clean compile test'
            }
        }
        
        stage('Git Commit and Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jenkins', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        bat 'git config --global user.name "VigneshGnanavel"'
                        bat 'git config --global user.email "prathvikvignesh@gmail.com"'
                        bat 'git checkout -B results'
                        bat 'git add target/surefire-reports/TEST-calculatorTest.xml'
                        bat 'git commit -m "Adding test results"'
                        bat "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/VigneshGnanavel/junittesing.git results"
                    }
                }
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
                bat 'syft packages dir:. --scope AllLayers -o json > ./java_syft_junit_sbom.json'
            }
        }
        stage('Upload Test Results to Artifactory') {
            steps {
                script {
                    bat 'dir target\\surefire-reports'
                    bat "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} target/surefire-reports/TEST-calculatorTest.xml results/"
                    bat "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} java_syft_junit_sbom.json web-app-artifactory/"
                    bat "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} snyk_junit_report.json web-app-artifactory/"
                }
            }
        }
    }
}
