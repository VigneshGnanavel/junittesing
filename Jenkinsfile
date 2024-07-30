pipeline {
    agent any

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('jenkins_jfrog')
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

        stage('Upload Test Results to Artifactory') {
            steps {
                script {
                    sh 'ls -la target/surefire-reports'
                    sh "jf rt upload --url http://35.226.41.135:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} target/surefire-reports/TEST-calculatorTest.xml jt-junit/"
                    sh "jf rt upload --url http://35.226.41.135:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} java_syft_junit_sbom.json jt-junit/"
                }
            }
        }
    }
}
