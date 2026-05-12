variable "aws_region" {
  description = "Region de AWS donde se desplegara la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
  default     = "proyectosemestral2"
}

variable "key_name" {
  description = "Nombre del par de llaves de EC2 existente en AWS"
  type        = string
  default     = "vockey"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI para las instancias EC2. En AWS Academy normalmente se usa Amazon Linux o Ubuntu"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "frontend_repository_name" {
  description = "Nombre del repositorio ECR para la imagen del frontend"
  type        = string
  default     = "frontend-despacho"
}

variable "ventas_repository_name" {
  description = "Nombre del repositorio ECR para la imagen del backend de ventas"
  type        = string
  default     = "backend-ventas"
}

variable "despachos_repository_name" {
  description = "Nombre del repositorio ECR para la imagen del backend de despachos"
  type        = string
  default     = "backend-despachos"
}