locals {
  name   = "eks-argocd-demo"
  region = "us-west-2"
  env    = "demo"

  cluster_version = "1.22"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}