resource "kubernetes_deployment" "django_app" {
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
          image = "KEP_ELERESE_A_REGISTRYBOL"
          
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

resource "kubernetes_horizontal_pod_autoscaler" "django_hpa" {
  metadata {
    name      = "django-hpa"
    namespace = var.namespace
  }
  spec {
    max_replicas = 5
    min_replicas = 1
    target_cpu_utilization_percentage = 50
    scale_target_ref {
      kind = "Deployment"
      name = "django-album"
    }
  }
}