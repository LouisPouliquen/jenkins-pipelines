pipeline {
    agent any

    environment {
        REPO_A = 'https://github.com/LouisPouliquen/grpc'
    }

    stages {
        stage('Clone repo-a') {
            steps {
                echo "Cloning ${REPO_A}"
                sh 'rm -rf grpc'
                sh 'git clone ${REPO_A} grpc'
            }
        }

        stage('Generate and configure Doxygen file') {
            steps {
                dir('grpc') {
                    sh '''
                    doxygen -g Doxyfile
                    sed -i 's|^INPUT.*|INPUT = src|' Doxyfile
                    sed -i 's|^GENERATE_LATEX.*|GENERATE_LATEX = NO|' Doxyfile
                    sed -i 's|^GENERATE_HTML.*|GENERATE_HTML = YES|' Doxyfile
                    '''
                }
            }
        }

        stage('Run Doxygen') {
            steps {
                dir('grpc') {
                    sh 'doxygen Doxyfile'
                }
            }
        }

        stage('Archive generated documentation') {
            steps {
                sh 'tar czf doc.tar.gz -C grpc/html .'
                archiveArtifacts artifacts: 'doc.tar.gz', fingerprint: true
            }
        }
    }
}
