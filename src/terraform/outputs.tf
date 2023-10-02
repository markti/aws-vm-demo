output "public_subnets" {
  value = local.public_subnets
}
/*
output "frontend_attachments" {
  value = local.frontend_attachments
}
*/
output "private_key" {
  value     = tls_private_key.frontend.private_key_pem
  sensitive = true
}