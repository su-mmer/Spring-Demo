pipeline {
  agent any
  stages {
    stage('check') {
      steps {
        sh '''
        whoami
        hostname
        hostname -i
        '''
      }
    }
  }
}
