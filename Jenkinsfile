pipeline {
    agent any
  
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
  
    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('jenkins_jfrog')
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.4.7-hotspot'
        MAVEN_HOME = 'C:\\Program Files\\apache-maven-3.9.8'
        PATH = "${env.JAVA_HOME}\\bin;${env.MAVEN_HOME}\\bin;${env.PATH}"
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

        stage('Snyk Security Testing') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'jenkins_snyk', variable: 'SNYK_API_TOKEN')]) {
                        bat "snyk auth ${env.SNYK_API_TOKEN}"
      
