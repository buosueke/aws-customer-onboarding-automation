# AWS Customer Onboarding Automation (CloudFormation)
## Overview
This project documents an automated infrastructure provisioning workflow used to onboard new enterprise customers to a hosted SaaS platform.

The objective was to eliminate manual infrastructure setup and replace it with a repeatable Infrastructure as Code (IaC) workflow capable of deploying all required customer resources using a single command.

The automation provisions the following infrastructure components:

Customer EC2 application host

Dedicated S3 upload bucket

Customer IAM service user

Standardized bucket policy and CORS configuration

Customer DNS record

All resources are deployed through AWS CloudFormation and managed as a single infrastructure stack.

## Deployment

```bash
./new-customer.sh "Customer Name" INSTANCE_TYPE BUCKET_NAME IAM_USER RECORD_NAME
