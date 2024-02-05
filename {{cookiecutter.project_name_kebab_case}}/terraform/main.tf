terraform {
  backend "s3" {
    bucket         = "{{cookiecutter.state_s3_bucket_name}}"
    key            = "{{cookiecutter.lock_dynamo_key_prefix}}{{cookiecutter.project_name_kebab_case}}"
    region         = "{{cookiecutter.aws_region}}"
    dynamodb_table = "{{cookiecutter.lock_dynamo_table_name}}"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "aws_batch_job_definition" {
  source = "github.com/ChaoChow/aws-batch-job-definition?ref=v1.0.1"

  container_properties = {
    app_name    = local.app_name
    app_region  = local.region
    app_image   = var.app_image
    job_timeout = local.job_timeout
  }
  hardware_details = {
    vcpu             = "0.5"
    memory           = "2048"
    cpu_architecture = "ARM64"
  }
  env_vars = [
    {
      name  = "ENVIRONMENT",
      value = var.environment
    },
    {
      name  = "AWS_DEFAULT_REGION",
      value = local.region
    }
  ]
  read_only_bucket_arns  = [module.instruction_bucket.s3_bucket_arn]
  read_write_bucket_arns = [module.run_report.s3_bucket_arn]
  name                   = local.name
}
