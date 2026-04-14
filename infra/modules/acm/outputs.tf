output "certificate_arn" {
  description = "arn of the validated ACM certificate"
  value       = aws_acm_certificate_validation.main.certificate_arn
}

output "certificate_domain" {
  description = "domain name of the certificate"
  value       = aws_acm_certificate.cert.domain_name
}