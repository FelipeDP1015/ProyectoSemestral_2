output "frontend_public_ip" {
  description = "IP publica de la instancia frontend"
  value       = aws_instance.frontend.public_ip
}

output "frontend_public_dns" {
  description = "DNS publico de la instancia frontend"
  value       = aws_instance.frontend.public_dns
}

output "backend_private_ip" {
  description = "IP privada de la instancia backend"
  value       = aws_instance.backend.private_ip
}

output "frontend_repository_url" {
  description = "URL del repositorio ECR del frontend"
  value       = aws_ecr_repository.frontend.repository_url
}

output "backend_ventas_repository_url" {
  description = "URL del repositorio ECR del backend de ventas"
  value       = aws_ecr_repository.backend_ventas.repository_url
}

output "backend_despachos_repository_url" {
  description = "URL del repositorio ECR del backend de despachos"
  value       = aws_ecr_repository.backend_despachos.repository_url
}