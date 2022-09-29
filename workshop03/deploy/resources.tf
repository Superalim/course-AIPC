data digitalocean_ssh_key mykey {
    name = "aipc"
}

data digitalocean_droplet_snapshot codeserver-snapshot {
  name_regex  = "codeserver"
  region      = "sgp1"
  most_recent = true
}

resource digitalocean_droplet droplet {
    name = "droplet"
    image  = data.digitalocean_droplet_snapshot.codeserver-snapshot.id
    region = var.DO_region
    size   = var.DO_size
    ssh_keys = [ data.digitalocean_ssh_key.mykey.id ]

    connection {
        type = "ssh"
        user = "root"
        host = self.ipv4_address
        private_key = file("./default")
    }
}

resource local_file nginx_conf {
    filename = "inventory.yaml"
    content = templatefile("inventory.yaml.tftpl", {
        droplet_ip = digitalocean_droplet.droplet.ipv4_address
        private_key = var.private_key
        codeserver_domain = "codeserver-${digitalocean_droplet.droplet.ipv4_address}.nip.io"
        codeserver_password = var.codeserver_password
    })
    file_permission = 644
}

output droplet_ip {
    description = "droplet ip"
    value = digitalocean_droplet.droplet.ipv4_address
}