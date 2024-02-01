variable "aws_account" {
  type        = string
  description = "The name of the AWS account"
}

variable "data_migration_enabled" {
  type        = bool
  description = "A boolean value representing whether to create an IAM user and role for data migration across accounts"
  default     = false
}

variable "data_migration_source_bucket_arn" {
  type        = string
  description = "The S3 source bucket ARN for data migration to the destination call centre data S3 bucket"
  default     = ""
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
