# ProyectoSemestral_2 - Despliegue con Docker, Terraform, ECR y ECS

## Descripción del proyecto

Proyecto web contenerizado y desplegado en AWS. La aplicación está compuesta por un frontend, dos servicios backend y una base de datos MySQL.

El proyecto permite ejecutar el sistema de forma local con Docker Compose y desplegarlo en AWS usando Terraform, Amazon ECR, Amazon ECS Fargate, EC2 y GitHub Actions.

---

## Arquitectura general

```txt
Usuario
  |
  v
Frontend React + Nginx
  |
  v
Backends Spring Boot
  |
  |---- Ventas Backend
  |
  |---- Despachos Backend
  |
  v
Base de datos MySQL
```

En AWS se implementó de la siguiente forma:

```txt
GitHub Actions
   |
   v
Amazon ECR
   |
   v
Amazon ECS Fargate
   |
   |---- frontend
   |---- ventas-backend
   |---- despachos-backend
   |
   v
EC2 con MySQL
```

---

## Tecnologías utilizadas

- Docker
- Docker Compose
- Terraform
- GitHub Actions
- AWS CLI
- Amazon ECR
- Amazon ECS Fargate
- Amazon EC2
- Amazon CloudWatch
- React
- Nginx
- Spring Boot
- MySQL 8.0

---

## Servicios del proyecto

| Servicio | Tecnología | Puerto | Descripción |
|---|---|---:|---|
| Frontend | React + Nginx | 80 | Interfaz web |
| Ventas Backend | Spring Boot | 8080 | Servicio de ventas |
| Despachos Backend | Spring Boot | 8081 | Servicio de despachos |
| MySQL | MySQL 8.0 | 3306 | Base de datos |

---

## Estructura principal

```txt
ProyectoSemestral_2/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── Backend/
│   ├── back-Ventas_SpringBoot/
│   └── back-Despachos_SpringBoot/
│
├── Frontend/
│   └── front_despacho/
│       ├── dockerfile
│       ├── dockerfile.ecs
│       ├── nginx.conf
│       └── nginx.ecs.conf
│
├── infra/
│   └── terraform/
│       ├── compute.tf
│       ├── ecr.tf
│       ├── ecs.tf
│       ├── security.tf
│       ├── provider.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── docker-compose.yml
└── README.md
```

---

## Ejecución local

Para levantar el proyecto localmente se usa Docker Compose.

Desde la raíz del proyecto:

```bash
docker compose up --build
```

Para detener los servicios:

```bash
docker compose down
```

Accesos locales:

| Servicio | URL |
|---|---|
| Frontend | `http://localhost` |
| Ventas Backend | `http://localhost:8080` |
| Despachos Backend | `http://localhost:8081` |
| MySQL | `localhost:3306` |

---

## Variables de entorno locales

Los backend usan estas variables para conectarse a MySQL:

```txt
DB_ENDPOINT=mysql-db
DB_PORT=3306
DB_NAME=innovatech_db
DB_USERNAME=innovatech
DB_PASSWORD=innovatech123
```

---

## Infraestructura con Terraform

La infraestructura se encuentra en:

```txt
infra/terraform
```

Terraform crea los siguientes recursos en AWS:

- Repositorios Amazon ECR.
- Instancia EC2 para MySQL.
- Security Group.
- Cluster ECS.
- Task Definition.
- ECS Service.
- CloudWatch Log Group.

---

## Comandos Terraform

Entrar a la carpeta de Terraform:

```bash
cd infra/terraform
```

Inicializar Terraform:

```bash
terraform init
```

Revisar los recursos que se crearán:

```bash
terraform plan
```

Crear la infraestructura:

```bash
terraform apply
```

Cuando Terraform pregunte, escribir:

```txt
yes
```

Para eliminar la infraestructura:

```bash
terraform destroy
```

---

## Configuración de AWS Academy

Antes de usar Terraform, se deben configurar las credenciales de AWS Academy.

Ejemplo en PowerShell:

