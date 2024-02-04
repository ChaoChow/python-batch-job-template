variable "app_image" {
  description = "The name of the docker image to deploy"
  type        = string
}

variable "environment" {
  description = "Name of the environment you are deployed to."
  type        = string
}