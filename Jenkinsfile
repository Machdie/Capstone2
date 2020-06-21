pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Build"'
        sh '''
                cd Docker/
                make install
                '''
      }
    }

    stage('Lint HTML') {
      steps {
        sh 'tidy -q -e *.html'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
                    cd Docker/
                    bash build_docker.sh
                '''
      }
    }

    stage('Push Docker Image') {
      steps {
        withDockerRegistry(url: 'https://hub.docker.com/repository/docker/machdinho/capstone', credentialsId: 'dockerhub') {
          sh 'docker tag capstone-project machdinho/capstone'
          sh 'docker push machdinho/capstone'
        }

      }
    }

    stage('Config kubectl context') {
      steps {
        withAWS(region: 'us-west-2', credentials: 'aws-esk') {
          sh '''
                        aws eks --region us-west-2 update-kubeconfig --name udacity-capstone-eks
						kubectl config use-context arn:aws:eks:us-west-2:980543251014:cluster/udacity-capstone-eks
					'''
        }

      }
    }

    stage('Blue deploy') {
      steps {
        withAWS(region: 'us-west-2', credentials: 'aws-esk') {
          sh '''
						kubectl apply -f ./controller_blue.json
					'''
        }

      }
    }

    stage('Green deploy') {
      steps {
        withAWS(region: 'us-west-2', credentials: 'aws-esk') {
          sh '''
						kubectl apply -f ./controller_green.json
					'''
        }

      }
    }

    stage('Load balancer for redirection to blue') {
      steps {
        withAWS(region: 'us-west-2', credentials: 'aws-esk') {
          sh '''
						kubectl apply -f ./green-blue.json
					'''
        }

      }
    }

    stage('Notification with pause') {
      steps {
        input 'traffic goes to green'
      }
    }

    stage('Load balancer for redirection to green') {
      steps {
        withAWS(region: 'us-west-2', credentials: 'aws-esk') {
          sh '''
						kubectl apply -f ./blue-green.json
					'''
        }

      }
    }

  }
}