```powershell
$env:AWS_ACCESS_KEY_ID="ACCESS_KEY_REAL"
$env:AWS_SECRET_ACCESS_KEY="SECRET_KEY_REAL"
$env:AWS_SESSION_TOKEN="SESSION_TOKEN_REAL"
$env:AWS_DEFAULT_REGION="us-east-1"
```

Para comprobar que funciona:

```powershell
aws sts get-caller-identity
```

---

## Amazon ECR

Se crean tres repositorios para guardar las imágenes Docker:

```txt
frontend-despacho
backend-ventas
backend-despachos
```

Las imágenes son construidas y subidas automáticamente por GitHub Actions.

---

## Amazon ECS Fargate

Se creó un cluster ECS llamado:

```txt
proyectosemestral2-cluster
```

Dentro del cluster se creó un servicio llamado:

```txt
app
```

La task de ECS ejecuta tres contenedores:

```txt
frontend
ventas-backend
despachos-backend
```

---

## Base de datos en EC2

La base de datos MySQL se ejecuta en una instancia EC2.

Terraform instala Docker en la instancia y levanta un contenedor MySQL con la base de datos:

```txt
innovatech_db
```

Esta decisión permite mantener una arquitectura simple, similar al ejemplo trabajado en clases.

---

## GitHub Actions

El pipeline se encuentra en:

```txt
.github/workflows/deploy.yml
```

Se ejecuta automáticamente al hacer push a la rama:

```txt
deploy
```

El pipeline realiza estos pasos:

1. Construye la imagen del frontend.
2. Sube la imagen del frontend a ECR.
3. Construye la imagen del backend de ventas.
4. Sube la imagen de ventas a ECR.
5. Construye la imagen del backend de despachos.
6. Sube la imagen de despachos a ECR.
7. Actualiza el servicio ECS.

---

## Secrets necesarios en GitHub

En GitHub se deben agregar en:

```txt
Settings > Secrets and variables > Actions
```

### Secrets

```txt
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
```

### Variables

```txt
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=ID_DE_LA_CUENTA_AWS
ECR_FRONTEND_REPOSITORY=frontend-despacho
ECR_VENTAS_REPOSITORY=backend-ventas
ECR_DESPACHOS_REPOSITORY=backend-despachos
```

---

## Validación en AWS

Después del despliegue, revisar:

### ECR

Verificar que cada repositorio tenga una imagen con tag:

```txt
latest
```

Repositorios esperados:

```txt
frontend-despacho
backend-ventas
backend-despachos
```

### ECS

Ingresar a:

```txt
ECS > Clusters > proyectosemestral2-cluster > Services > app
```

La task debe quedar en estado:

```txt
Running
```

### CloudWatch

Revisar logs en:

```txt
CloudWatch > Log groups
```

Ahí se pueden revisar los logs de:

```txt
frontend
ventas
despachos
```

### IP pública

Cuando la task esté en estado `Running`, ingresar a:

```txt
ECS > Cluster > Tasks > Task en ejecución > Networking
```

Copiar la IP pública y abrir:

```txt
http://IP_PUBLICA
```

---

## Archivos principales modificados o agregados

```txt
.github/workflows/deploy.yml
infra/terraform/ecs.tf
infra/terraform/compute.tf
infra/terraform/security.tf
infra/terraform/ecr.tf
infra/terraform/outputs.tf
Frontend/front_despacho/dockerfile.ecs
Frontend/front_despacho/nginx.ecs.conf
docker-compose.yml
```

---

## Estado final del proyecto

El proyecto queda con:

- Ejecución local mediante Docker Compose.
- Imágenes Docker para frontend y backend.
- Repositorios ECR creados.
- Infraestructura creada con Terraform.
- ECS Fargate ejecutando frontend y backend.
- MySQL ejecutándose en EC2.
- Pipeline CI/CD con GitHub Actions.
- Logs disponibles en CloudWatch.
- Acceso público mediante la IP pública de la task ECS.