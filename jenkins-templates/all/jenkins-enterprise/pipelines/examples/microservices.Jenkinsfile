@Library(['global-libs', 'team-a']) _

def services = [
    'auth-service': [
        path: './services/auth',
        buildCommand: 'mvn clean package',
        testCommand: 'mvn test',
        dockerFile: './services/auth/Dockerfile'
    ],
    'user-service': [
        path: './services/user',
        buildCommand: 'mvn clean package',
        testCommand: 'mvn test',
        dockerFile: './services/user/Dockerfile'
    ],
    'notification-service': [
        path: './services/notification',
        buildCommand: 'npm ci && npm run build',
        testCommand: 'npm test',
        dockerFile: './services/notification/Dockerfile'
    ]
]

def buildResults = [:]

pipeline {
    agent none
    
    options {
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
        preserveStashes(buildCount: 5)
    }
    
    environment {
        DOCKER_REGISTRY = credentials('docker-registry-url')
        DOCKER_CREDS = credentials('docker-registry-credentials')
        ENVIRONMENT = determineEnvironment()
    }
    
    stages {
        stage('Validate Changes') {
            agent {
                kubernetes {
                    yaml libraryResource('pod-templates/jenkins-agent-tools.yaml')
                    defaultContainer 'tools'
                }
            }
            steps {
                script {
                    // Determine which services have changed
                    services.each { service, config ->
                        def serviceChanged = hasServiceChanged(service, config.path)
                        buildResults[service] = [
                            changed: serviceChanged,
                            build: false,
                            test: false,
                            security: false,
                            docker: false,
                            deploy: false
                        ]
                        
                        echo "Service ${service} changed: ${serviceChanged}"
                    }
                }
            }
        }
        
        stage('Build & Test Services') {
            steps {
                script {
                    def parallelStages = [:]
                    
                    services.each { service, config ->
                        if (buildResults[service].changed) {
                            parallelStages["Build ${service}"] = {
                                stage("Build ${service}") {
                                    node {
                                        checkout scm
                                        dir(config.path) {
                                            sh "${config.buildCommand}"
                                            buildResults[service].build = true
                                        }
                                    }
                                }
                                
                                if (buildResults[service].build) {
                                    stage("Test ${service}") {
                                        node {
                                            dir(config.path) {
                                                try {
                                                    sh "${config.testCommand}"
                                                    junit '**/target/surefire-reports/*.xml'
                                                    buildResults[service].test = true
                                                } catch (Exception e) {
                                                    echo "Tests failed for ${service}: ${e.message}"
                                                    buildResults[service].test = false
                                                    throw e
                                                }
                                            }
                                        }
                                    }
                                    
                                    stage("Security Scan ${service}") {
                                        node {
                                            dir(config.path) {
                                                securityScanner(serviceType: getServiceType(service))
                                                buildResults[service].security = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    parallel parallelStages
                }
            }
        }
        
        stage('Build Docker Images') {
            agent {
                kubernetes {
                    yaml libraryResource('pod-templates/jenkins-agent-docker.yaml')
                    defaultContainer 'docker'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', 
                                   usernameVariable: 'DOCKER_USER', 
                                   passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login ${DOCKER_REGISTRY} -u ${DOCKER_USER} --password-stdin"
                    }
                    
                    services.each { service, config ->
                        if (buildResults[service].changed && buildResults[service].test && buildResults[service].security) {
                            def imageTag = "${DOCKER_REGISTRY}/${service}:${env.BUILD_NUMBER}"
                            sh "docker build -t ${imageTag} -f ${config.dockerFile} ."
                            sh "docker push ${imageTag}"
                            buildResults[service].docker = true
                        }
                    }
                }
            }
        }
        
        stage('Deploy to Environment') {
            agent {
                kubernetes {
                    yaml libraryResource('pod-templates/jenkins-agent-kubectl.yaml')
                    defaultContainer 'kubectl'
                }
            }
            steps {
                script {
                    services.each { service, config ->
                        if (buildResults[service].docker) {
                            def imageTag = "${DOCKER_REGISTRY}/${service}:${env.BUILD_NUMBER}"
                            
                            if (service.startsWith('auth')) {
                                teamADeploy(
                                    service: service,
                                    imageTag: imageTag,
                                    environment: ENVIRONMENT,
                                    rollback: false
                                )
                            } else {
                                // Sử dụng hàm deploy chung
                                deployMicroservice(
                                    serviceName: service,
                                    imageTag: imageTag,
                                    namespace: ENVIRONMENT,
                                    replicas: getReplicaCount(ENVIRONMENT)
                                )
                            }
                            
                            buildResults[service].deploy = true
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Gửi thông báo tổng hợp
                def summary = "Build Summary:\n"
                services.each { service, config ->
                    if (buildResults[service].changed) {
                        summary += "- ${service}: "
                        summary += buildResults[service].deploy ? "✅ Deployed" : "❌ Failed"
                        summary += "\n"
                    } else {
                        summary += "- ${service}: ⏭️ Skipped (no changes)\n"
                    }
                }
                
                echo summary
                
                if (currentBuild.resultIsBetterOrEqualTo('SUCCESS')) {
                    slackSend(color: 'good', message: "✅ Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n${summary}")
                } else {
                    slackSend(color: 'danger', message: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n${summary}")
                }
            }
        }
    }
}

// Helper functions
def hasServiceChanged(String service, String path) {
    if (env.CHANGE_ID) {
        def changes = sh(script: "git diff --name-only origin/${env.CHANGE_TARGET} HEAD | grep -E '^${path}/'", returnStatus: true)
        return changes == 0
    }
    return true
}

def getServiceType(String service) {
    if (service.endsWith('-service')) {
        def type = service.split('-')[0]
        switch(type) {
            case 'auth': return 'java'
            case 'user': return 'java'
            case 'notification': return 'nodejs'
            default: return 'generic'
        }
    }
    return 'generic'
}

def determineEnvironment() {
    if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
        return 'production'
    } else if (env.BRANCH_NAME.startsWith('release/')) {
        return 'staging'
    }
    return 'development'
}

def getReplicaCount(String env) {
    switch(env) {
        case 'production': return 3
        case 'staging': return 2
        default: return 1
    }
}

def deployMicroservice(Map config) {
    echo "Deploying ${config.serviceName} to ${config.namespace} with image ${config.imageTag}"
    
    // Load deployment template from shared library
    def deployYaml = libraryResource "kubernetes/deployment-template.yaml"
    deployYaml = deployYaml
        .replace('{{SERVICE_NAME}}', config.serviceName)
        .replace('{{IMAGE}}', config.imageTag)
        .replace('{{REPLICAS}}', config.replicas.toString())
    
    writeFile file: "deployment.yaml", text: deployYaml
    
    // Apply the deployment
    sh "kubectl apply -f deployment.yaml -n ${config.namespace}"
    sh "kubectl rollout status deployment/${config.serviceName} -n ${config.namespace}"
}
