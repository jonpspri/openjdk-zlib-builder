#!/usr/bin/env groovy

pipeline {
  parameters {
    string(
      name: 'ADOPTOPENJDK_TARGET_REGISTRY',
      defaultValue: 'adoptopenjdk',
      description: """
      The docker registry into which the docker images should be placed.
      Defaults to 'adoptopenjdk' (on docker.io).  One potential alternative
      could be 'registry.ng.bluemix.net/adoptopenjdk'.
      """
      )
  }
  agent {
    label 'docker-x86_64'
  }
  stages {
    stage('Build') {
      steps {
        sh './build.sh'
      }
    }
  }
}
