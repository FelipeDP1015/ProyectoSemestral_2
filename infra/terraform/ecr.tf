resource "aws_ecr_repository" "frontend" {
  name                 = var.frontend_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = var.frontend_repository_name
    Project = var.project_name
    Service = "frontend"
  }
}

resource "aws_ecr_repository" "backend_ventas" {
  name                 = var.ventas_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = var.ventas_repository_name
    Project = var.project_name
    Service = "backend-ventas"
  }
}

resource "aws_ecr_repository" "backend_despachos" {
  name                 = var.despachos_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name    = var.despachos_repository_name
    Project = var.project_name
    Service = "backend-despachos"
  }
}