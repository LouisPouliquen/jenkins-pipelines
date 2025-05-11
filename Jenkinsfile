pipeline {
    agent any

    environment {
        REPO_A = 'https://github.com/LouisPouliquen/grpc'
        REPO_C = 'https://github.com/LouisPouliquen/doxygen-log-parser'
        REPO_C_DIR = 'parser'
    }

    stages {
        stage('Clone RepoA') {
            steps {
                echo "Cloning ${REPO_A}"
                sh 'rm -rf grpc'
                sh 'git clone ${REPO_A} grpc'
            }
        }

        stage('Generate & configure Doxyfile (with WARN_LOGFILE)') {
            steps {
                dir('grpc') {
                    sh '''
                    doxygen -g Doxyfile
                    sed -i 's|^INPUT.*|INPUT = src|' Doxyfile
                    sed -i 's|^GENERATE_LATEX.*|GENERATE_LATEX = NO|' Doxyfile
                    sed -i 's|^GENERATE_HTML.*|GENERATE_HTML = YES|' Doxyfile
                    grep -q '^WARN_LOGFILE' Doxyfile && \
                      sed -i 's|^WARN_LOGFILE.*|WARN_LOGFILE = doxygen.log|' Doxyfile || \
                      echo 'WARN_LOGFILE = doxygen.log' >> Doxyfile
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

        stage('Clone RepoC') {
            steps {
                echo "Cloning parser repo from ${REPO_C}"
                sh 'rm -rf ${REPO_C_DIR}'
                sh 'git clone ${REPO_C} ${REPO_C_DIR}'
            }
        }

        stage('Install dependencies (RepoC)') {
            steps {
                dir("${REPO_C_DIR}") {
                    sh '''
                    if [ -f requirements.txt ]; then
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    fi
                    '''
                }
            }
        }

        stage('Run parser') {
            steps {
                dir("${REPO_C_DIR}") {
                    sh 'python3 parse_warnings.py ../grpc/doxygen.log'
                }
            }
        }

        stage('Archive artifacts') {
            steps {
                sh 'tar czf doc.tar.gz -C grpc/html .'
                archiveArtifacts artifacts: 'doc.tar.gz', fingerprint: true
                archiveArtifacts artifacts: "${REPO_C_DIR}/warnings.csv", fingerprint: true
            }
        }
    }
}