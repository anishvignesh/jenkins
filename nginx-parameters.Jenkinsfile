pipeline {
    agent any

    parameters {
        string(name: 'HEALTH_URL', defaultValue: 'http://3.108.234.45/', description: 'Enter the Nginx health check URL')
        string(name: 'MAX_RETRIES', defaultValue: '3', description: 'Number of restart attempts')
        string(name: 'SLEEP_BETWEEN', defaultValue: '5', description: 'Time to wait between retries in seconds')
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
                        ./check_nginx.sh "${params.HEALTH_URL}" ${params.MAX_RETRIES} ${params.SLEEP_BETWEEN}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Nginx is UP."
        }
        failure {
            echo "Nginx is DOWN after retries."
        }
    }
}
