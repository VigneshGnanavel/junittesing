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
    
        stage('Upload to Artifactory') {
            steps {
                bat 'jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/surefire-reports/TEST-calculatorTest.xml results/'
            }
        }
    }
}
