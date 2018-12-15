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
  agent none
  stages {
    stage('Build') {
      parallel {
        stage("Build-x86_64") {
          agent {
            label "docker-x86_64"
          }
          steps {
            sh './build.sh'
          }
        }
        stage("Build-s390x") {
          agent {
            label "docker-s390x"
          }
          steps {
            sh './build.sh'
          }
        }
        stage("Build-aarch64") {
          agent {
            label "docker-aarch64"
          }
          steps {
            sh './build.sh'
          }
        }
        stage("Build-ppc64le") {
          agent {
            label "docker-ppc64le"
          }
          steps {
            sh './build.sh'
          }
        }

      }
    }
  }
}
