pipeline {
  agent any

  environment {
    // change these defaults as needed in the Jenkins job or via pipeline parameters
    TARGET_HOST = credentials('TARGET_HOST_CRED') // Optional: store host as secret text credential, or set below as plain text
    SSH_USER = "ubuntu"                   // username for SSH on your VM
    SSH_CREDENTIALS_ID = "prod_vm_ssh"    // Jenkins "SSH Username with private key" credential id
    HEALTH_URL = "http://localhost:80/"   // URL to curl from remote host
    MAX_RETRIES = "3"                     // restart attempt count
    SLEEP_BETWEEN_RETRIES = "5"           // seconds between checks
  }

  triggers {
    // run every 10 minutes by default. Change to "*/1 * * * *" for every 1 minute.
    cron('H/10 * * * *')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Run remote health-check & restart if needed') {
      steps {
        script {
          // we will SCP the script to the remote host and run it there
          // requires 'ssh-agent' plugin and a Jenkins credential of type "SSH Username with private key"
          sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
            sh """
              set -e
              # create remote temp dir
              ssh -o StrictHostKeyChecking=no ${SSH_USER}@${TARGET_HOST} 'mkdir -p ~/jenkins_health_check'
              # copy the script
              scp -o StrictHostKeyChecking=no scripts/check_nginx.sh ${SSH_USER}@${TARGET_HOST}:~/jenkins_health_check/check_nginx.sh
              # make executable and run (pass args)
              ssh -o StrictHostKeyChecking=no ${SSH_USER}@${TARGET_HOST} 'bash -s' <<'REMOTE'
                set -e
                chmod +x ~/jenkins_health_check/check_nginx.sh
                ~/jenkins_health_check/check_nginx.sh "${HEALTH_URL}" ${MAX_RETRIES} ${SLEEP_BETWEEN_RETRIES}
              REMOTE
            """
          }
        }
      }
    }
  }

  post {
    success {
      echo "Health-check stage completed successfully."
    }
    failure {
      echo "Pipeline failed: check console output. Consider checking SSH credentials or target host connectivity."
      // optional: send mail (requires Jenkins mail configured)
      // mail to: 'you@domain.com', subject: "Jenkins: Nginx health-check failed", body: "Check the job ${env.JOB_NAME} #${env.BUILD_NUMBER}"
    }
  }
}
