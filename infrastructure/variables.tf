variable "aws_access_key" {
  type        = string
  sensitive   = true
  description = "An AWS access key with permission to provision all relevant resources"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "The secret corresponding to the provided AWS access key"
}
