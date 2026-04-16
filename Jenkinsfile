pipeline {
    agent any

    environment {
        PRISMA_URL     = "https://asia-south1.cloud.twistlock.com/india-1131958041"
        PRISMA_API_URL = "https://api.ind.prismacloud.io"
    }

    options {
        preserveStashes()
        timestamps()
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Terraform Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/itsbittukumar/terraform-eks.git'

                stash includes: '**/*', name: 'source'
            }
        }

        stage('Checkov Policy Scan') {
            steps {
                withCredentials([
                    string(credentialsId: 'PC_USER', variable: 'pc_user'),
                    string(credentialsId: 'PC_PASSWORD', variable: 'pc_password')
                ]) {
                    script {
                        docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
                            unstash 'source'

                            try {
                                sh '''
                                checkov -d . \
                                  --use-enforcement-rules \
                                  -o cli \
                                  -o junitxml \
                                  --output-file-path console,results.xml \
                                  --bc-api-key ${pc_user}::${pc_password} \
                                  --repo-id itsbittukumar/terraform-eks \
                                  --branch main
                                '''
                                junit skipPublishingChecks: true, testResults: 'results.xml'
                            } catch (err) {
                                junit skipPublishingChecks: true, testResults: 'results.xml'
                                throw err
                            }
                        }
                    }
                }
            }
        }

        stage('Prisma IaC Scan') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'prisma-creds',
                    usernameVariable: 'PRISMA_USER',
                    passwordVariable: 'PRISMA_PASS'
                )]) {
                    sh '''
                    twistcli iac scan \
                      --address $PRISMA_URL \
                      --user $PRISMA_USER \
                      --password $PRISMA_PASS \
                      --details \
                      .
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        success {
            echo "✅ All Security Scans Passed and Terraform Applied Successfully"
        }

        failure {
            echo "❌ Pipeline Failed - Security Scan Failed OR Terraform Failed"
        }
    }
}
