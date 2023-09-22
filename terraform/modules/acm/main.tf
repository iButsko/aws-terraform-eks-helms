resource "aws_route53_zone" "devtest_external" {
  name = "devtest.tl.scntl.com"
}

resource "aws_acm_certificate" "devtest_certificate" {
  domain_name       = "devtest.tl.scntl.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "devtest_cert_dns" {
  name    = tolist(aws_acm_certificate.devtest_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.devtest_certificate.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.devtest_external.zone_id
  records = [tolist(aws_acm_certificate.devtest_certificate.domain_validation_options)[0].resource_record_value]
  ttl     = "60"

}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.devtest_certificate.arn
  validation_record_fqdns = [aws_route53_record.devtest_cert_dns.fqdn]
}