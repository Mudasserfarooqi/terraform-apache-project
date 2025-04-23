terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "apache" {
  name         = "httpd:2.4"
  keep_locally = false
}

resource "docker_container" "apache" {
  name  = "apache_server"
  image = docker_image.apache.name

  ports {
    internal = 80
    external = 9091
  }

  volumes {
    host_path      = abspath("${path.module}/../docker/apache/index.html")
    container_path = "/usr/local/apache2/htdocs/index.html"
    read_only      = true
  }

  log_driver = "fluentd"

  log_opts = {
    "fluentd-address" = "fluentd:24224"
    "fluentd-async"   = "true"
  }
}

resource "docker_container" "fluentd" {
  name  = "fluentd_log"
  image = "fluent/fluentd:v1.16-1"

  ports {
    internal = 24224
    external = 24224
  }

  volumes {
    host_path      = abspath("${path.module}/../docker/fluentd/fluent.conf")
    container_path = "/fluentd/etc/fluent.conf"
  }
}
