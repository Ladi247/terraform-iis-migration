pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['PLAN', 'APPLY', 'DESTROY'],
            description: 'Choose Terraform action'
        )
    }

    environment {
        TF_VAR_FILE = "terraform.tfvars"
        AWS_DEFAULT_REGION = "us-east-1"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Ladi247/terraform-iis-migration.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'PLAN' }
            }
            steps {
                bat 'terraform plan -var-file="%TF_VAR_FILE%" -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'APPLY' }
            }
            steps {
                input message: 'Approve Terraform Apply?'
                bat 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'DESTROY' }
            }
            steps {
                input message: 'Confirm destroy ALL infrastructure?'
                bat 'terraform destroy -auto-approve -var-file="%TF_VAR_FILE%"'
            }
        }
    }
}
