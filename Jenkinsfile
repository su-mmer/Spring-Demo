pipeline {
  agent any
  environment {
    FLAG="FAIL"
  }
  stages {
    stage('Approval') {
    steps {
      withCredentials([[$class: "StringBinding", credentialsId: "$slack_test", variable: "SLACK_TOKEN"]]) {
        sh """
          curl -X POST -H \"Authorization: ${env.SLACK_TOKEN}\" -H \"BuildInfo: ${env.JOB_NAME}/${env.BUILD_NUMBER}/${COMMENT}\" -H \"Content-type: application/json\" https://{your api gateway}.ap-northeast-2.amazonaws.com/agw/slack-interactive-component
        """
      }
      script {
        try {
          timeout(time:30, unit:'MINUTES') {
            def APPROVE = input message: 'Deploy to Production', ok: 'Proceed', submitterParameter: 'approver',
              parameters: [choice(name: 'APPROVE', choices: 'YES\nNO', description: 'Approve Deploy?')]
            if (APPROVE['APPROVE'] == 'YES'){
              if (APPROVE['approver'] == 'admin') {
                env.APPROVAL = true
                echo 'Manager Approves this Deploy!'
                currentBuild.result = 'SUCCESS'
              } else {
                  env.APPROVAL = false
                  echo 'You\'re not a Manager'
                  currentBuild.result = 'FAILURE'
              }
            } else {
              env.APPROVAL = false
              echo 'Manager Aborts this Deploy'
              currentBuild.result = 'FAILURE'
            }
          }
        } catch (error) {
          print(error)
          print('Manager Aborts this Deploy or Timeout has been reached!\nDeploy automatically aborted')
          env.APPROVAL = false
          currentBuild.result = 'FAILURE'
          }
        }
    }
    post {
        success {
          slackSend channel: '#alarm-test', color: 'good', message: "The pipeline ${currentBuild.fullDisplayName} stage Approval successfully."
        }
        failure {
          slackSend channel: '#alarm-test', color: 'danger', message: "The pipeline ${currentBuild.fullDisplayName} stage Approval failed."
        }
      }
    }
    
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
          def RESPONSE_CODE = httpRequest "http://${target}:8080"
          // def RESPONSE_CODE = sh(script: 'curl -s -o /dev/null -w "%{http_code}" http://${target}:8080/hee', returnStdout: true)
          FLAG="${RESPONSE_CODE.status}"
          echo "${FLAG}"
        }
      }
    }

    stage('application success') {
      when {
        expression { "${FLAG}"=="200" }
        // environment name : "FLAG", value : "200"
        // equals expected: "${FLAG}", actual: "200"
      }

      steps {
        script {
          slackSend (channel: '#alarm-test', color: 'good', message: "Deploy Application Success Code ${FLAG}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
      }
    }

    stage('application fail') {
      when {
        not {
          expression { "${FLAG}"=="200" }
        }
      }
      steps {
        slackSend (channel: '#alarm-test', color: 'danger', message: "Deploy Application Fail Code ${FLAG}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }
  }

  post {
    success {
      slackSend (channel: '#alarm-test', color: 'good', message: "Jenkins Job & Deploy SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'\n (${env.BUILD_URL})")
    }
    failure {
      slackSend (channel: '#alarm-test', color: 'danger', message: "Jenkins Job FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'\n (${env.BUILD_URL})")
    }
  }
}