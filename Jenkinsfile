pipeline {
    agent any

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('jenkins_jfrog_gcp')
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
         stage('Snyk Testing') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'jenkins_snyk', variable: 'SNYK_API_TOKEN')]) {
                        sh "export SNYK_TOKEN=${env.SNYK_API_TOKEN}"
                        sh "snyk auth ${env.SNYK_API_TOKEN}"
                        sh "snyk test --all-projects --json > snyk_junit_report.json"
                    }
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
                    sh 'ls -l /var/lib/jenkins/workspace/junittesting/target/surefire-reports/'
                    sh 'jf rt upload --url http://34.132.36.185:8082/artifactory/ --access-token $ARTIFACTORY_ACCESS_TOKEN /var/lib/jenkins/workspace/junittesting/target/surefire-reports/TEST-CalculatorTest.xml jt/'
                    sh 'jf rt upload --url http://34.132.36.185:8082/artifactory/ --access-token $ARTIFACTORY_ACCESS_TOKEN /var/lib/jenkins/workspace/junittesting/java_syft_junit_sbom.json jt/'
                    sh 'jf rt upload --url http://34.132.36.185/:8082/artifactory/ --access-token $ARTIFACTORY_ACCESS_TOKEN /var/lib/jenkins/workspace/junittesting/snyk_junit_report.json jt/'
                }
            }
        }
    }
}
