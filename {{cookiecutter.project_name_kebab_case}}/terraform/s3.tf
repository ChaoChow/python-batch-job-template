module "instruction_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${local.name}-${local.app_name}-instructions"

  tags = {
    "batch_job_name" : local.app_name
    "bucket_triggers" : true
  }
}

module "run_report" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${local.name}-${local.app_name}-run-reports"
}