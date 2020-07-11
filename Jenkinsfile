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
                  sh 'docker build -t udacity-capstone .'
              }
         }
         stage('Push Image to Dockerhub') {
              steps {
                  echo 'Pushing Image....'
                  withDockerRegistry([url: "", credentialsId: "dockerhub"]) {
                      sh "docker tag udacity-capstone machdinho/udacity-capstone"
                      sh 'docker push machdinho/udacity-capstone '
                  }
              }
         }
         stage('Deploying') {
              steps{
                  echo 'Deploying Container to AWS...'
                  withAWS(credentials: 'aws-static', region: 'us-west-2') {
                      sh "aws eks --region us-west-2 update-kubeconfig --name CapstoneEKS-NTnhmLgtOFhA"
                      sh "kubectl config use-context arn:aws:eks:us-west-2:837039475813:cluster/CapstoneEKS-NTnhmLgtOFhA"
                      sh "kubectl apply -f deployment.yml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployment"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/udacity-capstone"
                  echo 'Deplyoment sucessfull'
                  }
              }
