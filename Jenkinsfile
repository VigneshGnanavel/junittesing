pipeline {
  agent { label 'linux' }
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    CI = true
    ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
  }
  stages {
    stage('Start Artifactory') {
      steps {
        script {
          sh 'docker-compose -f /path/to/docker-compose.yml up -d'
        }
      }
    }
    stage('Build') {
      steps {
        sh './mvnw clean install'
      }
    }
    stage('Install JFrog CLI') {
      steps {
        sh 'curl -fL https://getcli.jfrog.io | sh'
        sh 'mv jfrog /usr/local/bin/jfrog'
      }
    }
    stage('Upload to Artifactory') {
      steps {
        sh """
          jfrog rt upload --url http://localhost:8081/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/surefire-reports/TEST-calculatorTest.xml results/
        """
      }
    }
    stage('Stop Artifactory') {
      steps {
        script {
          sh 'docker-compose -f /path/to/docker-compose.yml down'
        }
      }
    }
  }
}
