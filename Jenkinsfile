pipeline {
  agent any
  stages {
    stage('check') {
      steps {
        sh '''whoami
hostname
hostname -i'''
      }
    }

    stage('ssh') {
      steps {
        sh '''ssh -T comm1
hostname
hostname -i'''
      }
    }

  }
}