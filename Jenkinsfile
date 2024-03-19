pipeline {
  agent any
  stages {
    stage('start message to slack') {
      steps {
          slackSend (channel: '#alarm-test', color: '#009900', message: "Jenkins Start Pipeline: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

      }
    }

    stage('ssh deploy') {
      steps {
        script {
          sshPublisher(publishers: [sshPublisherDesc(configName: 'target', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'nohup java -jar /home/hee/jenkins/*.jar >> /home/hee/log/application.log 2> /home/hee/log/error.log &', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
        }

      }
    }

  }
}
