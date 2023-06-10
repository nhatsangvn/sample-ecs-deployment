### output
output "aws_vpc_default" {
  value       = data.aws_vpc.default
}

output "lb-dns" {
  value       = aws_lb.rg-ops.dns_name
}

output "cert-arn" {
  value       = data.aws_acm_certificate.api-sohan-cloud.arn
}
