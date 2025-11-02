# todo-list-cicd

Infraestrutura e pipeline para entregar uma nova versão da app `dockersamples/todo-list-app` em um cluster EKS existente via AWS CodePipeline/CodeBuild, imagens no ECR e provisionamento Terraform.

## Estrutura

```
./
├─ todo-list-app/                # (opcional) código clonado do dockersamples
├─ infra/
│  ├─ terraform/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  └─ buildspecs/
│     ├─ buildspec_build.yml
│     └─ buildspec_deploy.yml
└─ k8s/
   └─ deployment.tmpl.yaml       # placeholder __IMAGE__ substituído no build
```

## Pré‑requisitos
- Conta AWS com permissões para ECR, CodePipeline, CodeBuild, S3, EKS e IAM (criar/passar roles do CodePipeline).
- Cluster EKS existente (padrão: `eksDeepDiveFrankfurt` na região `eu-central-1`).
- Service role de CodeBuild já existente e obrigatório: `arn:aws:iam::325583868777:role/service-role/codebuild-asn-demo-lab-service-role`.
- Conexão CodeStar com GitHub (será criada pelo Terraform e depois autorizada manualmente no Console AWS).
- Copie `.env.example` para `.env`, preencha `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` da conta **325583868777** e exporte-as (`set -a; source .env; set +a`) antes de rodar o Terraform.

## Uso

1) Clone do app (opcional como subpasta):
```
mkdir -p todo-list-app
# git clone https://github.com/dockersamples/todo-list-app ./todo-list-app
```

2) Terraform
```
cd infra/terraform
terraform init
terraform apply -auto-approve \
  -var="github_owner_repo=SEU-USUARIO/todo-list-cicd" \
  -var="region=eu-central-1"
```
Depois, no Console AWS → Developer Tools → Connections → autorize a conexão pendente com o GitHub. Se necessário, rode `terraform apply` novamente.

3) Disparar pipeline
- Faça um commit na branch `main` e `git push` para o seu repo público (o pipeline usa CodeStar Source). 

4) Ajustes comuns
- `var.app_path` (padrão: `todo-list-app`) aponte para o diretório com o Dockerfile do componente que deseja publicar.
- Se o Deploy falhar por permissão no cluster, mapeie o role do CodeBuild no `aws-auth` do EKS.

## Notas
- O stage Build cria e publica a imagem no ECR com tag do short SHA e gera `k8s/deployment.yaml` substituindo `__IMAGE__`.
- O stage Deploy aplica `k8s/deployment.yaml` no namespace `todo` e aguarda o rollout do `deploy/todo-app`.
