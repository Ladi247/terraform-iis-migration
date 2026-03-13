stage('Terraform Action') {
    steps {
        script {
            withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                             usernameVariable: 'AWS_ACCESS_KEY_ID',
                                             passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                if (params.ACTION == 'plan') {

                    echo "Running Terraform Plan..."
                    bat "terraform plan -var-file=\"%TF_VAR_FILE%\" -out=tfplan"

                } else if (params.ACTION == 'apply') {

                    echo "Running Terraform Apply..."
                    input message: "Approve Terraform Apply?"

                    bat "terraform plan -var-file=\"%TF_VAR_FILE%\" -out=tfplan"
                    bat "terraform apply -auto-approve tfplan"

                } else if (params.ACTION == 'destroy') {

                    echo "Running Terraform Destroy..."
                    input message: "Approve Terraform Destroy?"

                    bat "terraform destroy -var-file=\"%TF_VAR_FILE%\" -auto-approve"

                } else {

                    error "Unknown ACTION: ${params.ACTION}"

                }
            }
        }
    }
}
