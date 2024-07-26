pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('Jenkins_jfrog')
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws')
        JAVA_HOME = '/usr/lib/jvm/java-11-openjdk-amd64'
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
                    sh 'docker build -t calculatorproject:latest .'
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker run --name junitdemotesting -d calculatorproject:latest'
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
                    withCredentials([string(credentialsId: 'Jenkins_snyk', variable: 'SNYK_API_TOKEN')]) {
                        sh "./snyk auth ${env.SNYK_API_TOKEN}"
                        sh "./snyk test --all-projects --json > snyk_junit_report.json"
                    }
                }
            }
        }

        stage('Generate SBOM') {
            steps {
                sh 'syft dir:. --scope all-layers -o json > java_syft_junit_sbom.json'
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
                    sh "jf rt upload --url http://localhost:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} target/surefire-reports/TEST-calculatorTest.xml jt-junit/"
                    sh "jf rt upload --url http://localhost:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} java_syft_junit_sbom.json jt-junit/"
                    sh "jf rt upload --url http://localhost:8082/artifactory/ --access-token ${env.ARTIFACTORY_ACCESS_TOKEN} snyk_junit_report.json jt-junit/"
                }
            }
        }
    }
}
