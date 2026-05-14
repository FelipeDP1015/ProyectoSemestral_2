output "mysql_public_ip" {
  description = "IP publica de la EC2 donde corre MySQL"
  value       = aws_instance.db.public_ip
}

output "mysql_private_ip" {
  description = "IP privada de MySQL usada por ECS"
  value       = aws_instance.db.private_ip
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.app.name
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