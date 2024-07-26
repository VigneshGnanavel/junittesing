pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('Jenkins_jfrog_aws')
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws_acess')
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64'  // Adjust to your JDK path if needed
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/VigneshGnanavel/junittesing.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("calculatorproject:latest")
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    def DOCKER_IMAGE_NAME = "calculatorproject"
                    def DOCKER_IMAGE_TAG = "latest"
                    sh "docker run --name junitdemotesting ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Install Snyk CLI') {
            steps {
                sh 'curl -sSLo snyk https://static.snyk.io/cli/latest/snyk-linux && chmod +x snyk'
            }
        }

        stage('Snyk Security Testing') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'Jenkins_snyk_aws', variable: 'SNYK_API_TOKEN')]) {
                        sh "./snyk auth ${env.SNYK_API_TOKEN}"
                        sh "./snyk test --all-projects --json > snyk_junit_report.json"
                    }
                }
            }
        }

        stage('Generate SBOM') {
            steps {
                sh 'syft packages dir:. --scope all-layers -o json > java_syft_junit_sbom.json'
            }
        }
        stage('Upload Results and .jar File to S3') {
            steps {
                script {
                    sh 'aws s3 cp target/surefire-reports s3://jenkinstrialdemos3/results/ --recursive'
                    sh 'aws s3 cp target/calculatorproject.jar s3://jenkinstrialdemos3/jars/YoutubeAutomatedTesting-0.0.1-SNAPSHOT.jar'
                }
            }
        }

        stage('Upload Test Results to Artifactory') {
            steps {
                script {
                    sh 'ls -la target/surefire-reports'
                    sh "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} target/surefire-reports/TEST-calculatorTest.xml jt-junit/"
                    sh "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} java_syft_junit_sbom.json jt-junit/"
                    sh "jf rt upload --url http://172.17.208.1:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} snyk_junit_report.json jt-junit/"
                }
            }
        }
    }
}
