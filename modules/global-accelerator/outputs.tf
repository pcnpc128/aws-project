# output "accelerator_dns" { value = aws_globalaccelerator_accelerator.this.dns_name }
output "dns_name" {
  value = aws_globalaccelerator_accelerator.this.dns_name
}
