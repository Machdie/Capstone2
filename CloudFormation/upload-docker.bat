#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
dockerpath="machdinho/udacity-capstone"


# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
# docker login --username  machdinho
docker image tag udacity-capstone $dockerpath

# Step 3:
# Push image to a docker repository
docker push $dockerpath