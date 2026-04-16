pipeline {
    agent any

    environment {
        PRISMA_URL = "https://asia-south1.cloud.twistlock.com/india-1131958041"
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
                    url: 'https://github.com/your-repo/terraform-eks.git'
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
            echo "✅ IaC Scan Passed and Terraform Applied Successfully"
        }

        failure {
            echo "❌ Pipeline Failed - Prisma Detected Vulnerability OR Terraform Failed"
        }
    }
}
