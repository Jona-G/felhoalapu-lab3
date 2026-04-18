resource "kubernetes_deployment_v1" "django_app" {
  metadata {
    name      = "django-album"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "django" }
    }
    template {
      metadata {
        labels = { app = "django" }
      }
      spec {
        container {
          name  = "django"
          image = "image-registry.openshift-image-registry.svc:5000/jonatanpribek-dev/felhoalapu-lab3@sha256:c868a0a5868fe7b5921c012396159da4ae1688718ce5fcc2ea67c6f6058d5c70"
          
          resources {
            limits = {
              cpu    = "200m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v1" "django_hpa" {
  metadata {
    name      = "django-hpa"
    namespace = var.namespace
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    target_cpu_utilization_percentage = 50
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = "django-album"
    }
  }
}