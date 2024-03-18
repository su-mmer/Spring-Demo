pipeline {
  agent any
  stages {
    stage('check') {
      steps {
        sh '''whoami
hostname
hostname -i
cat ~/.ssh/config
ssh -T comm1'''
      }
    }

  }
}