variable DO_token {
    type = string
    sensitive = true
}

variable DO_region {
    type = string
    default = "sgp1"
}

variable DO_size {
    type = string
    default = "s-1vcpu-2gb"
}

variable DO_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable codeserver_password {
  type = string
  sensitive = true
}

variable private_key {
  type = string
}