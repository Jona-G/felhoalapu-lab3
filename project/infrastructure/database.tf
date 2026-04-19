resource "kubernetes_persistent_volume_claim_v1" "postgres_pvc" {
  wait_until_bound = false
  metadata {
    name      = "postgres-data-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "postgres" {
  metadata {
    name      = "postgresdb"
    namespace = var.namespace
    labels = {
      "app"                       = "postgres"
      "app.kubernetes.io/part-of" = "photo-album-app"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "postgres" }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
          "app.kubernetes.io/part-of" = "photo-album-app"
      }
      spec {
        container {
          name  = "postgres"
          image = "registry.redhat.io/rhel8/postgresql-15:latest"
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
          volume_mount {
            name       = "db-storage"
            mount_path = "/var/lib/pgsql/data"
          }
        }
        volume {
          name = "db-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "postgres_svc" {
  metadata {
    name      = "postgresdb"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/part-of" = "photo-album-app"
    }
  }
  spec {
    selector = { app = "postgres" }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}