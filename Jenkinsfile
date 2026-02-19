pipeline {
    agent {
        kubernetes {
            inheritFrom 'nodejs'
        }
    }

    environment {
        REGISTRY = 'nexus-nexus3.nexus.svc.cluster.local:8082'
        PROJECT  = 'frontend-demo'
        TAG      = '1.0.0-SNAPSHOT'
    }

    stages {

        stage('Build') {
            steps {
                container('nodejs') {
                    sh "pnpm install"
                    sh "pnpm run build"
                }
            }
        }


        stage('Build Image') {
            when {
                branch 'master'
            }
            steps {
                container('nodejs') {
                    sh "buildah bud --tls-verify=false -t ${REGISTRY}/${PROJECT}:${TAG} -f Dockerfile ."
                }
            }
        }

        stage('Push Image') {
            when {
                branch 'master'
            }
            steps {
                container('nodejs') {
                    withCredentials([usernamePassword(credentialsId: 'nexus-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "buildah login --tls-verify=false -u \$USER -p \$PASS ${REGISTRY}"
                        sh "buildah push --tls-verify=false ${REGISTRY}/${PROJECT}:${TAG}"
                    }
                }
            }
        }

        stage('Cleanup') {
            when {
                branch 'master'
            }
            steps {
                container('nodejs') {
                    sh "buildah rmi ${REGISTRY}/${PROJECT}:${TAG} || true"
                }
            }
        }
    }
}
