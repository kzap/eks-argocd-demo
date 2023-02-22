################################################################################
# Kubernetes Addons
################################################################################

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.24.0"

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version

  enable_argocd = true
  # This example shows how to set default ArgoCD Admin Password using SecretsManager with Helm Chart set_sensitive values.
  argocd_helm_config = {
    name             = "argocd"
    repository       = "${path.module}/"
    namespace        = "argocd"
    timeout          = "1200"
    create_namespace = true
    values = [
      templatefile(
        "${path.module}/argo-cd/values.yaml.tftpl",
        {
          env                = local.env
        }
      )
    ]
  }

  argocd_manage_add_ons = false # Indicates that ArgoCD is responsible for managing/deploying add-ons
  
  # EKS Addons via Helm instead of EKS module
  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  # Other Addons
  enable_cert_manager                   = true
  enable_cluster_autoscaler             = false
  enable_karpenter                      = false
  enable_keda                           = false
  enable_metrics_server                 = true
  enable_prometheus                     = false
  enable_vpa                            = false

  tags = local.tags
}