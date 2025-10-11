# Deploy Strapi on AWS ECS Fargate using GitHub Actions

This task automates the deployment of a Strapi application to AWS ECS Fargate.  
The infrastructure (VPC, ECS Cluster, ECS Service, ALB, Security Groups) is already created using Terraform.  
so this focuses on automating application deployment using GitHub Actions.

---

## Workflow Explanation

The GitHub Actions workflow is triggered on every push to the `anitha` branch.

Steps:
1. Checkout the repository.  
2. Configure AWS credentials using GitHub Secrets.  
3. Log in to Amazon ECR.  
4. Build a new Docker image, tag it with the commit SHA, and push it to ECR.  
5. Render a new ECS Task Definition by replacing the image in `ecs-task-def.json`.  
6. Register a new Task Definition revision.  
7. Update the ECS Service to use the new revision and wait for service stability.

---

## Required GitHub Secrets

The following secrets must be added in GitHub repository → Settings → Secrets and variables → Actions:

- `AWS_ACCESS_KEY_ID`  
- `AWS_SECRET_ACCESS_KEY`  
- `AWS_REGION`  
- `ECR_REPOSITORY`  
- `ECS_CLUSTER`  
- `ECS_SERVICE`  

---

## ecs-task-def.json

The task definition file contains the container definition for the Strapi service.  
The image value is dynamically replaced by GitHub Actions during deployment.  
Other settings such as environment variables, log configuration, CPU, and memory are defined here.

---

## Deployment Flow

1. Developer pushes changes to the `anitha` branch.  
2. GitHub Actions runs the workflow.  
3. A new Docker image is built and pushed to ECR.  
4. ECS Task Definition is updated with the new image.  
5. ECS Service pulls the new revision and deploys the updated container.  
6. Application is accessible via the existing Application Load Balancer DNS created in Task 6.

---

## Verification

- Check ECS Console → Cluster → Service → Tasks. A new task revision should be running.  
- Check CloudWatch logs to confirm Strapi has started.  
- Access the application at:  
http://<ALB-DNS>:1337/admin
