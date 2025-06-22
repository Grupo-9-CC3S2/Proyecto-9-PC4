provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "app" {
    
  metadata {
    name = "miapp"
    labels = {
      app = "miapp"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "miapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "miapp"
        }
      }
      spec {
        container {
          name  = "miapp"
          image = "nginx:1.25"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "miapp-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.app.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}
