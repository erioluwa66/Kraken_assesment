job "simple-microservice" {
  datacenters = ["dc1"]

  group "web" {
    count = 1

    task "server" {
      driver = "docker"

      config {
        image = "erioluwa66/simple-microservice:latest"
        port_map {
          http = 5000
        }
      }

      resources {
        cpu    = 250 # Reduced from 500 
        memory = 128 # Reduced from 256
      }

      service {
        name = "simple-microservice"
        port = "http"

        check {
          name     = "http"
          type     = "http"
          path     = "/greet"
          interval = "10s"
          timeout  = "2s"
        }
      }

      env {
        FLASK_ENV = "production"
      }

      restart {
        attempts = 2
        interval = "30m"
        delay    = "15s"
        mode     = "delay"
      }
    }

    network {
      port "http" {
        static = 5000
      }
    }
  }
}
