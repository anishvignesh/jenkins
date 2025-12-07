pipeline {
    agent any

    environment {
        HEALTH_URL = "http://3.108.234.45/"
        MAX_RETRIES = "3"
        SLEEP_BETWEEN = "5"
    }

    triggers {
        // every 10 minutes (change to */1 * * * * for every 1 min)
        cron('H/10 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Health Check Script') {
            steps {
                script {
                    sh """
                        chmod +x check_nginx.sh
                        ./check_nginx.sh "${HEALTH_URL}" ${MAX_RETRIES} ${SLEEP_BETWEEN}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Nginx OK."
        }
        failure {
            echo "Nginx is DOWN even after restart attempts."
        }
    }
}
