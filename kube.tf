provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:eu-central-1:806239338218:cluster/yad2-eks"
}


#------------namespaces--------------
resource "kubernetes_namespace" "example" {
  metadata {
    name = "yad2-go"
  }
}


#-----------deployments--------------
resource "kubernetes_deployment" "example" {
  metadata {
    name = "yad2-go"
    namespace = "yad2-go"
    labels = {
      app = "yad2-go"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "yad2-go"
      }
    }
    template {
      metadata {
        labels = {
          app = "yad2-go"
        }
      }
      spec {
        container {
          image = "jhonyvsn1992/yad2-go:master-88faf0309e2e24f07c0dc9dfcf0572a91e9b3264"
          name  = "yad2-go"
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "example" {
  metadata {
    name = "yad2-go"
    namespace = "yad2-go"
  }
  spec {
    selector = {
      app = "yad2-go"
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
