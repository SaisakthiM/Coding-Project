pipeline {
    agent { label 'Worker' }

    options {
        timeout(time: 45, unit: 'MINUTES')
    }

    environment {
        PROJECTS_ROOT = "${WORKSPACE}/Projects/Finished Projects/Docker/Terraform/projects"
        TERRAFORM_DIR = "${WORKSPACE}/Projects/Finished Projects/Docker/Terraform/environments/dev"
        REGISTRY      = "saisakthi.qzz.io"
    }

    stages {

        // ── 1. Checkout ───────────────────────────────────────────
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ── 2. Detect Changes ─────────────────────────────────────
        stage('Detect Changes') {
            steps {
                script {
                    def base = env.GIT_PREVIOUS_SUCCESSFUL_COMMIT ?: 'HEAD~1'
                    def diff = sh(
                        script: "git diff --name-only ${base} HEAD",
                        returnStdout: true
                    ).trim()

                    echo "Changed files:\n${diff}"

                    env.BUILD_SOCIAL_FRONTEND = diff.contains('Social Media App/apps/frontend') ? 'true' : 'false'
                    env.BUILD_SOCIAL_BACKEND  = diff.contains('Social Media App/apps/backend')  ? 'true' : 'false'
                    env.BUILD_BANK_FRONTEND   = diff.contains('Bank Manager/frontend')           ? 'true' : 'false'
                    env.BUILD_BANK_BACKEND    = diff.contains('Bank Manager/backend')            ? 'true' : 'false'
                    env.BUILD_QUIZ            = diff.contains('Quiz App')                        ? 'true' : 'false'
                    env.BUILD_NOTES_FRONTEND  = diff.contains('Notes App/frontend')              ? 'true' : 'false'
                    env.BUILD_NOTES_BACKEND   = diff.contains('Notes App/backend')               ? 'true' : 'false'
                    env.BUILD_BLOG            = diff.contains('Blog Website')                    ? 'true' : 'false'
                    env.BUILD_HOSPITAL        = diff.contains('hospital_management')             ? 'true' : 'false'
                    env.BUILD_API_BACKEND     = diff.contains('API Service/backend')             ? 'true' : 'false'
                    env.BUILD_API_FRONTEND    = diff.contains('API Service/frontend')            ? 'true' : 'false'
                    env.BUILD_DOC_BACKEND     = diff.contains('Document Intelligence Platform')  ? 'true' : 'false'
                    env.BUILD_VIDEO_BACKEND   = diff.contains('Video Uploader')                  ? 'true' : 'false'

                    echo """
                        BUILD_SOCIAL_FRONTEND  = ${env.BUILD_SOCIAL_FRONTEND}
                        BUILD_SOCIAL_BACKEND   = ${env.BUILD_SOCIAL_BACKEND}
                        BUILD_BANK_FRONTEND    = ${env.BUILD_BANK_FRONTEND}
                        BUILD_BANK_BACKEND     = ${env.BUILD_BANK_BACKEND}
                        BUILD_QUIZ             = ${env.BUILD_QUIZ}
                        BUILD_NOTES_FRONTEND   = ${env.BUILD_NOTES_FRONTEND}
                        BUILD_NOTES_BACKEND    = ${env.BUILD_NOTES_BACKEND}
                        BUILD_BLOG             = ${env.BUILD_BLOG}
                        BUILD_HOSPITAL         = ${env.BUILD_HOSPITAL}
                        BUILD_API_BACKEND      = ${env.BUILD_API_BACKEND}
                        BUILD_API_FRONTEND     = ${env.BUILD_API_FRONTEND}
                        BUILD_DOC_BACKEND      = ${env.BUILD_DOC_BACKEND}
                        BUILD_VIDEO_BACKEND    = ${env.BUILD_VIDEO_BACKEND}
                    """
                }
            }
        }

        // ── 3. Test (only changed apps) ───────────────────────────
        stage('Test') {
            parallel {

                stage('Social Media App - Frontend') {
                    when { expression { env.BUILD_SOCIAL_FRONTEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Social Media App/apps/frontend/Dockerfile.test" \
                                -t social-frontend:test \
                                "${PROJECTS_ROOT}/Social Media App/apps/frontend"
                            docker run --rm social-frontend:test
                        """
                    }
                    post { always { sh 'docker rmi social-frontend:test || true' } }
                }

                stage('Social Media App - Backend') {
                    when { expression { env.BUILD_SOCIAL_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Social Media App/apps/backend/Dockerfile.test" \
                                -t social-backend:test \
                                "${PROJECTS_ROOT}/Social Media App/apps/backend"
                            docker run --rm social-backend:test
                        """
                    }
                    post { always { sh 'docker rmi social-backend:test || true' } }
                }

                stage('Bank Manager - Frontend') {
                    when { expression { env.BUILD_BANK_FRONTEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Bank Manager/frontend/Dockerfile.test" \
                                -t bank-frontend:test \
                                "${PROJECTS_ROOT}/Bank Manager/frontend"
                            docker run --rm bank-frontend:test
                        """
                    }
                    post { always { sh 'docker rmi bank-frontend:test || true' } }
                }

                stage('Bank Manager - Backend') {
                    when { expression { env.BUILD_BANK_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Bank Manager/backend/bank_management/Dockerfile.test" \
                                -t bank-backend:test \
                                "${PROJECTS_ROOT}/Bank Manager/backend/bank_management"
                            docker run --rm \
                                -v /home/saisakthi/.m2:/root/.m2 \
                                bank-backend:test
                        """
                    }
                    post { always { sh 'docker rmi bank-backend:test || true' } }
                }

                stage('Quiz App') {
                    when { expression { env.BUILD_QUIZ == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Quiz App/quiz-app/Dockerfile.test" \
                                -t quiz-app:test \
                                "${PROJECTS_ROOT}/Quiz App/quiz-app"
                            docker run --rm quiz-app:test
                        """
                    }
                    post { always { sh 'docker rmi quiz-app:test || true' } }
                }

                stage('Notes App - Frontend') {
                    when { expression { env.BUILD_NOTES_FRONTEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Notes App/frontend/notes_app_frontend/Dockerfile.test" \
                                -t notes-frontend:test \
                                "${PROJECTS_ROOT}/Notes App/frontend/notes_app_frontend"
                            docker run --rm notes-frontend:test
                        """
                    }
                    post { always { sh 'docker rmi notes-frontend:test || true' } }
                }

                stage('Notes App - Backend') {
                    when { expression { env.BUILD_NOTES_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Notes App/backend/Dockerfile.test" \
                                -t notes-backend:test \
                                "${PROJECTS_ROOT}/Notes App/backend"
                            docker run --rm \
                                -e DJANGO_SETTINGS_MODULE=notes_app.settings \
                                notes-backend:test
                        """
                    }
                    post { always { sh 'docker rmi notes-backend:test || true' } }
                }

                stage('Blog Website') {
                    when { expression { env.BUILD_BLOG == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Blog Website/Dockerfile.test" \
                                -t blog:test \
                                "${PROJECTS_ROOT}/Blog Website"
                            docker run --rm \
                                -e DJANGO_SETTINGS_MODULE=blogsite.settings \
                                blog:test
                        """
                    }
                    post { always { sh 'docker rmi blog:test || true' } }
                }

                stage('Hospital Management') {
                    when { expression { env.BUILD_HOSPITAL == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/hospital_management/Dockerfile.test" \
                                -t hospital:test \
                                "${PROJECTS_ROOT}/hospital_management"
                            docker run --rm \
                                -e DJANGO_SETTINGS_MODULE=hospital_management.settings \
                                hospital:test
                        """
                    }
                    post { always { sh 'docker rmi hospital:test || true' } }
                }

                stage('API Service - Backend') {
                    when { expression { env.BUILD_API_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/API Service/backend/Dockerfile.test" \
                                -t api-backend:test \
                                "${PROJECTS_ROOT}/API Service/backend"
                            docker run --rm api-backend:test
                        """
                    }
                    post { always { sh 'docker rmi api-backend:test || true' } }
                }

                stage('API Service - Frontend') {
                    when { expression { env.BUILD_API_FRONTEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/API Service/frontend/api-service/Dockerfile.test" \
                                -t api-frontend:test \
                                "${PROJECTS_ROOT}/API Service/frontend/api-service"
                            docker run --rm api-frontend:test
                        """
                    }
                    post { always { sh 'docker rmi api-frontend:test || true' } }
                }

                stage('Document Intelligence - Backend') {
                    when { expression { env.BUILD_DOC_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Document Intelligence Platform/backend/document_backend/Dockerfile.test" \
                                -t doc-backend:test \
                                "${PROJECTS_ROOT}/Document Intelligence Platform/backend/document_backend"
                            docker run --rm doc-backend:test
                        """
                    }
                    post { always { sh 'docker rmi doc-backend:test || true' } }
                }

                stage('Video Uploader - Backend') {
                    when { expression { env.BUILD_VIDEO_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Video Uploader/Main/backend/Dockerfile.test" \
                                -t video-backend:test \
                                "${PROJECTS_ROOT}/Video Uploader/Main/backend"
                            docker run --rm \
                                -v /home/saisakthi/.m2:/root/.m2 \
                                video-backend:test
                        """
                    }
                    post { always { sh 'docker rmi video-backend:test || true' } }
                }
            }
        }

        // ── 4. Deploy via Terraform (only on Coding-Project branch) ──
        stage('Deploy') {
            when { branch 'Coding-Project' }
            steps {
                sh """
                    cd "${TERRAFORM_DIR}"
                    terraform apply -auto-approve
                """
            }
        }

    }

    post {
        success {
            echo '✅ All changed projects tested and deployed successfully!'
        }
        failure {
            echo '❌ Pipeline failed — check the logs above. Terraform was NOT touched.'
        }
        cleanup {
            sh 'docker image prune -f || true'
        }
    }
}