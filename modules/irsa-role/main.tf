terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [ aws ] 
    }
  }
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN (from EKS)"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL (from EKS)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the ServiceAccount"
  type        = string
}

variable "service_account_name" {
  description = "ServiceAccount name to bind IRSA with"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
}

variable "policy_json" {
  description = "IAM policy JSON content"
  type        = string
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.this.name
  policy = var.policy_json
}

output "role_arn" {
  value = aws_iam_role.this.arn
}
