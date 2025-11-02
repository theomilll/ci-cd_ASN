variable "project_name" {
  description = "Prefixo para nomear recursos"
  type        = string
  default     = "todo-app"
}

variable "region" {
  description = "Região AWS"
  type        = string
  default     = "eu-central-1" # Frankfurt (ajuste se necessário)
}

variable "github_owner_repo" {
  description = "Formato: owner/repo do seu repo público"
  type        = string
  # exemplo: "seu-usuario/todo-list-cicd"
}

variable "github_branch" {
  description = "Branch de origem do pipeline"
  type        = string
  default     = "main"
}

variable "codestar_connection_name" {
  description = "Nome amigável da conexão GitHub (CodeStar Connections)"
  type        = string
  default     = "github-connection"
}

variable "ecr_repo_name" {
  description = "Nome do repositório ECR"
  type        = string
  default     = "todo-list-app"
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS existente"
  type        = string
  default     = "eksDeepDiveFrankfurt"
}

variable "k8s_namespace" {
  description = "Namespace para deploy"
  type        = string
  default     = "todo"
}

variable "app_path" {
  description = "Caminho onde está o Dockerfile para build (ex.: todo-frontend)"
  type        = string
  default     = "todo-list-app"
}

variable "codebuild_service_role_arn" {
  description = "Role obrigatório para TODOS os CodeBuild"
  type        = string
  default     = "arn:aws:iam::325583868777:role/service-role/codebuild-asn-demo-lab-service-role"
}
