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