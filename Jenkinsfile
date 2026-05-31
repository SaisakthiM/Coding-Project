pipeline {
    agent { label 'Worker' }

    stages {

        // ── 1. Get the code ──────────────────────
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ── 2. Detect what changed ───────────────
        stage('Detect Changes') {
            steps {
                script {
                    env.CHANGED = sh(
                        script: "git diff --name-only HEAD~1 HEAD | cut -d/ -f1 | sort -u",
                        returnStdout: true
                    ).trim()
                    echo "Changed: ${env.CHANGED}"
                }
            }
        }

        // ── 3. Per project (repeat this pattern) ─
        stage('API Service') {
            when {
                expression { env.CHANGED.contains('API Service') }
            }
            stages {
                stage('Test') {
                    steps {
                        dir('API Service') {
                            sh 'docker build -t myapp-test --target test .'
                            sh 'docker run --rm myapp-test'
                        }
                    }
                }
                stage('Build') {
                    steps {
                        dir('your-folder-name') {
                            sh 'docker build -t myapp:${BUILD_NUMBER} .'
                        }
                    }
                }
            }
        }

    }

    // ── 4. Always cleanup ────────────────────────
    post {
        always {
            sh 'docker image prune -f'
        }
        success { echo '✅ Done!' }
        failure { echo '❌ Failed!' }
    }
}