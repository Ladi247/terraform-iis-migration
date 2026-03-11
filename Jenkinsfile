pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/Ladi247/terraform-iis-migration.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var-file="dev.tfvars"'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?"
                sh 'terraform apply -auto-approve -var-file="dev.tfvars"'
            }
        }

    }
}
