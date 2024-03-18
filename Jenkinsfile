pipeline {
  agent any
  stages {
    stage('check') {
      steps {
        script {
          sshPublisher(publishers: [sshPublisherDesc(configName: 'target', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'nohup java -jar /home/hee/jenkins/*.jar >> /home/hee/log/application.log 2> /home/hee/log/error.log &', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
        }

      }
    }

    stage('') {
      steps {
        slackSend(color: '#00FF00', channel: '#alarm-test', message: 'Jenkins Start', token: 'S69GSJhyn9xxeIAyTK5ckr5k', tokenCredentialId: 'slack_test')
      }
    }

  }
}