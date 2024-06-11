job "simple-microservice" {
  type = "service"

  group "web" {
    count = 1

    network {
      port "web" {
        static = 5000
      }
    }

    service {
      name     = "simple-microservice-svc"
      port     = "web"
      provider = "nomad"

      check {
        type     = "http"
        path     = "/greet"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "simple-microservice-task" {
      driver = "docker"

      config {
        image = "erioluwa66/simple-microservice:latest"
        ports = ["web"]
      }
    }
  }
}
