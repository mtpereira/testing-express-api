variable "public_key_path" {
  default     = "~/.ssh/id_rsa.pub"
  description = "Path for the SSH public key to be used for ."
}

variable "key_name" {
  default     = "testing-express-api"
  description = "SSH key pair name"
}

variable "aws_region" {
  default     = "eu-west-2"
  description = "AWS region to create stack."
}

variable "aws_access_key" {
  default     = ""
  description = "AWS access key (AWS_ACCESS_KEY_ID)."
}

variable "aws_secret_key" {
  default     = ""
  description = "AWS secret key (AWS_SECRET_ACCESS_KEY)."
}

variable "aws_ami_id" {
  default     = "ami-c3978aa7"
  description = "Container Linux (CoreOS) Stable HVM in London."
}

variable "app_name" {
  default     = "testing-express-api"
  description = "Deployed application name."
}

variable "app_version" {
  default     = ""
  description = "Application version to be deployed. Maps directly to the docker image tag to be pulled by Container Linux."
}

variable "docker_image" {
  default     = "quay.io/mtpereira/testing-express-api"
  description = "Docker image to pull."
}