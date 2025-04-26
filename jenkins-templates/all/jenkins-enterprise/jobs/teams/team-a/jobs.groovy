// Team A job definitions

// Define repositories and their respective pipelines
def repositories = [
    [name: 'auth-service', pipeline: 'java-app.Jenkinsfile', folder: 'microservices'],
    [name: 'user-service', pipeline: 'java-app.Jenkinsfile', folder: 'microservices'],
    [name: 'api-gateway', pipeline: 'java-app.Jenkinsfile', folder: 'microservices'],
    [name: 'frontend-app', pipeline: 'nodejs-app.Jenkinsfile', folder: 'frontend']
]

// Create subfolders in TeamA
folder('TeamA/microservices') {
    description('Microservices projects maintained by Team A')
}

folder('TeamA/frontend') {
    description('Frontend applications maintained by Team A')
}

folder('TeamA/deployment') {
    description('Deployment jobs for Team A')
}

// Create multibranch pipeline jobs for each repository
repositories.each { repo ->
    multibranchPipelineJob("TeamA/${repo.folder}/${repo.name}") {
        description("Pipeline for ${repo.name}")
        branchSources {
            git {
                id("${repo.name}-id")
                remote("https://github.com/company/${repo.name}.git")
                credentialsId('github-credentials')
                includes('main release/* feature/* hotfix/*')
                excludes('wip/*')
            }
        }
        
        orphanedItemStrategy {
            discardOldItems {
                numToKeep(20)
                daysToKeep(30)
            }
        }
        
        factory {
            workflowBranchProjectFactory {
                scriptPath("pipelines/templates/${repo.pipeline}")
            }
        }
        
        triggers {
            periodicFolderTrigger {
                interval('1h')
            }
        }
    }
}

// Create deployment pipeline for entire application stack
pipelineJob('TeamA/deployment/deploy-stack') {
    description('Deploy the entire application stack')
    
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/company/deployment-configs.git')
                        credentials('github-credentials')
                    }
                    branch('*/main')
                }
            }
            scriptPath('pipelines/team-a-deployment.Jenkinsfile')
        }
    }
    
    properties {
        disableConcurrentBuilds()
        buildDiscarder {
            strategy {
                logRotator {
                    numToKeepStr('10')
                    daysToKeepStr('30')
                }
            }
        }
        pipelineTriggers {
            triggers {
                cron('@midnight')
            }
        }
        parameters {
            choiceParam('ENVIRONMENT', ['dev', 'staging', 'production'], 'Environment to deploy to')
            booleanParam('RUN_DB_MIGRATIONS', false, 'Run database migrations')
            booleanParam('SKIP_TESTS', false, 'Skip tests during deployment')
        }
    }
}

// Create maintenance jobs
pipelineJob('TeamA/maintenance/cleanup') {
    description('Cleanup old resources')
    
    definition {
        cps {
            script('''
                pipeline {
                    agent {
                        label 'built-in'
                    }
                    stages {
                        stage('Cleanup Docker Images') {
                            steps {
                                echo 'Cleaning up old Docker images'
                                // Add cleanup script here
                            }
                        }
                        stage('Cleanup DB Snapshots') {
                            steps {
                                echo 'Cleaning up old database snapshots'
                                // Add cleanup script here
                            }
                        }
                    }
                }
            '''.stripIndent())
            sandbox(true)
        }
    }
    
    triggers {
        cron('0 0 * * 0') // Run weekly on Sundays
    }
}
