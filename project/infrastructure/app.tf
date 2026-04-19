resource "kubernetes_deployment_v1" "django_app" {
  metadata {
    name      = "felhoalapu-lab3"
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
          image = "image-registry.openshift-image-registry.svc:5000/jonatanpribek-dev/felhoalapu-lab3:latest"
          image_pull_policy = "Always"
          
          env {
            name  = "DATABASE_SERVICE_NAME"
            value = "postgresdb"
          }
          env {
            name  = "POSTGRESQL_USER"
            value = "myuser"
          }
          env {
            name  = "POSTGRESQL_PASSWORD"
            value = var.db_password
          }
          env {
            name  = "POSTGRESQL_DATABASE"
            value = "sampledb"
          }

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
      name = "felhoalapu-lab3"
    }
  }
}

resource "kubernetes_service_v1" "django_svc" {
  metadata {
    name      = "felhoalapu-lab3"
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
    name      = "felhoalapu-lab3-route"
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
      host = "felhoalapu-lab3-${var.namespace}.apps.rm1.0a51.p1.openshiftapps.com"
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