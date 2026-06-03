pipeline {
    agent { label 'Worker' }

    options {
        timeout(time: 60, unit: 'MINUTES')
    }

    parameters {
        booleanParam(name: 'RUN_ALL',               defaultValue: false, description: 'Run tests for ALL projects regardless of changes')
        booleanParam(name: 'RUN_HOSPITAL',          defaultValue: false, description: 'Force run Hospital Management tests')
        booleanParam(name: 'RUN_BLOG',              defaultValue: false, description: 'Force run Blog Website tests')
        booleanParam(name: 'RUN_NOTES_BACKEND',     defaultValue: false, description: 'Force run Notes App Backend tests')
        booleanParam(name: 'RUN_NOTES_FRONTEND',    defaultValue: false, description: 'Force run Notes App Frontend tests')
        booleanParam(name: 'RUN_SOCIAL_BACKEND',    defaultValue: false, description: 'Force run Social Media Backend tests')
        booleanParam(name: 'RUN_SOCIAL_FRONTEND',   defaultValue: false, description: 'Force run Social Media Frontend tests')
        booleanParam(name: 'RUN_SOCIAL_GO',         defaultValue: false, description: 'Force run Social Media Go microservice tests')
        booleanParam(name: 'RUN_SOCIAL_JAVA',       defaultValue: false, description: 'Force run Social Media Java microservice tests')
        booleanParam(name: 'RUN_BANK_BACKEND',      defaultValue: false, description: 'Force run Bank Manager Backend tests')
        booleanParam(name: 'RUN_BANK_FRONTEND',     defaultValue: false, description: 'Force run Bank Manager Frontend tests')
        booleanParam(name: 'RUN_QUIZ',              defaultValue: false, description: 'Force run Quiz App tests')
        booleanParam(name: 'RUN_API_BACKEND',       defaultValue: false, description: 'Force run API Service Backend tests')
        booleanParam(name: 'RUN_API_FRONTEND',      defaultValue: false, description: 'Force run API Service Frontend tests')
        booleanParam(name: 'RUN_DOC_BACKEND',       defaultValue: false, description: 'Force run Document Intelligence Backend tests')
        booleanParam(name: 'RUN_DOC_FRONTEND',      defaultValue: false, description: 'Force run Document Intelligence Frontend tests')
        booleanParam(name: 'RUN_VIDEO_BACKEND',     defaultValue: false, description: 'Force run Video Uploader tests')
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
                    def diff = sh(
                        script: "git diff --name-only HEAD~1 HEAD",
                        returnStdout: true
                    ).trim()

                    echo "Changed files:\n${diff}"

                    def anyParamSet = params.RUN_HOSPITAL        || params.RUN_BLOG           ||
                                     params.RUN_NOTES_BACKEND    || params.RUN_NOTES_FRONTEND  ||
                                     params.RUN_SOCIAL_BACKEND   || params.RUN_SOCIAL_FRONTEND ||
                                     params.RUN_SOCIAL_GO        || params.RUN_SOCIAL_JAVA     ||
                                     params.RUN_BANK_BACKEND     || params.RUN_BANK_FRONTEND   ||
                                     params.RUN_QUIZ             || params.RUN_API_BACKEND      ||
                                     params.RUN_API_FRONTEND     || params.RUN_DOC_BACKEND     ||
                                     params.RUN_DOC_FRONTEND     || params.RUN_VIDEO_BACKEND

                    def runAll  = params.RUN_ALL
                    def useDiff = !runAll && !anyParamSet

                    env.BUILD_SOCIAL_FRONTEND  = (runAll || params.RUN_SOCIAL_FRONTEND  || (useDiff && diff.contains('Social Media App/apps/frontend')))           ? 'true' : 'false'
                    env.BUILD_SOCIAL_BACKEND   = (runAll || params.RUN_SOCIAL_BACKEND   || (useDiff && diff.contains('Social Media App/apps/backend')))            ? 'true' : 'false'
                    env.BUILD_SOCIAL_GO        = (runAll || params.RUN_SOCIAL_GO        || (useDiff && diff.contains('Social Media App/apps/microservice-go')))    ? 'true' : 'false'
                    env.BUILD_SOCIAL_JAVA      = (runAll || params.RUN_SOCIAL_JAVA      || (useDiff && diff.contains('Social Media App/apps/microservice-java')))  ? 'true' : 'false'
                    env.BUILD_BANK_FRONTEND    = (runAll || params.RUN_BANK_FRONTEND    || (useDiff && diff.contains('Bank Manager/frontend')))                    ? 'true' : 'false'
                    env.BUILD_BANK_BACKEND     = (runAll || params.RUN_BANK_BACKEND     || (useDiff && diff.contains('Bank Manager/backend')))                     ? 'true' : 'false'
                    env.BUILD_QUIZ             = (runAll || params.RUN_QUIZ             || (useDiff && diff.contains('Quiz App')))                                 ? 'true' : 'false'
                    env.BUILD_NOTES_FRONTEND   = (runAll || params.RUN_NOTES_FRONTEND   || (useDiff && diff.contains('Notes App/frontend')))                       ? 'true' : 'false'
                    env.BUILD_NOTES_BACKEND    = (runAll || params.RUN_NOTES_BACKEND    || (useDiff && diff.contains('Notes App/backend')))                        ? 'true' : 'false'
                    env.BUILD_BLOG             = (runAll || params.RUN_BLOG             || (useDiff && diff.contains('Blog Website')))                             ? 'true' : 'false'
                    env.BUILD_HOSPITAL         = (runAll || params.RUN_HOSPITAL         || (useDiff && diff.contains('hospital_management')))                      ? 'true' : 'false'
                    env.BUILD_API_BACKEND      = (runAll || params.RUN_API_BACKEND      || (useDiff && diff.contains('API Service/backend')))                      ? 'true' : 'false'
                    env.BUILD_API_FRONTEND     = (runAll || params.RUN_API_FRONTEND     || (useDiff && diff.contains('API Service/frontend')))                     ? 'true' : 'false'
                    env.BUILD_DOC_BACKEND      = (runAll || params.RUN_DOC_BACKEND      || (useDiff && diff.contains('Document Intelligence Platform/backend')))   ? 'true' : 'false'
                    env.BUILD_DOC_FRONTEND     = (runAll || params.RUN_DOC_FRONTEND     || (useDiff && diff.contains('Document Intelligence Platform/frontend')))  ? 'true' : 'false'
                    env.BUILD_VIDEO_BACKEND    = (runAll || params.RUN_VIDEO_BACKEND    || (useDiff && diff.contains('Video Uploader')))                           ? 'true' : 'false'

                    echo """
                        BUILD_SOCIAL_FRONTEND  = ${env.BUILD_SOCIAL_FRONTEND}
                        BUILD_SOCIAL_BACKEND   = ${env.BUILD_SOCIAL_BACKEND}
                        BUILD_SOCIAL_GO        = ${env.BUILD_SOCIAL_GO}
                        BUILD_SOCIAL_JAVA      = ${env.BUILD_SOCIAL_JAVA}
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
                        BUILD_DOC_FRONTEND     = ${env.BUILD_DOC_FRONTEND}
                        BUILD_VIDEO_BACKEND    = ${env.BUILD_VIDEO_BACKEND}
                    """
                }
            }
        }

        // ── 3a. Test Group 1: Django/Python (lightweight, fast) ───
        stage('Test - Django Apps') {
            parallel {

                stage('Hospital Management') {
                    when { expression { env.BUILD_HOSPITAL == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/hospital_management/Dockerfile.test" \
                                -t hospital:test \
                                "${PROJECTS_ROOT}/hospital_management"
                            docker run --rm hospital:test
                        """
                    }
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
                                -e DJANGO_SETTINGS_MODULE=blogsite.test_settings \
                                blog:test
                        """
                    }
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
                                -e DJANGO_SETTINGS_MODULE=notes_app.test_settings \
                                notes-backend:test
                        """
                    }
                }

                stage('Social Media App - Backend') {
                    when { expression { env.BUILD_SOCIAL_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Social Media App/apps/backend/Dockerfile.test" \
                                -t social-backend:test \
                                "${PROJECTS_ROOT}/Social Media App/apps/backend"
                            docker run --rm \
                                -e DJANGO_SETTINGS_MODULE=social_media.test_settings \
                                -e SECRET_KEY=test-secret-key-for-ci \
                                -e DEBUG=True \
                                social-backend:test
                        """
                    }
                }

                stage('Document Intelligence - Backend') {
                    when { expression { env.BUILD_DOC_BACKEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Document Intelligence Platform/backend/document_backend/Dockerfile.test" \
                                -t doc-backend:test \
                                "${PROJECTS_ROOT}/Document Intelligence Platform/backend/document_backend"
                            docker run --rm \
                                -e DJANGO_SETTINGS_MODULE=document_backend.test_settings \
                                -e GEMINI_API_KEY=test-key \
                                -e OLLAMA_HOST=localhost \
                                doc-backend:test
                        """
                    }
                }

            }
        }

        // ── 3b. Test Group 2: Node/React (medium) ─────────────────
        stage('Test - Frontend & Node Apps') {
            parallel {

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
                }

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
                }

                stage('Document Intelligence - Frontend') {
                    when { expression { env.BUILD_DOC_FRONTEND == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Document Intelligence Platform/frontend/document_frontend/Dockerfile.test" \
                                -t doc-frontend:test \
                                "${PROJECTS_ROOT}/Document Intelligence Platform/frontend/document_frontend"
                            docker run --rm doc-frontend:test
                        """
                    }
                }

            }
        }

        // ── 3c. Test Group 3: Java/Maven (heavy, isolated) ────────
        stage('Test - Java Apps') {
            parallel {

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
                }

                stage('Social Media App - Java Microservice') {
                    when { expression { env.BUILD_SOCIAL_JAVA == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Social Media App/apps/microservice-java/Dockerfile.test" \
                                -t social-java:test \
                                "${PROJECTS_ROOT}/Social Media App/apps/microservice-java"
                            docker run --rm \
                                -v /home/saisakthi/.m2:/root/.m2 \
                                social-java:test
                        """
                    }
                }

            }
        }

        // ── 3d. Test Group 4: Go (fast, self-contained) ───────────
        stage('Test - Go Apps') {
            parallel {

                stage('Social Media App - Go Microservice') {
                    when { expression { env.BUILD_SOCIAL_GO == 'true' } }
                    steps {
                        sh """
                            docker build \
                                -f "${PROJECTS_ROOT}/Social Media App/apps/microservice-go/Dockerfile.test" \
                                -t social-go:test \
                                "${PROJECTS_ROOT}/Social Media App/apps/microservice-go"
                            docker run --rm social-go:test
                        """
                    }
                }

            }
        }

        // ── 4. Deploy via Terraform ───────────────────────────────
        stage('Deploy') {
            when { branch 'Coding-Project' }
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'ssh-deploy-key',
                    keyFileVariable: 'SSH_KEY',
                    usernameVariable: 'SSH_USER'
                )]) {
                    sh '''
                        cp "$SSH_KEY" /tmp/deploy_key
                        chmod 600 /tmp/deploy_key
                        ssh -i /tmp/deploy_key \
                            -o StrictHostKeyChecking=no \
                            -o PasswordAuthentication=no \
                            saisakthi@192.168.31.227 \
                            'cd "/home/saisakthi/Coding-Project/Projects/Finished Projects/Docker/Terraform/environments/dev" && terraform apply -auto-approve'
                        rm -f /tmp/deploy_key
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'All changed projects tested and deployed successfully!'
        }
        failure {
            echo 'Pipeline failed — Terraform was NOT touched.'
        }
    }
}