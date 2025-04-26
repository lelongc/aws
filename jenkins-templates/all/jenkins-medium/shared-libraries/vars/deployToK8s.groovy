#!/usr/bin/env groovy

def call(Map config) {
    def environment = config.env
    def image = config.image
    
    echo "Deploying to ${environment} environment with image ${image}"
    
    // Prepare Kubernetes manifests
    sh "mkdir -p k8s-manifests"
    
    // Load deployment template and replace placeholders
    def deploymentYaml = libraryResource "templates/deployment.yaml"
    deploymentYaml = deploymentYaml
        .replace('{{ENVIRONMENT}}', environment)
        .replace('{{IMAGE}}', image)
        .replace('{{APP_NAME}}', env.APP_NAME)
    
    writeFile file: "k8s-manifests/deployment.yaml", text: deploymentYaml
    
    // Apply Kubernetes manifests
    withCredentials([file(credentialsId: "${environment}-kubeconfig", variable: 'KUBECONFIG')]) {
        sh "kubectl apply -f k8s-manifests/ --namespace=${environment}"
        sh "kubectl rollout status deployment/${env.APP_NAME} --namespace=${environment}"
    }
    
    echo "Deployment to ${environment} completed successfully"
}
