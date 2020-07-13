

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
         /*stage('Create kubernetes cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-static') {
					sh 'eksctl create cluster \
                            --name capstoneEks \
                            --version 1.16 \
                            --nodegroup-name standard-workers \
                            --node-type t2.small \
                            --nodes 2 \
                            --nodes-min 1 \
                            --nodes-max 3 \
                            --node-ami auto \
                            --region us-west-2 \
                            --zones us-west-2a \
                            --zones us-west-2b \
                            --zones us-west-2c \
                            aws eks --region us-west-2 update-kubeconfig --name capstoneEks'
				}
			}
		}*/
        stage('Deploying') {
			steps {
                echo 'Deploying Container to AWS...'
                withAWS(credentials: 'aws-static', region: 'us-west-2') {
				sh 'aws eks --region us-west-2 update-kubeconfig --name capstoneEks'
                sh 'kubectl config use-context arn:aws:eks:us-west-2:837039475813:cluster/capstoneEks'
                sh 'kubectl apply -f aws-auth-cm.yaml'
                sh 'kubectl apply -f deploy.yml'
                sh 'kubectl get nodes'
                sh 'kubectl get pods -o wide'
                sh 'kubectl describe pods'
                sh 'kubectl describe deployment'
                sh 'kubectl get service/udacitycapstone'            
                }
			}
		}
         stage('Rolling update') {
			steps {
				withAWS(credentials:'aws-static' , region:'us-west-2') {
					sh 'kubectl set image deployment/udacitycapstone udacitycapstone=machdinho/udacitycapstone:latest'
					sh 'kubectl rollout status deployment udacitycapstone'
					sh 'kubectl get deployments'
				}
			}
		}
     }
        
}

