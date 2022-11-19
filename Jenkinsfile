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
          withDockerRegistry([credentialsId: 'artifactory_docker_token', url: 'https://it101.jfrog.io']) {
            sh """
              apk add curl
              curl -O "https://it101.jfrog.io/artifactory/example-repo-local/java-11-openjdk-11.0.17.0.8-2.portable.jdk.el.x86_64.tar.xz"
              echo "Starting docker build.."
              DOCKER_BUILDKIT=1 docker build --progress plain -t pit/builder-dind:v2 .
              docker tag pit/builder-dind:v2 it101.jfrog.io/docker-local/pit/builder-dind:v2
              echo "Validate image exist..."
              docker images
              echo "Starting push to Artifactory..."
              docker --config ${DOCKER_CONFIG} push it101.jfrog.io/docker-local/pit/builder-dind:v2
            """
            }//dockerReg
        }//container
      }//steps
    }//stage
  }//stages
}//pipeline
