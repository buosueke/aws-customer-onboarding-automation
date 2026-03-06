# AWS Customer Onboarding Automation (CloudFormation)

Provision a complete customer infrastructure environment in AWS with a single command.

---

## What This Project Demonstrates

- Infrastructure as Code using AWS CloudFormation
- Automated customer environment provisioning
- Cloud infrastructure lifecycle management
- Secure multi-tenant resource isolation
- Operational automation for SaaS onboarding

## Overview

This project demonstrates an automated infrastructure provisioning workflow used to onboard new enterprise customers to a hosted SaaS platform.

The objective was to eliminate manual infrastructure setup and replace it with a repeatable **Infrastructure as Code (IaC)** workflow capable of deploying all required customer resources using a single command.

The automation provisions the following infrastructure components:

- Customer EC2 application host
- Dedicated S3 upload bucket
- Customer IAM service user
- Standardized bucket policy and CORS configuration
- Customer DNS record

All resources are deployed through **AWS CloudFormation** and managed as a single infrastructure stack.

---

## Problem

Customer onboarding previously required multiple manual steps across several AWS services:

1. Create EC2 instance  
2. Configure storage bucket  
3. Create IAM user  
4. Configure bucket policies  
5. Configure CORS  
6. Create DNS record  
7. Apply consistent resource tagging  

This manual process introduced several operational challenges:

- Time-consuming provisioning workflow  
- Configuration inconsistencies between environments  
- Risk of human error  
- Difficulty tracking and auditing resources  

Provisioning a single environment typically required **30–45 minutes** of manual setup across multiple AWS consoles.

---

## Architecture

The solution introduces a **CloudFormation template combined with a deployment script** that automates the full onboarding workflow.

### Core Components

| Service | Purpose |
|-------|--------|
| Amazon EC2 | Customer application host |
| Amazon S3 | Customer document upload bucket |
| AWS Identity and Access Management (IAM) | Customer service account |
| Amazon Route 53 | Customer DNS record |
| AWS CloudFormation | Infrastructure orchestration |

---

## Deployment Model

Each customer environment is deployed as an **independent CloudFormation stack**.

Example stack name:

`cust-examplecustomer`

Each stack contains the following resources:

- EC2 Instance  
- S3 Bucket  
- IAM User  
- Bucket Policy  
- CORS Configuration  
- DNS Record  

This model allows the entire customer environment to be created or removed as a single unit.

---


## Automation Workflow

A lightweight shell script is used to deploy a new customer environment.

```bash
./new-customer.sh "Customer Name" INSTANCE_TYPE BUCKET_NAME IAM_USER RECORD_NAME

## Example Deployment

```bash
./new-customer.sh "Example Ltd" t3a.large examplebucket ExampleUser example
```

This command triggers a CloudFormation stack deployment, which provisions all required infrastructure automatically.

---

## DNS Configuration

Each customer receives a dedicated DNS entry.

Example:

```
customername.exampledomain.com
```

This DNS record points to the shared application endpoint used by the hosted platform.

---

## Security Model

The architecture implements several security controls:

- Dedicated IAM user per customer
- Bucket access scoped through S3 bucket policies
- Server-side encryption using AWS KMS
- EC2 Instance Metadata Service v2 (IMDSv2) enforced
- Standardized IAM permissions
- TLS-enabled access patterns

---

## S3 Configuration

All customer buckets receive a standardized configuration.

### CORS Policy

```
AllowedMethods: GET, PUT, POST, HEAD
AllowedOrigins: *
AllowedHeaders: *
```

This configuration enables secure browser-based uploads and external system integrations.

---

## Benefits

| Benefit | Impact |
|--------|--------|
| Automation | Provisioning time reduced from ~45 minutes to under 2 minutes |
| Consistency | Every customer environment is deployed identically |
| Auditability | Infrastructure fully defined in code |
| Reproducibility | New environments created using a single command |
| Isolation | Each customer managed through an independent stack |

---

## Operational Workflow

### Onboard a Customer

```bash
./new-customer.sh
```

### View Customer Infrastructure

AWS Console → CloudFormation → Stacks

### Decommission a Customer

```bash
aws cloudformation delete-stack --stack-name cust-customername
```

Deleting the stack removes all associated resources.

---
## Design Tradeoffs

During the design of the automated onboarding system, several architectural tradeoffs were considered to balance simplicity, operational safety, and scalability.

---

### 1. Infrastructure as Code vs Manual Provisioning

| Option | Pros | Cons |
|------|------|------|
| Manual provisioning | Quick for one-off environments | Error-prone, inconsistent, difficult to audit |
| Infrastructure as Code | Repeatable, version controlled, auditable | Requires initial setup and template design |

**Decision**

Infrastructure provisioning was implemented using **AWS CloudFormation** to ensure consistent deployments and enable full lifecycle management of customer environments.

---

### 2. Single Shared Environment vs Customer-Isolated Resources

| Option | Pros | Cons |
|------|------|------|
| Shared infrastructure | Lower cost | Harder to manage permissions and isolation |
| Dedicated customer resources | Strong isolation and easier lifecycle management | Slightly higher infrastructure footprint |

**Decision**

Each customer environment is provisioned as its own **isolated infrastructure stack**.

This provides:

- simplified lifecycle management
- stronger security boundaries
- easier troubleshooting and auditing

---

### 3. Script-Driven Deployment vs Full CI/CD Pipeline

| Option | Pros | Cons |
|------|------|------|
| Shell script deployment | Simple, lightweight, easy to use | Requires manual execution |
| CI/CD pipeline | Fully automated and auditable | Higher setup complexity |

**Decision**

A lightweight shell script was chosen for deployment to keep the onboarding process simple while still leveraging CloudFormation for infrastructure orchestration.

Future iterations could introduce CI/CD integration.

---

### 4. Separate CloudFormation Stack per Customer

| Option | Pros | Cons |
|------|------|------|
| Single shared stack | Fewer stacks to manage | Difficult to isolate resources |
| Stack per customer | Clean lifecycle management | Larger number of stacks |

**Decision**

Each customer is deployed as an **independent stack**.

Example:

```
cust-customerA
cust-customerB
cust-customerC
```

This allows entire environments to be created or removed with a single command.

---

### 5. DNS Architecture

Customer environments receive dedicated DNS entries managed through **Amazon Route 53**.

This approach allows customer services to be easily routed while keeping infrastructure centralized.

---

## Key Design Principle

The architecture prioritizes:

- automation
- repeatability
- environment isolation
- safe infrastructure lifecycle management

These principles ensure that new environments can be deployed and removed safely while maintaining operational consistency.

---

## Architectural Outcome

The final system enables engineers to provision a full customer environment using a single command:

```bash
./new-customer.sh "Customer Name" INSTANCE_TYPE BUCKET_NAME IAM_USER RECORD_NAME
```

Provisioning time was reduced from **30–45 minutes to under 2 minutes**, while also eliminating configuration drift and forgotten resources.


## Lessons Learned

Key takeaways from implementing this automation:

- Infrastructure as Code significantly reduces operational overhead
- Stack isolation simplifies environment lifecycle management
- Automation prevents configuration drift
- Standardized security policies improve compliance

---

## Future Improvements

Potential future enhancements include:

- CI/CD pipelines for infrastructure deployments
- automated credential distribution
- cost allocation tagging
- infrastructure validation checks

---

## Author

**Bugaluchi Osueke**  
AWS Solutions Architect Professional  
Cloud Architecture & Platform Engineering
