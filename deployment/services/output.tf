### output
output "lb-dns" {
  value       = aws_lb.rg-ops.dns_name
}

output "image-repo" {
  value       = aws_ecr_repository.rg-ops.repository_url
}

### debug output
#output "test" {
#  value       = data.aws_ecr_image.rg-ops
#}
#
#output "cert-arn" {
#  value       = data.aws_acm_certificate.api-sohan-cloud.arn
#}
#
