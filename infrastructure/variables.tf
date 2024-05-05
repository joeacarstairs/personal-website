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

variable "secret_s3_bucket_suffix" {
  type        = string
  sensitive   = true
  description = "This string should be a long string of up to 54 random characters. It will be appended to the S3 bucket name to mitigate the risk of DDoS attacks."
  nullable    = false

  validation {
    condition     = length(var.secret_s3_bucket_suffix) > 12
    error_message = "This string should be at least 12 characters"
  }

  validation {
    condition     = length(var.secret_s3_bucket_suffix) <= 54
    error_message = "This string should be no more than 54 characters long"
  }
}
