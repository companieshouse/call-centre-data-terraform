variable "aws_account" {
  type        = string
  description = "The name of the AWS account"
}

variable "region" {
  type        = string
  description = "The AWS region in which resources will be created"
}

variable "environment" {
  type        = string
  description = "The environment name to be used when creating AWS resources"
}

variable "service" {
  type        = string
  description = "The service name to be used when creating AWS resources"
  default     = "call-centre-data"
}

variable "repository" {
  type        = string
  description = "The repository name to be used when creating AWS resource"
  default     = "call-centre-data-terraform"
}
