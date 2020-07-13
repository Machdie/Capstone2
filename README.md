# capstone-project-cloud-devops
Machdie Udacity
Setup Jenkins-Server:
	Install all relevant Plugins e.g. BlueOcean, necessary AWS PLugins
	Create Credentials for Dockerhub and AWS 
Setup NW:
	with Scripts (create, update, delete) from cloudformation folder via AWS CLI
	NW

EKS and Workernodes creation by jenkinsfile via eksctl

Create Files:
	Makefile
	Dockerfile
	Jenkinsfile
		Pipeline: Build, Lint, Build Docker Image, Push Image to Dockerhub, Deploying, Rolling update (for submission screenshot)
		
Create Deployment:

Deployment.yml specify replicas, rollingupdate 

Application:
Use Index.html for simple Nginx “Hello World, my name is (student name)” application

