terraform {
  required_version = ">= 1.2.9"
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.22.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.22.3"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "digitalocean" {
  token = var.DO_token
}

provider local {}