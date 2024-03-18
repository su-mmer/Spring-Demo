pipeline {
  agent any
  stages {
    stage('SSH Agent Command') {
      steps {
        sshagent (credentials: ['heekey'])
        sh '''
        ssh -o StrictHostKeyChecking=no ${TARGET_HOST} '
                        whoami
                    '
        '''
      }
    }

  }environment {
        TARGET_HOST = "hee@${{ secrets.HOST }}"
    }
}
