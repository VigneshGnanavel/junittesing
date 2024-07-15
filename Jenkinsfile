pipeline {
    agent any
  
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
  
    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-11.0.23.9-hotspot'
        PATH = "${JAVA_HOME}\\bin;${PATH}"
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
                    bat 'git config --global user.name "VigneshGnanavel"'
                    bat 'git config --global user.email "prathvikvignesh@gmail.com"'
                    
                    bat 'git checkout -B results'
                    bat 'git add target/surefire-reports/TEST-calculatorTest.xml'
                    bat 'git commit -m "Initial commit"'
                    bat 'git push origin results'
                }
            }
        }
    
        stage('Upload Test Results to Artifactory') {
            steps {
                script {
                    bat 'dir target\\surefire-reports'
                    bat "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/surefire-reports/TEST-calculatorTest.xml results/"
                }
            }
        }
    }
}
