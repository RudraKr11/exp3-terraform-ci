pipeline {
    agent any

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('TFLint') {
            steps {
                sh 'tflint --init'
                sh 'tflint'
            }
        }

        stage('Security Scan') {
            steps {
                sh 'tfsec .'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Approve Terraform deployment?', ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
        }
    }
}