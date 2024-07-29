pipeline {
    agent any

    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('jenkins_jfrog')
        AWS_ACCESS_KEY_ID = credentials('jenkins_aws')
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        MAVEN_HOME = '/usr/share/maven'  // Update this path if Maven is installed elsewhere
        PATH = "${env.JAVA_HOME}/bin:${env.MAVEN_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/VigneshGnanavel/junittesing.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Run Maven build
                    sh 'mvn clean compile'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run Maven test
                    sh 'mvn test'
                }
            }
        }

        stage('Install Snyk CLI') {
            steps {
                script {
                    // Install Snyk CLI
                    sh 'curl https://static.snyk.io/cli/latest/snyk-linux -o snyk'
                    sh 'chmod +x ./snyk'
                    sh 'mv ./snyk /usr/local/bin/'
                }
            }
        }

        stage('Snyk Security Testing') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'Jenkins_snyk', variable: 'SNYK_API_TOKEN')]) {
                        sh "snyk auth ${env.SNYK_API_TOKEN}"
                        sh "snyk test --all-projects --json > snyk_junit_report.json"
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
