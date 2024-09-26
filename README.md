# Python Flask Application

This is a simple Python Flask application designed to run inside a Docker container. Below are the steps to build, run, and test the application locally deployed to microk8s kubenetes cluster.

## Prerequisites

Make sure you have the following tools installed on your local machine:

- [Docker](https://www.docker.com/get-started)
- [Git](https://git-scm.com/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Kubernetes Tools](https://kubernetes.io/docs/tasks/tools/)
- [MicroK8's](https://microk8s.io/docs/getting-started)

## Steps to Test and Run Locally

### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/rahghoo/python-flask-app.git
cd python-flask-app
```

### 2. RUN the script deploy-to-microk8s.sh
```bash
chmod +x deploy-to-microk8s.sh
sh -x deploy-to-microk8s.sh
```

The script runs the below steps:
 - Build Docker Image
 - Load the Docker Image into microk8s
 - Create namespaces if not exist
 - Deploy to QA using Helm
 - Verify QA Deployment
 - Deploy to Prod using Helm
 - Verify Prod Deployment

## CI/CD Pipeline

This project includes GitHub Actions workflows for building and pushing the docker image to docker registry and steps to validate kubernetes manifests. Below are steps run by github workfow
 - The pipeline will trigger on a push event to the main branch.
 - Build and push the docker image
 - validate manifests

## Additional Information
- For local testing, this setup uses [microk8s](https://microk8s.io/docs). Make sure that the Kubernetes cluster is properly set up and running before deploying
- To trigger github workflow push or merge a pull request to the main branch

## Local deployment execution log
```
rahghoo@latitude:~/development/take-home-tasks/ppro/python-flask-app$ ls
chart  deploy-to-microk8s.sh  Dockerfile  main.py  python-flask-app:latest.tar  README.md  requirements.txt
rahghoo@latitude:~/development/take-home-tasks/ppro/python-flask-app$ sh -x deploy-to-microk8s.sh
+ IMAGE_NAME=python-flask-app
+ IMAGE_TAG=latest
+ NAMESPACE_QA=qa
+ NAMESPACE_PROD=prod
+ CHART_PATH=./chart
+ echo Building Docker image python-flask-app:latest...
Building Docker image python-flask-app:latest...
+ docker build -t python-flask-app:latest .
[+] Building 10.9s (10/10) FINISHED                                                                                                  docker:default
 => [internal] load build definition from Dockerfile                                                                                           0.0s
 => => transferring dockerfile: 402B                                                                                                           0.0s
 => [internal] load .dockerignore                                                                                                              0.0s
 => => transferring context: 2B                                                                                                                0.0s
 => [internal] load metadata for docker.io/library/python:3.8-slim                                                                             1.1s
 => [auth] library/python:pull token for registry-1.docker.io                                                                                  0.0s
 => [1/4] FROM docker.io/library/python:3.8-slim@sha256:4dd2165f119c97c32c1d30b62bbffcd4bbb0b354d6c5522c024406b5b874ac40                       0.0s
 => [internal] load build context                                                                                                              1.6s
 => => transferring context: 315.51MB                                                                                                          1.6s
 => CACHED [2/4] WORKDIR /app                                                                                                                  0.0s
 => [3/4] COPY . /app                                                                                                                          2.5s
 => [4/4] RUN pip --no-cache-dir install -r requirements.txt                                                                                   4.2s
 => exporting to image                                                                                                                         1.4s
 => => exporting layers                                                                                                                        1.4s
 => => writing image sha256:bde878a66cfde851074e6335e1576db55f3d05fb05d23d3dd91813d752647224                                                   0.0s 
 => => naming to docker.io/library/python-flask-app:latest                                                                                     0.0s 
+ echo Loading Docker image into microk8s...                                                                                                        
Loading Docker image into microk8s...                                                                                                               
+ docker save python-flask-app:latest -o python-flask-app:latest.tar
+ microk8s ctr image import python-flask-app:latest.tar
unpacking docker.io/library/python-flask-app:latest (sha256:b548e572086b76bc76f9cf72837ec0bd68d4d46a009e3e4f106cda19d45aa2cb)...done
+ echo Deploying to QA namespace using Helm...
Deploying to QA namespace using Helm...
+ microk8s helm3 upgrade --install python-flask-app-qa ./chart --namespace qa --set namespace=qa --set image.repository=python-flask-app --set image.tag=latest --set image.pullPolicy=IfNotPresent --create-namespace
Release "python-flask-app-qa" has been upgraded. Happy Helming!
NAME: python-flask-app-qa
LAST DEPLOYED: Thu Sep 26 01:47:43 2024
NAMESPACE: qa
STATUS: deployed
REVISION: 11
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace qa -o jsonpath="{.spec.ports[0].nodePort}" services python-flask-app-qa)
  export NODE_IP=$(kubectl get nodes --namespace qa -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
+ echo Verifying QA deployment...
Verifying QA deployment...
+ microk8s kubectl rollout status deployment/python-flask-app-qa --namespace=qa
Waiting for deployment "python-flask-app-qa" rollout to finish: 0 of 1 updated replicas are available...
deployment "python-flask-app-qa" successfully rolled out
+ microk8s kubectl get svc/python-flask-app-qa --namespace=qa
NAME                  TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
python-flask-app-qa   NodePort   10.152.183.34   <none>        5001:32155/TCP   8h
+ echo Deploying to Prod namespace using Helm...
Deploying to Prod namespace using Helm...
+ microk8s helm3 upgrade --install python-flask-app-prod ./chart --namespace prod --set namespace=prod --set image.repository=python-flask-app --set image.tag=latest --set image.pullPolicy=IfNotPresent --create-namespace
Release "python-flask-app-prod" has been upgraded. Happy Helming!
NAME: python-flask-app-prod
LAST DEPLOYED: Thu Sep 26 01:47:44 2024
NAMESPACE: prod
STATUS: deployed
REVISION: 10
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace prod -o jsonpath="{.spec.ports[0].nodePort}" services python-flask-app-prod)
  export NODE_IP=$(kubectl get nodes --namespace prod -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
+ echo Verifying Prod deployment...
Verifying Prod deployment...
+ microk8s kubectl rollout status deployment/python-flask-app-prod --namespace=prod
Waiting for deployment "python-flask-app-prod" rollout to finish: 0 of 1 updated replicas are available...
deployment "python-flask-app-prod" successfully rolled out
+ microk8s kubectl get svc/python-flask-app-prod --namespace=prod
NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
python-flask-app-prod   NodePort   10.152.183.56   <none>        5001:31106/TCP   8h
+ echo Deployment completed!
Deployment completed!
```
![local_deployment_status_k8_dashboard](https://github.com/user-attachments/assets/b6aee51d-7bd2-4aba-9848-7d4c37f17f5c)

