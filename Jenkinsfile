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
                  sh 'docker build -t capstone0.9 .'
              }
         }
         stage('Push Image to Dockerhub') {
              steps {
                  echo 'Pushing Image....'
                  withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
                      sh "docker tag capstone0.9 machdinho/capstone0.9"
                      sh 'docker push machdinho/capstone0.9 '
                  }
              }
         }
         stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'aws-static', region: 'us-west-2') {
                      sh "aws eks --region us-west-2 update-kubeconfig --name CapstoneEKS-NTnhmLgtOFhA"
                      sh "kubectl config use-context arn:aws:eks:us-west-2:837039475813:cluster/CapstoneEKS-NTnhmLgtOFhA"
                      sh "kubectl set image deployments/capstone0.9 capstone0.9=machdinho/capstone0.9:latest"
                      sh "kubectl apply -f deployment/deployment.yml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployment"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/capstone0.9"
                  }
              }
        }
        stage("Cleaning up") {
              steps{
                    echo 'Cleaning up...'
                    sh "docker system prune"
              }
        }
     }
}
