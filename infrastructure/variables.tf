variable "do_token" {
  type        = string
  sensitive   = true
  description = "A DigitalOcean access token. Can also be provided as an environment variable"
}
