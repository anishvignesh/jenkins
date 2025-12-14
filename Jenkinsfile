pipeline {
    agent any

    environment {
        HEALTH_URL = "http://localhost/"

        MAX_RETRIES = "3"
        SLEEP_BETWEEN = "5"
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

    
