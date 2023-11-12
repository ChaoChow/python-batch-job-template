locals {
  name               = "dg"
  app_name           = "{{cookiecutter.project_name_snake_case}}"
  region             = "us-east-1"
  secret_kms_key_id  = "421864b9-f334-4d12-b735-31f7ffbc74f2"
  job_timeout        = 7200
}