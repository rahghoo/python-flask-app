#!/bin/bash

# Variables
IMAGE_NAME="python-flask-app"
IMAGE_TAG="latest"
NAMESPACE_QA="qa"
NAMESPACE_PROD="prod"
CHART_PATH="./chart"

# Step 1: Build Docker Image
echo "Building Docker image $IMAGE_NAME:$IMAGE_TAG..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

# Step 2: Load the Docker Image into microk8s
echo "Loading Docker image into microk8s..."
docker save $IMAGE_NAME:$IMAGE_TAG -o $IMAGE_NAME:$IMAGE_TAG.tar
microk8s ctr image import $IMAGE_NAME:$IMAGE_TAG.tar

# Step 3: Deploy to QA using Helm
echo "Deploying to QA namespace using Helm..."
microk8s helm3 upgrade --install $IMAGE_NAME-qa $CHART_PATH \
  --namespace $NAMESPACE_QA \
  --set namespace=$NAMESPACE_QA \
  --set image.repository=$IMAGE_NAME \
  --set image.tag=$IMAGE_TAG \
  --set image.pullPolicy=IfNotPresent \
  --create-namespace

# Step 4: Verify QA Deployment
echo "Verifying QA deployment..."
microk8s kubectl rollout status deployment/$IMAGE_NAME-qa --namespace=$NAMESPACE_QA
microk8s kubectl get svc/$IMAGE_NAME-qa --namespace=$NAMESPACE_QA

# Step 5: Deploy to Prod using Helm
echo "Deploying to Prod namespace using Helm..."
microk8s helm3 upgrade --install $IMAGE_NAME-prod $CHART_PATH \
  --namespace $NAMESPACE_PROD \
  --set namespace=$NAMESPACE_PROD \
  --set image.repository=$IMAGE_NAME \
  --set image.tag=$IMAGE_TAG \
  --set image.pullPolicy=IfNotPresent \
  --create-namespace

# Step 6: Verify Prod Deployment
echo "Verifying Prod deployment..."
microk8s kubectl rollout status deployment/$IMAGE_NAME-prod --namespace=$NAMESPACE_PROD
microk8s kubectl get svc/$IMAGE_NAME-prod --namespace=$NAMESPACE_PROD

echo "Deployment completed!"
