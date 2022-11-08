pipeline {
  agent {
    kubernetes {
      showRawYaml false
      defaultContainer 'dind-t4'
      yamlFile 'KubernetesPod.yaml'
    }
  }
  options {
    buildDiscarder(logRotator(daysToKeepStr: '100', numToKeepStr: '2'))
    timestamps()
  }
  stages {
    stage('Docker RHEL Base..') {
      steps {
        container('dind-t4') {
          withDockerRegistry([credentialsId: 'artifactory_docker_token', url: 'https://gitit103.jfrog.io']) {
            sh """
              echo "Starting docker build.."
              DOCKER_BUILDKIT=1 docker build --progress plain -t pit/rhel79:v1 .
              docker tag pit/rhel79:v1 gitit103.jfrog.io/dev-local-docker/pit/rhel79:v1
              docker tag pit/rhel79:v1 gitit103.jfrog.io/dev-local-docker/pit/rhel79:latest
              echo "Validate image exist..."
              docker images
              echo "Starting push to Artifactory..."
              docker --config ${DOCKER_CONFIG} push gitit103.jfrog.io/dev-local-docker/pit/rhel79:v1
              docker --config ${DOCKER_CONFIG} push gitit103.jfrog.io/dev-local-docker/pit/rhel79:latest
            """
            }//dockerReg
        }//container
      }//steps
    }//stage
  }//stages
}//pipeline
