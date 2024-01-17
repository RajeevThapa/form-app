pipeline {

    agent any

    environment {
        IMG_NAME = 'rajeevmagar/form'   // Username and repo.
        IMG_TAG = "v1.0.${BUILD_NUMBER}"    // Gives build number.
        DOCKERFILE = 'Dockerfile'   // Path to Dockerfile.
        DOCKERHUB_CREDENTIALS = 'docker-hub-credentials'    // Credentials of Dockerhub stored in Jenkins
        K8S_MANIFEST_PATH = 'k8s/deployment.yaml'
        GIT_SSH_COMMAND = 'ssh -o StrictHostKeyChecking=no'
        ANSIBLE_HOSTS = 'servers'
        KUBE_CONFIG_CREDENTIALS = credentials('0f802d42-0ac0-4164-b8f4-98b5b40e3dd4')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', 
                    credentialsId: '4b2106fc-c96a-489d-b8a7-9dc887caf143', 
                    url: 'https://github.com/RajeevThapa/form-app'
            }
        }

        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build("${IMG_NAME}:${IMG_TAG}", "--file ${DOCKERFILE} .")
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKERHUB_CREDENTIALS}") {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Update kubernetes Manifest') {
            steps {
                script {
                    // Update the Kubernetes manifest with the new image version
                    sh """
                        cat ${K8S_MANIFEST_PATH}
                        sed -i 's|image: ${IMG_NAME}:.*\$|image: ${IMG_NAME}:${IMG_TAG}|' ${K8S_MANIFEST_PATH}
                        cat ${K8S_MANIFEST_PATH}
                    """
                    
                    sshagent(credentials:['4b2106fc-c96a-489d-b8a7-9dc887caf143']) {
                        sh """
                            git add ${K8S_MANIFEST_PATH}
                            git commit -m 'Update image tag in Kubernetes manifest | Jenkins Pipeline'
                            git push git@github.com:RajeevThapa/form-app.git HEAD:main
                        """
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Use KUBE_CONFIG_CREDENTIALS in your kubectl commands
                    withCredentials([kubeconfig(credentialsId: KUBE_CONFIG_CREDENTIALS, pathVariable: 'KUBECONFIG')]) {
                        // sh "kubectl config use-context your-kube-context"
                        // sh "kubectl apply -f k8s/deployment.yaml -n my-app-namespace"
                    // Apply the updated Kubernetes manifest to Minikube
                    // sh "kubectl apply -f ${K8S_MANIFEST_PATH}"
                    // kubernetesDeploy (configs: 'K8S_MANIFEST_PATH', kubeconfigId: 'acf81900-3757-4df8-aff8-2044af36821f')
                    sh "kubectl apply -f ${K8S_MANIFEST_PATH} -n form-app-namespace"
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                script {
                    // Use Ansible to deploy and configure application
                    sh 'ansible-playbook -i $ANSIBLE_HOSTS ansible/deploy.yml'
                }
            }
        }     
    }
}
