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

    stage('') {
      steps {
        sh '''ssh comm1
hostname
hostname -i'''
      }
    }

  }
}