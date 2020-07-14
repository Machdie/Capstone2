

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
      /* stage('Create kubernetes cluster') {
		steps {
				withAWS(credentials:'aws-static', region:'us-east-2') {
					sh 'eksctl create cluster \
                            --name capstonecluster \
                            --version 1.16 \
                            --nodegroup-name eksworkernodes \
                            --node-type t2.medium \
                            --nodes 4 \
                            --nodes-min 1 \
                            --nodes-max 4 \
                            --node-ami auto \
                            --region us-east-2 \
                            --zones us-east-2a \
                            --zones us-east-2b \
                            --zones us-east-2c \
                     '
				}
			}
		} */
        stage('Deploying') {
			steps {
                echo 'Deploying Container to AWS...'
                withAWS(credentials: 'aws-static', region: 'us-east-2') {
				sh 'aws eks --region us-east-2 update-kubeconfig --name capstonecluster'
                sh 'kubectl config use-context arn:aws:eks:us-east-2:837039475813:cluster/capstonecluster'
                sh 'kubectl apply -f aws-auth-cm.yaml'
                sh 'kubectl apply -f deploy.yml'
                sh 'kubectl get nodes'
                sh 'kubectl get pods -o wide'
                sh 'kubectl describe pods'
                sh 'kubectl describe deployment'
           
                }
			}
		}

        stage('Rolling update') {
			steps {
				withAWS(credentials:'aws-static' , region:'us-east-2') {
					sh 'kubectl set image deployment/udacitycapstone udacitycapstone=machdinho/udacitycapstone:latest'
					sh 'kubectl rollout status deployment udacitycapstone'

				}
			}
		}
		
     }
        
}

