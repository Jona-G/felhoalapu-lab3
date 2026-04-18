terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    namespace     = "jonatanpribek-dev"
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

variable "openshift_server" {
  description = "Az OpenShift API cime"
  type        = string
}

variable "openshift_token" {
  description = "Az OpenShift hozzaferesi token"
  type        = string
  sensitive   = true
}

provider "kubernetes" {
  host  = var.openshift_server
  token = var.openshift_token
  
  insecure = true 
}