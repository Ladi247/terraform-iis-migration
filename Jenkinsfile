pipeline {
    agent any

    environment {
        // Change this to whichever variables file you want to use
        TF_VAR_FILE = "terraform.tfvars"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/Ladi247/terraform-iis-migration.git'
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                bat 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                bat 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Planning Terraform with variables file: %TF_VAR_FILE%"
                bat "terraform plan -var-file=\"%TF_VAR_FILE%\" -out=tfplan"
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Do you want to apply this Terraform plan?'
                echo "Applying Terraform plan with variables file: %TF_VAR_FILE%"
                bat "terraform apply -auto-approve tfplan"
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            deleteDir()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
