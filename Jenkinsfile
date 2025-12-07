pipeline {
    agent any

    environment {
        HEALTH_URL = "http://3.108.234.45/"
        MAX_RETRIES = "3"
        SLEEP_BETWEEN = "5"
    }

    triggers {
        // Every 10 minutes — change to */1 * * * * for every 1 minute
        cron('H/10 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Health Check & Auto Restart') {
            steps {
                script {
                    sh """
                        chmod +x scripts/check_nginx.sh
                        scripts/check_nginx.sh "${HEALTH_URL}" ${MAX_RETRIES} ${SLEEP_BETWEEN}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Nginx check completed successfully."
        }
        failure {
            echo "Nginx is DOWN even after restart attempts!"
        }
    }
}
