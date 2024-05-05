data "aws_acm_certificate" "joeac_ssl_certificate" {
  domain   = local.domain
  statuses = ["ISSUED"]
}
