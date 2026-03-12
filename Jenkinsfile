// Jenkinsfile for Terraform with Plan, Apply, and Destroy

pipeline {
    agent any

    // Parameter to choose action
    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
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
                echo "Checking out code..."
                git branch: 'main', url: 'https://github.com/Ladi247/terraform-iis-migration.git', credentialsId: 'aws-creds'
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform configuration..."
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    echo "Selected action: ${params.ACTION}"
                    withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                     usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                     passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        if (params.ACTION == 'plan') {
                            echo "Running terraform plan..."
                            bat 'terraform plan -var-file="%TF_VAR_FILE%" -out=tfplan'
                        } else if (params.ACTION == 'apply') {
                            echo "Applying Terraform plan..."
                            input message: 'Approve Terraform Apply?'
                            bat 'terraform apply -auto-approve tfplan'
                        } else if (params.ACTION == 'destroy') {
                            echo "Destroying Terraform-managed infrastructure..."
                            input message: 'Approve Terraform Destroy?'
                            bat 'terraform destroy -auto-approve -var-file="%TF_VAR_FILE%"'
                        } else {
                            error "Unknown action: ${params.ACTION}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            deleteDir()
        }
        success {
            echo "Terraform ${params.ACTION} completed successfully!"
        }
        failure {
            echo "Terraform ${params.ACTION} failed. Check logs."
        }
    }
}
