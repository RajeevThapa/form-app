pipeline {

    agent any

    environment {
        IMG_NAME = 'rajeevmagar/form'   // Username and repo.
        IMG_TAG = "v1.0.${BUILD_NUMBER}"    // Gives build number.
        DOCKERFILE = 'Dockerfile'   // Path to Dockerfile.
        DOCKERHUB_CREDENTIALS = 'docker-hub-credentials'    // Credentials of Dockerhub stored in Jenkins
        K8S_MANIFEST_PATH = 'k8s/deployment.yaml'
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

                    // Commit and push changes to Git repo
                    // sshagent(credentials:['4b2106fc-c96a-489d-b8a7-9dc887caf143']) {
                    //     sh """
                    //         git add ${K8S_MANIFEST_PATH}
                    //         git commit -m "Update image tag in kubernetes manifest | Jenkins pipeline"
                    //         git push git@github.com:RajeevThapa/form-app.git HEAD:main
                    //     """
                    // }

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

        stage('test') {
            steps {
                script {
                    sh "kubectl config view"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Apply the updated Kubernetes manifest to Minikube
                    // sh "kubectl apply -f ${K8S_MANIFEST_PATH}"
                    kubernetesDeploy (configs: 'K8S_MANIFEST_PATH', kubeconfigId: 'acf81900-3757-4df8-aff8-2044af36821f')
                }
            }
        }
    }
}
