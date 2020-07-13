

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
         stage('Push to Dockerhub') {
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
				sh 'aws eks --region us-west-2 update-kubeconfig --name CapstoneEKS-yc3ZzHbEDXDN'
                sh 'kubectl config use-context arn:aws:eks:us-west-2:837039475813:cluster/CapstoneEKS-yc3ZzHbEDXDN'
                sh 'kubectl apply -f aws-auth-cm.yaml'
                sh 'kubectl apply -f deploy.yml'
                sh 'kubectl get nodes'
                sh 'kubeclt get deployment'
                sh 'kubectl get pods -o wide'
                sh 'kubectl describe deployment'
                sh 'kubectl get service/udacitycapstone'
                }
			}
		}
     }
        
}

