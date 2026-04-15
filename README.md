# Containerized ECS Fargate IT Tools Deployment on AWS

> A production-style, containerizing and deploying [IT Tools](https://github.com/CorentinTh/it-tools) on AWS ECS Fargate with Terraform, HTTPS, a custom domain, and fully automated CI/CD pipelines.

---

## Overview

This project takes IT Tools, an open-source developer utility app, and deploys it as a production-grade workload on AWS. The infrastructure follows a real-world pattern: a containerized app served behind an Application Load Balancer with HTTPS termination, running on ECS Fargate in private subnets, with all infrastructure managed as code using Terraform and deployments automated through GitHub Actions.

---

## Architecture

![Architecture Diagram](docs/images/architecture-diagram.png)

The traffic flow works as follows: a user's browser resolves `tm.abdullahabdi.com` via Cloudflare DNS, which points to the ALB DNS name. The ALB sits in public subnets and terminates TLS using an ACM certificate. It then forwards requests to ECS Fargate tasks running in private subnets on port 8080. The tasks pull their container image from ECR on startup. A regional NAT Gateway handles outbound internet access from private subnets.

---

## Tech Stack

| Layer | Technology |
|---|---|
| App | IT Tools (Vue.js / TypeScript) |
| Containerization | Docker (multi-stage build, nginx) |
| Container Registry | Amazon ECR |
| Compute | Amazon ECS Fargate |
| Load Balancer | Application Load Balancer (ALB) |
| HTTPS | AWS Certificate Manager (ACM) |
| DNS | Cloudflare + Route 53 |
| Networking | Custom VPC, public/private subnets, NAT Gateway |
| Infrastructure as Code | Terraform (modular) |
| State Management | S3 backend with native locking |
| CI/CD | GitHub Actions with OIDC |
| Logs | Amazon CloudWatch |

---

## Demo

![IT Tools Demo](docs/images/it-tools-demo.gif)

---

## Repository Structure

```
.
├── app/
├── Dockerfile
├── nginx.conf
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── modules/
│       ├── vpc/
│       ├── security_groups/
│       ├── ecr/
│       ├── iam/
│       ├── acm/
│       ├── route53/
│       ├── alb/
│       └── ecs/
├── .github/
│   └── workflows/
│       ├── app.yml
│       ├── terraform-deploy.yml
│       └── terraform-destroy.yml
├── images/
├── .dockerignore
├── .gitignore
└── README.md
```

---

## Local Setup

### Prerequisites

Make sure you have Docker, Node.js, and pnpm installed locally.

### Run with Docker

```bash
# Clone the repository
git clone git@github.com:AbdullahHAbdi/<your-repo-name>.git
cd <your-repo-name>

# Build the image
docker build -t it-tools .

# Run locally
docker run -p 8080:8080 it-tools
```

Then open [http://localhost:8080](http://localhost:8080) in your browser.

---

## CI/CD Pipelines

All pipelines authenticate with AWS using OIDC; no static AWS credentials are stored anywhere. GitHub Actions assumes an IAM role via a short-lived token that expires when the job finishes.

**App Pipeline** triggers automatically on any push to `main` that changes `app/`, `Dockerfile`, or `nginx.conf`. It builds the Docker image tagged with the commit SHA, pushes it to ECR, and forces a new ECS deployment.

**Terraform Deploy Pipeline** triggers automatically on any push to `main` that changes files under `infra/`. It runs `terraform fmt -check`, `terraform init`, `terraform validate`, `terraform plan`, and `terraform apply`.

**Terraform Destroy Pipeline** is manual only (`workflow_dispatch`). It requires a deliberate button click in the GitHub UI and will never trigger automatically.

### Pipeline Screenshots

![App Pipeline](docs/images/build-and-push-to-ecr.png)

![Terraform Deploy Pipeline](docs/images/terraform-deploy.png)

![Terraform Destroy Pipeline](docs/images/terraform-destroy.png)

---

## AWS Console Screenshots


**ECS Service - Running Tasks**
![ECS Running](docs/images/ecs-service-running.png)

**ALB - Active Status**
![ALB Active](docs/images/alb-active-status.png)

**ECR - Image Pushed**
![ECR Image](docs/images/ecr-image-pushed.png)

**ACM Certificate - Issued**
![ACM Certificate](docs/images/acm-certificate-success.png)

**Terraform State in S3**
![S3 State](docs/images/terraform-state-file-s3.png)

**HTTPS Certificate in Browser**
![Browser Certificate](docs/images/website-certificate.png)

---

## Future Improvements

- Add Trivy container image scanning to the app pipeline for vulnerability detection
- Add a pre-commit config with `terraform fmt` and `tflint` hooks to catch issues before pushing
- Move to a multi-environment setup (staging and production) using Terragrunt
- Add auto-scaling to the ECS service based on CPU/memory CloudWatch alarms
- Switch nginx to rootless mode to fully eliminate the root process requirement

---

