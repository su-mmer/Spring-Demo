pipeline {
  agent any
  stages {
    stage('start message to slack') {
      steps {
        slackSend(channel: '#alarm-test', message: "Jenkins Start Pipeline: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }

    stage('ssh deploy') {
      steps {
        sshagent(['heekey']) {
          sh '''
          ssh -o StrictHostKeyChecking=no hee@${target} '
              nohup java -jar /home/hee/jenkins/*.jar >> /home/hee/log/application.log 2> /home/hee/log/error.log &
              '
          sleep 20
          '''
        }

      }
    }

    stage('response http request') {
      steps {
        script{
          // sh '''
          // RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://${target}:8080)
          // echo "$RESPONSE_CODE"
          // '''
          RESPONSE_CODE=sh(script: "curl -s -o /dev/null -w "%{http_code}" http://${target}:8080", returnStdout: true).trim();
        }
        slackSend (channel: '#alarm-test', color: '#0000CC', message: "Deploy Application Code ${RESPONSE_CODE}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }

  }
  post {
    success {
      // slackSend(channel: '#alarm-test', color: '#009900', message: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      slackSend(channel: '#alarm-test', color: 'good', message: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

    failure {
      // slackSend(channel: '#alarm-test', color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      slackSend(channel: '#alarm-test', color: 'danger', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

  }
}