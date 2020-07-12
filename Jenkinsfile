

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
        stage('Deployment') {
			steps {
                echo 'Deploying Container to AWS...'
                withAWS(credentials: 'aws-static', region: 'us-west-2') {
				sh 'aws eks --region us-west-2 update-kubeconfig --name CapstoneEKS-NTnhmLgtOFhA'
                sh 'kubectl apply -f aws-auth-cm.yaml'
                sh 'kubectl apply -f deploy.yml'
                sh 'kubectl get nodes'
                sh 'kubectl get pods'
                sh 'kubectl describe pods'
                }
			}
		}
        stage('Rolling Deployment') {
            steps {
                withAWS(credentials: 'aws-static', region: 'us-west-2') {
                sh 'kubectl set image deployments/udacitycapstone udacitycapstone=machdinho/udacitycapstone:latest'
                sh 'kubectl rollout status deployment udacitycapstone'
                sh 'kubectl get deployments'
                }

            }   
        }
        stage("Cleaning up") {
            steps{
                    echo 'Cleaning up...'
                    sh 'docker system prune -y'
            }        
        }
     }        
}

