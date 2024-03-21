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
              nohup java -jar /home/hee/jenkins/demo-0.0.1-SNAPSHOT.jar >> /home/hee/log/application.log 2> /home/hee/log/error.log &
              '
          sleep 20
          '''
        }

      }
    }

    stage('get http request') {
      steps {
        script{
          // def RESPONSE_CODE = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://${target}:8080', returnStdout: true)
          RESPONSE_CODE=sh(script: 'RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://${target}:8080) | echo $RESPONSE_CODE', returnStdout: true).trim()
          // echo "$RESPONSE_CODE"
        }
      }
    }

    stage('application success') {
      when {
        expression {"${RESPONSE_CODE}"=="200"}
        // equals expected: "${RESPONSE_CODE}", actual: "200"
      }

      steps {
        slackSend (channel: '#alarm-test', color: 'good', message: "Deploy Application Success Code ${RESPONSE_CODE}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }

    stage('application fail') {
      when {
        not { expression {"${RESPONSE_CODE}"=="200"} }
      }

      steps {
        slackSend (channel: '#alarm-test', color: 'danger', message: "Deploy Application Fail Code ${RESPONSE_CODE}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }

    // stage('response http request') {
    //   steps {
    //     script{
    //       RESPONSE_CODE=sh(script: "curl -s -o /dev/null -w "%{http_code}" http://${target}:8080", returnStdout: true).trim();
    //     }
    //     slackSend (channel: '#alarm-test', color: '#0000CC', message: "Deploy Application Code ${RESPONSE_CODE}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    //   }
    // }

  }
  post {
    success {
      slackSend (channel: '#alarm-test', color: 'good', message: "Jenkins Job SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'\n (${env.BUILD_URL})")
    }

    failure {
      slackSend (channel: '#alarm-test', color: 'danger', message: "Jenkins Job FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'\n (${env.BUILD_URL})")
    }

  }

  
}