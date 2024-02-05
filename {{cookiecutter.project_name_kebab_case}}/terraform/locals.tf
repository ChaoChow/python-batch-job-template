locals {
  name               = "{{cookiecutter.tf_all_resources_prefix}}"
  app_name           = "{{cookiecutter.project_name_kebab_case}}"
  region             = "{{cookiecutter.aws_region}}"
  secret_kms_key_id  = "{{cookiecutter.secret_kms_key}}"
  job_timeout        = "{{cookiecutter.job_timeout}}"
}