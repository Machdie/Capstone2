

pipeline {
     agent any
     stages {
         stage('Build') {
              steps {
                  sh 'echo Building...'
              }
         }
         stage('Lint') {
              steps {
                  sh 'tidy -q -e *.html'
              }
         }
         stage('Build Docker Image') {
              steps {
                  sh 'docker build -t udacitycapstone .'
              }
         }
         stage('Push Image to Dockerhub') {
              steps {
                  echo 'Pushing Image....'
                  withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
                      sh "docker tag udacitycapstone machdinho/udacitycapstone"
                      sh 'docker push machdinho/udacitycapstone '
                  }
              }
         }
        stage('Deploying') {
			steps {
                echo 'Deploying Container to AWS...'
                withAWS(credentials: 'aws-static', region: 'us-west-2') {
				sh 'kubectl apply -f deployment.yml'
				sh 'kubectl apply -f load-balancer.yml'
                sh 'kubectl set image udacitycapstone'
                sh 'kubectl get nodes'
                sh 'kubectl get pod -o wide'
                }
			}
		}
    }
}
