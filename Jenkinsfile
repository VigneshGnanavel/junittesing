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
                bat './mvnw clean install'
            }
        }
    
        stage('Upload Test Results to Artifactory') {
            steps {
                script {
                    // Debug output to check directory contents
                    bat 'dir target\\surefire-reports'
                    
                    // Upload test result file
                    bat "jf rt upload -f --url http://172.17.208.1:8082/artifactory/ --access-token %ARTIFACTORY_ACCESS_TOKEN% target/surefire-reports/TEST-calculatorTest.xml results/"
                }
            }
        }
    }
}
