pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['PLAN', 'APPLY', 'DESTROY'],
            description: 'Select Terraform Action'
        )
    }

    environment {
        TF_VAR_FILE = "terraform.tfvars"
        AWS_DEFAULT_REGION = "us-east-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Ladi247/terraform-iis-migration.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform-creds'
                ]]) {
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
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform-creds'
                ]]) {
                    bat 'terraform plan -var-file="%TF_VAR_FILE%" -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'APPLY' }
            }
            steps {

                input message: "Approve Terraform Apply?"

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform-creds'
                ]]) {
                    bat 'terraform apply -auto-approve -var-file="%TF_VAR_FILE%"'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'DESTROY' }
            }
            steps {

                input message: "WARNING: Destroy ALL Infrastructure?"

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform-creds'
                ]]) {
                    bat 'terraform destroy -auto-approve -var-file="%TF_VAR_FILE%"'
                }
            }
        }

    }

    post {
        success {
            echo "Pipeline completed successfully"
        }

        failure {
            echo "Pipeline failed"
        }

        always {
            echo "Cleaning workspace..."
            deleteDir()
        }
    }
}
