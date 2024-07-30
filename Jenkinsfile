pipeline {
    agent any

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('jenkins_jfrog')
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws')
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        MAVEN_HOME = '/usr/share/maven'
        PATH = "${env.JAVA_HOME}/bin:${env.MAVEN_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Workspace') {
            steps {
                script {
                    deleteDir()
                }
            }
        }

        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/VigneshGnanavel/junittesing.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'mvn clean compile'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }

        stage('Generate SBOM') {
            steps {
                script {
                    sh 'syft dir:. --scope all-layers -o json > java_syft_junit_sbom.json'
                }
            }
        }

        stage('Install Snyk CLI') {
            steps {
                script {
                    sh 'npm install -g snyk'
                }
            }
        }

        stage('Snyk Security Testing') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'snyk_test', variable: 'SNYK_API_TOKEN')]) {
                        sh "snyk auth ${env.SNYK_API_TOKEN}"
  
