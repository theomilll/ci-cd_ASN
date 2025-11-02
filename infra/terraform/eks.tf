# EKS Cluster - usando cluster existente em account 325583868777
# O cluster eksDeepDiveFrankfurt já existe e foi criado pelo professor

# Data sources para referenciar recursos existentes
data "aws_eks_cluster" "existing" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "existing" {
  name = var.eks_cluster_name
}

# ConfigMap aws-auth para permitir acesso do CodeBuild
resource "null_resource" "update_aws_auth" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${var.eks_cluster_name} --region ${var.region} --profile lab

      kubectl get configmap aws-auth -n kube-system -o yaml > /tmp/aws-auth.yaml 2>/dev/null || \
      cat <<EOF > /tmp/aws-auth.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${data.aws_iam_role.codebuild_role.arn}
      username: codebuild
      groups:
        - system:masters
EOF

      # Se já existe, apenas adiciona o CodeBuild role
      if kubectl get configmap aws-auth -n kube-system >/dev/null 2>&1; then
        kubectl get configmap aws-auth -n kube-system -o yaml | \
        grep -q "${data.aws_iam_role.codebuild_role.arn}" || \
        kubectl get configmap aws-auth -n kube-system -o yaml | \
        sed "/mapRoles: |/a\\    - rolearn: ${data.aws_iam_role.codebuild_role.arn}\\n      username: codebuild\\n      groups:\\n        - system:masters" | \
        kubectl apply -f -
      else
        kubectl apply -f /tmp/aws-auth.yaml
      fi
    EOT
  }
}
