pipeline {
     agent any
     stages {
         stage('Build') {
              steps {
                  sh 'echo start building'
              }
         }
         stage('Lint HTML') {
              steps {
                      sh 'tidy -q -e *.html'
              }
         }
         stage('Build Docker Image') {
              steps {
                  sh 'docker build -t capstone.'
              }
         }
		stage('Push Docker Image') {
			steps {
				withDockerRegistry([url: "https://hub.docker.com/repository/docker/machdinho/capstone", credentialsId: "dockerhub"]) {
					sh "docker tag capstone-project machdinho/capstone"
					sh 'docker push machdinho/capstone'
               }
         }      
        } 
 /*stage('Create kubernetes cluster') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-esk') {
					sh '''
						eksctl create cluster \
                            --name udacity-capstone-eks \
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
                        
                        aws eks --region us-west-2 update-kubeconfig --name udacity-capstone-eks
					'''
				}
			}
		}*/
        stage('Config kubectl context') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-esk') {
					sh '''
                        aws eks --region us-west-2 update-kubeconfig --name udacity-capstone-eks
						kubectl config use-context arn:aws:eks:us-west-2:980543251014:cluster/udacity-capstone-eks
					'''
				}
			}
		}
        stage('Blue deploy') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-esk') {
					sh '''
						kubectl apply -f ./controller_blue.json
					'''
				}
			}
		}
        stage('Green deploy') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-esk') {
					sh '''
						kubectl apply -f ./controller_green.json
					'''
				}
			}
		}
        stage('Load balancer for redirection to blue') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-esk') {
					sh '''
						kubectl apply -f ./green-blue.json
					'''
				}
			}
		}
        stage('Notification with pause') {
            steps {
                input "traffic goes to green"
            }
        }
        stage('Load balancer for redirection to green') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-esk') {
					sh '''
						kubectl apply -f ./blue-green.json
					'''
				}
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
