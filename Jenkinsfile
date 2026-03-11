pipeline {
    agent any

    environment {
        TF_VAR_file = "dev.tfvars"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Ladi247/terraform-iis-migration.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan -var-file="%TF_VAR_file%"'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve Terraform Apply?'
                bat 'terraform apply -auto-approve -var-file="%TF_VAR_file%"'
            }
        }
    }
}
