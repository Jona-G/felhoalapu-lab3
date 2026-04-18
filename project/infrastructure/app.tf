resource "kubernetes_deployment_v1" "django_app" {
  metadata {
    name      = "django-album"
    namespace = var.namespace
    labels = {
      "app"                           = "django"
      "app.kubernetes.io/part-of"     = "photo-album-app"
      "app.openshift.io/runtime"      = "python"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "django" }
    }
    template {
      metadata {
        labels = {
          "app"                       = "django"
          "app.kubernetes.io/part-of" = "photo-album-app"
        }
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

resource "kubernetes_service_v1" "django_svc" {
  metadata {
    name      = "django-album"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/part-of" = "photo-album-app"
    }
  }
  spec {
    selector = {
      "app" = "django"
    }
    port {
      port        = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_ingress_v1" "django_route" {
  metadata {
    name      = "django-album-route"
    namespace = var.namespace
    annotations = {
      "route.openshift.io/termination" = "edge"
      
      "app.openshift.io/v1-alpha1.route-type" = "http"
    }
    labels = {
      "app.kubernetes.io/part-of" = "photo-album-app"
    }
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.django_svc.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}