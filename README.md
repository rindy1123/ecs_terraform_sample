# Infra

## Terraform state management

- Set up dynamodb and S3 manually and copy the table name to backend.tf
- Set up S3 manually and copy the bucket name to backend.tf
- Generate a key pair using `scripts/keygen.sh` before deploying the infrastructure

## Secret Manager for Environment Variables

- Create Secret Manager manually and set environment variables
- Environment variables are defined in `ecs/task_definitions.json`
