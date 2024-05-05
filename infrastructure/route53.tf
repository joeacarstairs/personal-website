# This hosted zone must have NS records which point to the same nameservers as
# those listed with the domain registrar. Right now, this means manually going
# into Route53Domains, finding the nameservers, and manually copying these into
# the NS records for this hosted zone.
resource "aws_route53_zone" "joeac_zone" {
  name = "joeac.net"
}

resource "aws_route53_record" "cloudfront" {
  # This is the subdomain for the record. Specify the root domain by leaving it blank
  name = ""

  zone_id = aws_route53_zone.joeac_zone.id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.joeac.domain_name
    zone_id                = aws_cloudfront_distribution.joeac.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_aaaa" {
  # This is the subdomain for the record. Specify the root domain by leaving it blank
  name = ""

  zone_id = aws_route53_zone.joeac_zone.id
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.joeac.domain_name
    zone_id                = aws_cloudfront_distribution.joeac.hosted_zone_id
    evaluate_target_health = false
  }
}
